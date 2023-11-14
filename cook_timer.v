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
	wire alarm_off;		//�˶��� ������� ���� ����
	assign t_start_stop = start ? 1 : (alarm_start ? 1 : 0);
	//Ÿ�̸Ӱ� �� �Ǿ 16bit OR���� ���� 0�� �Ǹ� start_stop�� ���������(start_stop�� �ȸ��߸� ��� �ٿ�ī���� �ϱ� ����)
	//�̸� ���� t_start_stop�� ����Ͽ� start��ư�� ���¸� ��������
	//btn[0]���� ������ start�� 1�̸� t_start_stop�� 1�� ����ϰ� start = 0�̸鼭 alarm_start = 1�̸� 1 �ƴϸ� 0�� ����Ѵ�
	button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(start));		//start��ư�� cntr
	//
	T_flip_flop_p tff1(.clk(clk), .t(t_start_stop), .reset_p(reset_p), .q(start_stop));			//t_start_stop�� �Է����� �ش�
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//�� ��� ��ư�� cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//�� ��� ��ư�� cntr
	
	//button_cntr bcntr_on_off(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_ne(alarm_off));		//�˶� ��ư on/off
	//���� �ʴ� ������ reset_p�� ����� ���̱� ������ ��ٿ�� , ���������� �ʿ䰡 ����
	wire [3:0] sec1_set, sec10_set;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .dec1(sec1_set), .dec10(sec10_set));
	//��ī����60�� ����Ͽ� sec�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش� 
	wire [3:0] min1_set, min10_set;
	counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .dec1(min1_set), .dec10(min10_set));
	//��ī����60�� ����Ͽ� min�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش�
	
	reg [15:0] set_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) set_time = 0;		
		else set_time = {min10_set, min1_set, sec10_set, sec1_set}; 
	end
	//set_time(�˶� ���� �ð�)�� ����ϱ� ���� set_time�� ������ش�.
	
	 wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	
	wire clk_start, load_enable, dec_clk;
    //and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
    
    assign clk_start = start_stop ? 0 : clk_sec; 
    assign load_enable = ~start_stop ? 0 : start;
    //and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
	
	wire [3:0] sec1, sec10;
	loadable_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_enable), .set_value1(sec1_set), .set_value10(sec10_set),
       .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
       
       wire [3:0] min1, min10;
	loadable_down_counter_dec_60 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set),
       .dec1(min1), .dec10(min10));
       
	//Ÿ�̸Ӱ� �� �Ǿ��� ��(0��0�ʰ� �Ǿ��� ��)�� �����Ϸ��� count_time�� 16��Ʈ�� ��� OR������ �ϸ� �ȴ�.
	//������ �ʱ� count_time ���� 0�̹Ƿ� �ٷ� Ÿ�̸Ӱ� �� ���� �������� �ʱ� ���� 16��Ʈ�� ��� OR������ ���� Falling Edge�϶��� �����ϸ� �ȴ�.
	
	assign timeout = |count_time;
	//OR�� �������� ���� ������ ��� ��Ʈ�鳢�� ��� ������ ����� ÷���Ѵ�
	
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
	wire alarm_off;		//�˶��� ������� ���� ����
	assign t_start_stop = start ? 1 : (alarm_start ? 1 : 0);
	//Ÿ�̸Ӱ� �� �Ǿ 16bit OR���� ���� 0�� �Ǹ� start_stop�� ���������(start_stop�� �ȸ��߸� ��� �ٿ�ī���� �ϱ� ����)
	//�̸� ���� t_start_stop�� ����Ͽ� start��ư�� ���¸� ��������
	//btn[0]���� ������ start�� 1�̸� t_start_stop�� 1�� ����ϰ� start = 0�̸鼭 alarm_start = 1�̸� 1 �ƴϸ� 0�� ����Ѵ�
	button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(start));		//start��ư�� cntr
	//
	T_flip_flop_p tff1(.clk(clk), .t(t_start_stop), .reset_p(reset_p), .q(start_stop));			//t_start_stop�� �Է����� �ش�
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//�� ��� ��ư�� cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//�� ��� ��ư�� cntr
	
	//button_cntr bcntr_on_off(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_ne(alarm_off));		//�˶� ��ư on/off
	//���� �ʴ� ������ reset_p�� ����� ���̱� ������ ��ٿ�� , ���������� �ʿ䰡 ����
	wire [3:0] sec1_set, sec10_set;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .dec1(sec1_set), .dec10(sec10_set));
	//��ī����60�� ����Ͽ� sec�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش� 
	wire [3:0] min1_set, min10_set;
	counter_dec_100_pro up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .dec1(min1_set), .dec10(min10_set));
	//��ī����60�� ����Ͽ� min�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش�
	
	reg [15:0] set_time;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) set_time = 0;		
		else set_time = {min10_set, min1_set, sec10_set, sec1_set}; 
	end
	//set_time(�˶� ���� �ð�)�� ����ϱ� ���� set_time�� ������ش�.
	
	 wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	
	wire clk_start, load_enable, dec_clk;
    //and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
    
    assign clk_start = start_stop ? 0 : clk_sec; 
    assign load_enable = ~start_stop ? 0 : start;
    //and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
	
	wire [3:0] sec1, sec10;
	loadable_down_counter_dec_60 dc_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_enable), .set_value1(sec1_set), .set_value10(sec10_set),
       .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
       
       wire [3:0] min1, min10;
	loadable_down_counter_dec_100 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set),
       .dec1(min1), .dec10(min10));
       
	//Ÿ�̸Ӱ� �� �Ǿ��� ��(0��0�ʰ� �Ǿ��� ��)�� �����Ϸ��� count_time�� 16��Ʈ�� ��� OR������ �ϸ� �ȴ�.
	//������ �ʱ� count_time ���� 0�̹Ƿ� �ٷ� Ÿ�̸Ӱ� �� ���� �������� �ʱ� ���� 16��Ʈ�� ��� OR������ ���� Falling Edge�϶��� �����ϸ� �ȴ�.
	
	assign timeout = |count_time;
	//OR�� �������� ���� ������ ��� ��Ʈ�鳢�� ��� ������ ����� ÷���Ѵ�
	
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




































