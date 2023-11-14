`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 09:13:52
// Design Name: 
// Module Name: cook_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cook_timer(
	input clk, reset_p,
	input [3:0] btn,
	output [7:0] led_bar,
	output [3:0] com,
	output [7:0] seg_7
	);

	wire start_stop, incsec, incmin;
	wire timeout, alarm_start;
	wire t_start_stop;
	wire alarm_off;		//알람이 울렸으면 끄기 위함
	assign t_start_stop = start ? 1 : (alarm_start ? 1 : 0);
	//타이머가 다 되어서 16bit OR취한 값이 0이 되면 start_stop을 멈춰줘야함(start_stop을 안멈추면 계속 다운카운터 하기 때문)
	//이를 위해 t_start_stop을 사용하여 start버튼의 상태를 조절해줌
	//btn[0]에서 나오는 start가 1이면 t_start_stop에 1을 출력하고 start = 0이면서 alarm_start = 1이면 1 아니면 0을 출력한다
	button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(start));		//start버튼의 cntr
	//
	T_flip_flop_p tff1(.clk(clk), .t(t_start_stop), .reset_p(reset_p), .q(start_stop));			//t_start_stop을 입력으로 준다
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//초 상승 버튼의 cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//분 상승 버튼의 cntr
	
	//button_cntr bcntr_on_off(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_ne(alarm_off));		//알람 버튼 on/off
	//쓰지 않는 이유는 reset_p를 사용할 것이기 때문에 디바운싱 , 에지디텍터 필요가 없음
	wire [3:0] sec1_set, sec10_set;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .dec1(sec1_set), .dec10(sec10_set));
	//업카운터60을 사용하여 sec의 1의자리와 10의 자리를 버튼이 눌러지는 만큼 set해준다 
	wire [3:0] min1_set, min10_set;
	counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .dec1(min1_set), .dec10(min10_set));
	//업카운터60을 사용하여 min의 1의자리와 10의 자리를 버튼이 눌러지는 만큼 set해준다
	
	reg [15:0] set_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) set_time = 0;		
		else set_time = {min10_set, min1_set, sec10_set, sec1_set}; 
	end
	//set_time(알람 저장 시간)을 출력하기 위한 set_time을 만들어준다.
	
	 wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	
	wire clk_start, load_enable, dec_clk;
    //and(clk_start, clk_msec, start_stop);		//이렇게 and게이트로 묶어서 clk_sec의 출력을 막으려함
    
    assign clk_start = start_stop ? 0 : clk_sec; 
    assign load_enable = ~start_stop ? 0 : start;
    //and gate를 쓰지 않고 이렇게 쓰는 이유는 FPGA안에 LUT들의 구조로 이루어져 있어 MUX로 구현
	
	wire [3:0] sec1, sec10;
	loadable_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_enable), .set_value1(sec1_set), .set_value10(sec10_set),
       .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
       
       wire [3:0] min1, min10;
	loadable_down_counter_dec_60 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set),
       .dec1(min1), .dec10(min10));
       
	//타이머가 다 되었을 때(0분0초가 되었을 때)를 감지하려면 count_time의 16비트를 모두 OR연산을 하면 된다.
	//하지만 초기 count_time 값이 0이므로 바로 타이머가 다 됨을 감지하지 않기 위해 16비트를 모두 OR연산한 값이 Falling Edge일때를 감지하면 된다.
	
	assign timeout = |count_time;
	//OR를 단항으로 쓰면 변수를 모두 비트들끼리 모두 연산한 결과를 첨부한다
	
	edge_detector_n ed_timeout(.clk(clk), .cp_in(timeout), .reset_p(reset_p), .n_edge(alarm_start));
	
	wire alarm;// t_alarm;
	//assign t_alarm = alarm_start ? 1 : (alarm_off ? 1 : 0);
	assign alarm_off = |{~btn[0], ~btn[1], ~btn[2], btn[3], reset_p};
	T_flip_flop_p tff_alarm_on_off(.clk(clk), .t(alarm_start), .reset_p(alarm_off), .q(alarm));
	assign led_bar[0] = alarm;
	
	reg [15:0] count_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) count_time = 0;		
		else count_time = {min10, min1, sec10, sec1}; 
	end
	
	wire [15:0] value;
	assign value = start_stop ? set_time : count_time;
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 
	
endmodule


module cook_timer_project(
	input clk, reset_p,
	input [3:0] btn,
    output [15:0] value_cook_timer,
    output buzzer
	);
 
	wire start_stop, incsec, incmin;
	wire timeout, alarm_start;
	wire t_start_stop;
	wire alarm_off;		//알람이 울렸으면 끄기 위함
	assign t_start_stop = start ? 1 : (alarm_start ? 1 : 0);
	//타이머가 다 되어서 16bit OR취한 값이 0이 되면 start_stop을 멈춰줘야함(start_stop을 안멈추면 계속 다운카운터 하기 때문)
	//이를 위해 t_start_stop을 사용하여 start버튼의 상태를 조절해줌
	//btn[0]에서 나오는 start가 1이면 t_start_stop에 1을 출력하고 start = 0이면서 alarm_start = 1이면 1 아니면 0을 출력한다
	button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(start));		//start버튼의 cntr
	//
	T_flip_flop_p tff1(.clk(clk), .t(t_start_stop), .reset_p(reset_p), .q(start_stop));			//t_start_stop을 입력으로 준다
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//초 상승 버튼의 cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//분 상승 버튼의 cntr
	
	//button_cntr bcntr_on_off(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_ne(alarm_off));		//알람 버튼 on/off
	//쓰지 않는 이유는 reset_p를 사용할 것이기 때문에 디바운싱 , 에지디텍터 필요가 없음
	wire [3:0] sec1_set, sec10_set;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .dec1(sec1_set), .dec10(sec10_set));
	//업카운터60을 사용하여 sec의 1의자리와 10의 자리를 버튼이 눌러지는 만큼 set해준다 
	wire [3:0] min1_set, min10_set;
	counter_dec_100_pro up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .dec1(min1_set), .dec10(min10_set));
	//업카운터60을 사용하여 min의 1의자리와 10의 자리를 버튼이 눌러지는 만큼 set해준다
	
	reg [15:0] set_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) set_time = 0;		
		else set_time = {min10_set, min1_set, sec10_set, sec1_set}; 
	end
	//set_time(알람 저장 시간)을 출력하기 위한 set_time을 만들어준다.
	
	 wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	
	wire clk_start, load_enable, dec_clk;
    //and(clk_start, clk_msec, start_stop);		//이렇게 and게이트로 묶어서 clk_sec의 출력을 막으려함
    
    assign clk_start = start_stop ? 0 : clk_sec; 
    assign load_enable = ~start_stop ? 0 : start;
    //and gate를 쓰지 않고 이렇게 쓰는 이유는 FPGA안에 LUT들의 구조로 이루어져 있어 MUX로 구현
	
	wire [3:0] sec1, sec10;
	loadable_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_enable), .set_value1(sec1_set), .set_value10(sec10_set),
       .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
       
       wire [3:0] min1, min10;
	loadable_down_counter_dec_100 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set),
       .dec1(min1), .dec10(min10));
       
	//타이머가 다 되었을 때(0분0초가 되었을 때)를 감지하려면 count_time의 16비트를 모두 OR연산을 하면 된다.
	//하지만 초기 count_time 값이 0이므로 바로 타이머가 다 됨을 감지하지 않기 위해 16비트를 모두 OR연산한 값이 Falling Edge일때를 감지하면 된다.
	
	assign timeout = |count_time;
	//OR를 단항으로 쓰면 변수를 모두 비트들끼리 모두 연산한 결과를 첨부한다
	
	edge_detector_n ed_timeout(.clk(clk), .cp_in(timeout), .reset_p(reset_p), .n_edge(alarm_start));
	
	wire alarm;// t_alarm;
	//assign t_alarm = alarm_start ? 1 : (alarm_off ? 1 : 0);
	assign alarm_off = |{~btn[0], ~btn[1], ~btn[2], btn[3], reset_p};
	T_flip_flop_p tff_alarm_on_off(.clk(clk), .t(alarm_start), .reset_p(alarm_off), .q(alarm));
	assign buzzer = alarm;

	reg [15:0] count_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) count_time = 0;		
		else count_time = {min10, min1, sec10, sec1}; 
	end
	
	assign value_cook_timer = start_stop ? set_time : count_time;
	
endmodule




































