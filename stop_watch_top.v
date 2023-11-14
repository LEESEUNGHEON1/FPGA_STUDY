`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/23 14:30:33
// Design Name: 
// Module Name: stop_watch_top
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

/*==================================================================================================*/
module stop_watch_top(
    input clk,
    input reset_p,
    input [1:0] btn,
    input btn1,
    output [3:0] com,
    output [7:0] seg_7,
    output [7:0] led_bar 		//LED�� Ȱ���Ͽ� ����� �ϱ� ���� ���
    );
    
    reg [16 : 0] clk_div;
    wire btn_start, start_stop;
    wire [1:0] debounced_btn;
     
    always @(posedge clk)clk_div = clk_div+1;
    
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    D_flip_flop_p dff0(.d(btn[0]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[0]));            //��1ms		0�϶� stop, 1�϶� start
    //D f/f�� bouncing �����ϰ�
    edge_detector_n ed_start(.clk(clk), .cp_in(debounced_btn[0]), .reset_p(reset_p), .n_edge(btn_start));
    //���������ͷ� edge��Ƽ� T�� �Է�����
    T_flip_flop_p tff0(.clk(clk), .t(btn_start), .reset_p(reset_p), .q(start_stop));
    //��ư�� ���� �� ��۵ǰ� T F/F ���
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    
    
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    wire lab, btn_lap;
    D_flip_flop_p dff1(.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));
    edge_detector_n ed_lab(.clk(clk), .cp_in(debounced_btn[1]), .reset_p(reset_p), .n_edge(btn_lap));
    T_flip_flop_p tff1(.clk(clk), .t(btn_lap), .reset_p(reset_p), .q(lap));
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    
    assign led_bar[0] = debounced_btn[1];		//��ư�� ���������� LED�� Ȯ���ϱ� ����
    assign led_bar[1] = btn_lap;				//edge_detector�� ����̶� ���� ª�� ������ Ȯ���ϱ� ����� ����
    assign led_bar[2] = lap;
    
    wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_div_1000 msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    wire clk_start;
    //and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
    
    assign clk_start = start_stop ? 0 : clk_msec; 
    //and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_div_1000(clk_sec));		//clk_sec�� ����� ���ƹ����� sec, min�� ������ ���� ���� �׷��� clk_sec�� �Է��� msec�� �������
    clock_min min_clk(.clk(clk), .clk_sec(clk_sec), .reset_p(reset_p), .clk_min(clk_min));
    
    wire [3:0] sec1, sec10;
    wire [3:0] min1, min10;    
    
    counter_dec_60 dec_sec_60 (.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    counter_dec_60 dec_min_60 (.clk(clk), .reset_p(reset_p), .clk_time(clk_min), .dec1(min1), .dec10(min10));
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
	reg [15:0] lap_value;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) lap_value = 0;		//lap value CLR
		else if(btn_lap) lap_value = {min10, min1, sec10, sec1}; 
	end
	
	wire [15:0] value;
	assign value = lap ? lap_value : {min10, min1, sec10, sec1};
   //-------------------------------LAB_FUNTION-------------------------------------------------//
 
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 
    
endmodule
/*==================================================================================================*/


//msec 1000���ִϱ� bin to dec�� ����ϸ� 0~999���� 
//bin to dec ����� 4�� bit ���� 11�� bit���� ©�� ����ϸ� 1/100

/*==================================================================================================*/
module stop_watch_2(
	input clk, 
	input reset_p,
	input [1:0] btn,
	output [3:0] com,
   	output [7:0] seg_7,
    	output [7:0] led_bar 		//LED�� Ȱ���Ͽ� ����� �ϱ� ���� ���
	);
	
	reg [16 : 0] clk_div;
	wire btn_start, start_stop;
	wire [1:0] debounced_btn;	
	
	always @(posedge clk)clk_div = clk_div+1;
	
	//-----------------------START_STOP_BOTTON--------------------------------------------------//
	D_flip_flop_p dff0(.d(btn[0]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[0]));            //��1ms		0�϶� stop, 1�϶� start
	//D f/f�� bouncing �����ϰ�
	edge_detector_n ed_start(.clk(clk), .cp_in(debounced_btn[0]), .reset_p(reset_p), .n_edge(btn_start));
	//���������ͷ� edge��Ƽ� T�� �Է�����
	T_flip_flop_p tff0(.clk(clk), .t(btn_start), .reset_p(reset_p), .q(start_stop));
	//��ư�� ���� �� ��۵ǰ� T F/F ���
	//-----------------------START_STOP_BOTTON--------------------------------------------------//
	
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	wire lab, btn_lap;
	D_flip_flop_p dff1(.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));
	edge_detector_n ed_lab(.clk(clk), .cp_in(debounced_btn[1]), .reset_p(reset_p), .n_edge(btn_lap));
	T_flip_flop_p tff1(.clk(clk), .t(btn_lap), .reset_p(reset_p), .q(lap));
	//-------------------------------LAB_FUNTION-------------------------------------------------//
    
	assign led_bar[0] = debounced_btn[1];		//��ư�� ���������� LED�� Ȯ���ϱ� ����
	assign led_bar[1] = btn_lap;				//edge_detector�� ����̶� ���� ª�� ������ Ȯ���ϱ� ����� ����
	assign led_bar[2] = lap;
	
	wire clk_usec, clk_msec, clk_sec;
	
	clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
	
	wire clk_start;
	//and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
	
	assign clk_start = start_stop ? 0 : clk_usec; 
	//and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
	
	//clock_msec msec_clk (.clk(clk), .clk_usec(clk_start), .reset_p(reset_p), .clk_msec(clk_msec));
	//clock_sec sec_clk (.clk(clk), .clk_msec(clk_msec), .reset_p(reset_p), .clk_sec(clk_sec));
	clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_start), .reset_p(reset_p), .clk_div_1000(clk_msec));
	clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));
	
	
	
	wire [3:0] sec1, sec10;
    	wire [3:0] msec1, msec10;    
    
    	counter_dec_10 dec_sec (.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
	counter_dec_100 dec_msec_100(.clk(clk), .reset_p(reset_p), .clk_time(clk_msec), .dec10(msec1), .dec100(msec10));
	
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	reg [15:0] lap_value;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) lap_value = 0;		//lap value CLR
		else if(btn_lap) lap_value = {sec10, sec1, msec10, msec1}; 
	end
	
	wire [15:0] value;
	assign value = lap ? lap_value : {sec10, sec1, msec10, msec1};
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 
	
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
module stop_watch_pro(
	input clk, 
	input reset_p,
	input [1:0] btn,
	output [3:0] com,
   	output [7:0] seg_7,
    	output [7:0] led_bar 		//LED�� Ȱ���Ͽ� ����� �ϱ� ���� ���
	);
	
	reg [16 : 0] clk_div;
	wire btn_start, start_stop;
	wire [1:0] debounced_btn;	
	
	always @(posedge clk)clk_div = clk_div+1;
	
	//-----------------------START_STOP_BOTTON--------------------------------------------------//
	D_flip_flop_p dff0(.d(btn[0]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[0]));            //��1ms		0�϶� stop, 1�϶� start
	//D f/f�� bouncing �����ϰ�
	edge_detector_n ed_start(.clk(clk), .cp_in(debounced_btn[0]), .reset_p(reset_p), .n_edge(btn_start));
	//���������ͷ� edge��Ƽ� T�� �Է�����
	T_flip_flop_p tff0(.clk(clk), .t(btn_start), .reset_p(reset_p), .q(start_stop));
	//��ư�� ���� �� ��۵ǰ� T F/F ���
	//-----------------------START_STOP_BOTTON--------------------------------------------------//
	
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	wire lab, btn_lap;
	D_flip_flop_p dff1(.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));
	edge_detector_n ed_lab(.clk(clk), .cp_in(debounced_btn[1]), .reset_p(reset_p), .n_edge(btn_lap));
	T_flip_flop_p tff1(.clk(clk), .t(btn_lap), .reset_p(reset_p), .q(lap));
	//-------------------------------LAB_FUNTION-------------------------------------------------//
    
	assign led_bar[0] = debounced_btn[1];		//��ư�� ���������� LED�� Ȯ���ϱ� ����
	assign led_bar[1] = btn_lap;				//edge_detector�� ����̶� ���� ª�� ������ Ȯ���ϱ� ����� ����
	assign led_bar[2] = lap;
	
	wire clk_usec, clk_msec, clk_sec;
	
	clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
	
	
	
	
	
	//clock_msec msec_clk (.clk(clk), .clk_usec(clk_start), .reset_p(reset_p), .clk_msec(clk_msec));
	//clock_sec sec_clk (.clk(clk), .clk_msec(clk_msec), .reset_p(reset_p), .clk_sec(clk_sec));
	
	
	reg [9:0] cnt_clk_msec;
	
	always @(posedge clk_msec or posedge reset_p)begin
        	if(reset_p) cnt_clk_msec = 0;         
       	 	else if(clk_msec)begin                         
            		if(cnt_clk_msec >= 999)begin
                	cnt_clk_msec = 0;  
            		end
            		else cnt_clk_msec = cnt_clk_msec + 1;
        	end
    	end
	
	wire [15:0] msec;
	bin_to_dec(.bin({2'b00, cnt_clk_msec}), .bcd(msec)); 
	
	wire clk_start;
	//and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
	assign clk_start = start_stop ? 0 : clk_usec; 
	//and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
	clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_start), .reset_p(reset_p), .clk_div_1000(clk_msec));
	clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));
	
	wire [3:0] sec1, sec10;
    	wire [3:0] msec1, msec10;    

    	counter_dec_60 dec_sec_60 (.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    	counter_dec_60 dec_min_60 (.clk(clk), .reset_p(reset_p), .clk_time(clk_min), .dec1(min1), .dec10(min10));
	
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	reg [15:0] lap_value;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) lap_value = 0;		//lap value CLR
		else if(btn_lap) lap_value = {sec10, sec1, msec[11:4]}; 
	end
	
	wire [15:0] value;
	assign value = lap ? lap_value : {sec10, sec1, msec[11:4]};
	//-------------------------------LAB_FUNTION-------------------------------------------------//
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 
	
endmodule

/*==================================================================================================*/

/*==================================================================================================*/
module stop_watch_top_pro2_counter100_top(			//10msec  100���� ���� 1s�� ����, 10msec�� ���� clk�� �ʿ���
    input clk,
    input reset_p,
    input [3:0] btn,
    output [3:0] com,
    output [7:0] seg_7,
    output [7:0] led_bar 		//LED�� Ȱ���Ͽ� ����� �ϱ� ���� ���
    );
    
    reg [16 : 0] clk_div;
    wire btn_start, start_stop;
    wire [1:0] debounced_btn;
     
    always @(posedge clk)clk_div = clk_div+1;
    
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    D_flip_flop_p dff0(.d(btn[0]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[0]));            //��1ms		0�϶� stop, 1�϶� start
    //D f/f�� bouncing �����ϰ�
    edge_detector_n ed_start(.clk(clk), .cp_in(debounced_btn[0]), .reset_p(reset_p), .n_edge(btn_start));
    //���������ͷ� edge��Ƽ� T�� �Է�����
    T_flip_flop_p tff0(.clk(clk), .t(btn_start), .reset_p(reset_p), .q(start_stop));
    //��ư�� ���� �� ��۵ǰ� T F/F ���
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    
    
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    wire lab, btn_lap;
    D_flip_flop_p dff1(.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));
    edge_detector_n ed_lab(.clk(clk), .cp_in(debounced_btn[1]), .reset_p(reset_p), .n_edge(btn_lap));
    T_flip_flop_p tff1(.clk(clk), .t(btn_lap), .reset_p(reset_p), .q(lap));
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    
    assign led_bar[0] = debounced_btn[1];		//��ư�� ���������� LED�� Ȯ���ϱ� ����
    assign led_bar[1] = btn_lap;				//edge_detector�� ����̶� ���� ª�� ������ Ȯ���ϱ� ����� ����
    assign led_bar[2] = lap;
    
    wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    
    
    wire clk_start;
    //and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
    
    assign clk_start = start_stop ? 0 : clk_usec; 
    //and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
    
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_start), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));		//clk_sec�� ����� ���ƹ����� sec, min�� ������ ���� ���� �׷��� clk_sec�� �Է��� msec�� �������

	wire clk_10msec;    
    clock_div_10 A(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_10(clk_10msec));
    
    wire [3:0] csec1, csec10;
    counter_dec_100_pro A1(.clk(clk), .reset_p(reset_p), .clk_time(clk_10msec), .dec1(csec1), .dec10(csec10));
    
    wire [3:0] sec1, sec10;
    
    counter_dec_60 dec_sec_60(.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
	reg [15:0] lap_value;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) lap_value = 0;		//lap value CLR
		else if(btn_lap) lap_value = {sec10, sec1, csec10, csec1}; 
	end
	
	wire [15:0] value;
	assign value = lap ? lap_value : {sec10, sec1, csec10, csec1};
   //-------------------------------LAB_FUNTION-------------------------------------------------//
 
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 
    
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
module stop_watch_top_pro2_counter100_top_project(			//10msec  100���� ���� 1s�� ����, 10msec�� ���� clk�� �ʿ���
    input clk,
    input reset_p,
    input [3:0] btn,
    output [15:0] value_stop_watch
    );
    
    reg [16 : 0] clk_div;
    wire btn_start, start_stop;
    wire [1:0] debounced_btn;
     
    always @(posedge clk)clk_div = clk_div+1;
    
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    D_flip_flop_p dff0(.d(btn[0]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[0]));            //��1ms		0�϶� stop, 1�϶� start
    //D f/f�� bouncing �����ϰ�
    edge_detector_n ed_start(.clk(clk), .cp_in(debounced_btn[0]), .reset_p(reset_p), .n_edge(btn_start));
    //���������ͷ� edge��Ƽ� T�� �Է�����
    T_flip_flop_p tff0(.clk(clk), .t(btn_start), .reset_p(reset_p), .q(start_stop));
    //��ư�� ���� �� ��۵ǰ� T F/F ���
    //-----------------------START_STOP_BOTTON--------------------------------------------------//
    
    
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    wire lab, btn_lap;
    D_flip_flop_p dff1(.d(btn[1]), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn[1]));
    edge_detector_n ed_lab(.clk(clk), .cp_in(debounced_btn[1]), .reset_p(reset_p), .n_edge(btn_lap));
    T_flip_flop_p tff1(.clk(clk), .t(btn_lap), .reset_p(reset_p), .q(lap));
    //-------------------------------LAB_FUNTION-------------------------------------------------//
    
    wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    //clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    
    
    wire clk_start;
    //and(clk_start, clk_msec, start_stop);		//�̷��� and����Ʈ�� ��� clk_sec�� ����� ��������
    
    assign clk_start = start_stop ? 0 : clk_usec; 
    //and gate�� ���� �ʰ� �̷��� ���� ������ FPGA�ȿ� LUT���� ������ �̷���� �־� MUX�� ����
    
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_start), .reset_p(reset_p), .clk_div_1000(clk_msec));
    
    //clock_sec sec_clk (.clk(clk), .clk_msec(clk_start), .reset_p(reset_p), .clk_sec(clk_sec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));		//clk_sec�� ����� ���ƹ����� sec, min�� ������ ���� ���� �׷��� clk_sec�� �Է��� msec�� �������

	wire clk_10msec;    
    clock_div_10 A(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_10(clk_10msec));
    
    wire [3:0] csec1, csec10;
    counter_dec_100_pro A1(.clk(clk), .reset_p(reset_p), .clk_time(clk_10msec), .dec1(csec1), .dec10(csec10));
    
    wire [3:0] sec1, sec10;
    
    counter_dec_60 dec_sec_60(.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    
    //-------------------------------LAB_FUNTION-------------------------------------------------//
	reg [15:0] lap_value;
	always @(posedge clk or posedge reset_p) begin
		if(reset_p) lap_value = 0;		//lap value CLR
		else if(btn_lap) lap_value = {sec10, sec1, csec10, csec1}; 
	end

	assign value_stop_watch = lap ? lap_value : {sec10, sec1, csec10, csec1};
   //-------------------------------LAB_FUNTION-------------------------------------------------//
 
endmodule
/*==================================================================================================*/






































