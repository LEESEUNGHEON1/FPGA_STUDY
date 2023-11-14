`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/11 09:20:02
// Design Name: 
// Module Name: watch_top
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
module watch_top(
	input clk, reset_p,
	input [2:0] btn,
	output [3:0] com,
	output [7:0] seg_7
	);
	
	wire incsec, incmin;
	
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//�� ��� ��ư�� cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//�� ��� ��ư�� cntr
	
	wire clk_usec, clk_msec, clk_sec, clk_min;
	
	clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
	 clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
	 clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	 clock_min(.clk(clk), .clk_sec(clk_sec), .reset_p(reset_p), .clk_min(clk_min));
	
	wire incsec_or, incmin_or;
	
	assign incsec_or = clk_sec ? 1 : incsec ? 1 : 0; 
	//incsec | clk_sec;  ������ �𵨸�
	//assign incsec_or = clk_sec ? 1 : incsec ? 1 : 0;
	//������ ����
	
	wire [3:0] sec1, sec10;
	wire dec_clk;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec_or), .dec1(sec1), .dec10(sec10), .dec_clk(dec_clk));
	//��ī����60�� ����Ͽ� sec�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش� 
	//assign incmin_or = dec_clk | incmin;
	assign incmin_or = dec_clk ? 1 : incmin ? 1 : 0;
	
	wire [3:0] min1, min10;
	counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin_or), .dec1(min1), .dec10(min10));
	//��ī����60�� ����Ͽ� min�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش�
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value({min10, min1, sec10, sec1}), .com(com), .seg_7(seg_7)); 

	
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
module watch_top_pro(
	input clk, reset_p,
	input [2:0] btn,
	output [3:0] com,
	output [7:0] seg_7
	);

	wire incsec, incmin;
	
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//�� ��� ��ư�� cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//�� ��� ��ư�� cntr
	
	wire clk_usec, clk_msec, clk_sec, clk_min;
	
	clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
	 clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
	 clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	 clock_min(.clk(clk), .clk_sec(incsec_or), .reset_p(reset_p), .clk_min(clk_min));
	
	wire incsec_or, incmin_or;
	
	assign incsec_or = clk_sec ? 1 : incsec ? 1 : 0; 
	//incsec | clk_sec;  ������ �𵨸�
	//assign incsec_or = clk_sec ? 1 : incsec ? 1 : 0;
	//������ ����
	
	wire [3:0] sec1, sec10;
	wire dec_clk;
	counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(incsec_or), .dec1(sec1), .dec10(sec10));
	//��ī����60�� ����Ͽ� sec�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش� 
	//assign incmin_or = dec_clk | incmin;
	//assign incmin_or = dec_clk ? 1 : incmin ? 1 : 0;
	assign incmin_or = clk_min ? 1 : incmin ? 1 : 0;
	
	
	wire [3:0] min1, min10;
	counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(incmin_or), .dec1(min1), .dec10(min10));
	//��ī����60�� ����Ͽ� min�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش�
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value({min10, min1, sec10, sec1}), .com(com), .seg_7(seg_7)); 

endmodule
/*==================================================================================================*/

/*==================================================================================================*/
module watch_top_set(
	input clk, reset_p,
	input [2:0] btn,
	output [3:0] com,
	output [7:0] seg_7
	);

	wire incsec, incmin;
	
	wire set_mode, btn_set_pe;
	
	button_cntr bcntr_setmode(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_ne(btn_set_pe));
	//btn = 0�̸� �ð赿�� 1�̸� set mode ����
	T_flip_flop_p tff_mode(.clk(clk), .t(btn_set_pe), .reset_p(reset_p), .q(set_mode));
	
	button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne(incsec));		//�� ��� ��ư�� cntr
	
	button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne(incmin));		//�� ��� ��ư�� cntr
	
	
	
	wire clk_usec, clk_msec, clk_sec, clk_min;
	
	clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
	 clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
	 clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));	
	 clock_min(.clk(clk), .clk_sec(upcount_sec), .reset_p(reset_p), .clk_min(clk_min));
	
	wire upcount_sec;
	assign upcount_sec = set_mode ? incsec : clk_sec;
	
	wire [3:0] sec1, sec10;
	loadable_counter_dec_60 up_sec(.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .load_enable(btn_set_pe), .set_value1(sec1_set), .set_value10(sec10_set), .dec1(sec1), .dec10(sec10));
	//��ī����60�� ����Ͽ� sec�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش� 
	//assign incmin_or = dec_clk | incmin;
	//assign incmin_or = dec_clk ? 1 : incmin ? 1 : 0;
	
	
	wire [3:0] min1, min10;
	loadable_counter_dec_60 up_min(.clk(clk), .reset_p(reset_p), .clk_time(clk_min), .load_enable(btn_set_pe), .set_value1(min1_set), .set_value10(min10_set), .dec1(min1), .dec10(min10));
	//��ī����60�� ����Ͽ� min�� 1���ڸ��� 10�� �ڸ��� ��ư�� �������� ��ŭ set���ش�
	
	
	wire [3:0] sec1_set, sec10_set;
	loadable_counter_dec_60 up_sec_set(.clk(clk), .reset_p(reset_p), .clk_time(incsec), .load_enable(btn_set_pe), .set_value1(sec1), .set_value10(sec10), .dec1(sec1_set), .dec10(sec10_set));
	
	wire [3:0] min1_set, min10_set;
	loadable_counter_dec_60 up_min_set(.clk(clk), .reset_p(reset_p), .clk_time(incmin), .load_enable(btn_set_pe), .set_value1(min1), .set_value10(min10), .dec1(min1_set), .dec10(min10_set));

	wire [15:0] cur_time, set_time;
	assign cur_time = {min10, min1, sec10, sec1};
	assign set_time = {min10_set, min1_set, sec10_set, sec1_set}; 

	wire [15:0] value;
	assign value = set_mode ? cur_time : set_time; 
	
	FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 

endmodule
/*==================================================================================================*/


module watch_top_set_Jung(
    input clk, reset_p,
    input [2:0] btn,
    output [3:0] com,
    output [7:0] seg_7
    );
    
        
    //---------------------------------Clock ------------------------------------------//            
    wire clk_usec, clk_msec, clk_sec ,clk_min;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec) );
    clock_div_1000 msec(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec) );
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec) );
        
    wire set_mode, upcount_sec;
    assign upcount_sec = set_mode ? incsec : clk_sec;   
    
    clock_min min_clk(.clk(clk), .clk_sec(upcount_sec), .reset_p(reset_p), .clk_min(clk_min));
   
   //----------------------------Button-----------------------------------//   

    wire btn_set_pe;
    button_cntr bcntr_setmode(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_ne( btn_set_pe) );
    T_flip_flop_n tff_mode(.clk(clk),  .t(btn_set_pe) ,  .reset_p(reset_p) ,  .q(set_mode) );
    
    //-------��ư�� �ð����� �Ҵ�------//
    button_cntr bcntr_incsec(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne( incsec ) );
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne( incmin ) );   
    
    


   //-------------------------------60�� ī����-------------------------------------------//
    wire [3:0] sec1, sec10 ;

   loadable_counter_dec_60 sec_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .load_enable(btn_set_pe),
        .set_value1(sec1_set) , .set_value10(sec10_set), .dec1(sec1), .dec10(sec10)
    );
                            //----------��----------------//
    
    wire [3:0] min1 , min10;
    
    loadable_counter_dec_60 min_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_min), .load_enable(btn_set_pe),
        .set_value1(min1_set) , .set_value10(min10_set), .dec1(min1), .dec10(min10)
    );
                        //----------��----------------//
   
   
   
   
   // ---------------------------------ī���ͼ���------------------------------//
    wire [3:0] sec1_set, sec10_set ;

   loadable_counter_dec_60 set_sec(
        .clk(clk), .reset_p(reset_p), .clk_time(incsec), .load_enable(btn_set_pe),
        .set_value1(sec1) , .set_value10(sec10), .dec1(sec1_set), .dec10(sec10_set)
    );                     
                        
    wire [3:0] min1_set , min10_set;
    
    loadable_counter_dec_60 set_min(
        .clk(clk), .reset_p(reset_p), .clk_time(incmin), .load_enable(btn_set_pe),
        .set_value1(min1) , .set_value10(min10), .dec1(min1_set), .dec10(min10_set) 
    );                     

   wire [15:0] cur_time , set_time ;
   assign cur_time = {min10, min1, sec10, sec1} ;
   assign set_time= {min10_set, min1_set, sec10_set, sec1_set};
    
               
   
   //---------------------------------------------------------------------------------//
   wire [15:0] value;
   assign value = set_mode ?  set_time : cur_time ;
   
   //----------------------------------���-------------------------------------------//
   FND_4digit_cntr fnd_cntr (.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7));


endmodule


module watch_hour_min_project(
    input clk, reset_p,
    input [2:0] btn,
    output [15:0] value_watch
    );
    
        
    //---------------------------------Clock ------------------------------------------//            
    wire clk_usec, clk_msec, clk_sec ,clk_min, clk_hour;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec) );
    clock_div_1000 msec(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec) );
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec) );
    
    wire set_mode, upcount_sec;
    assign upcount_sec = set_mode ? incsec : clk_sec;   
    assign upcount_min = set_mode ? incmin : clk_min;   

    clock_min min_clk(.clk(clk), .clk_sec(upcount_sec), .reset_p(reset_p), .clk_min(clk_min));
    clock_min hour_clk(.clk(clk), .clk_sec(upcount_min), .reset_p(reset_p), .clk_min(clk_hour));
    
   
   //----------------------------Button-----------------------------------//   

    wire btn_set_pe;
    button_cntr bcntr_setmode(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe( btn_set_pe) );
    T_flip_flop_n tff_mode(.clk(clk),  .t(btn_set_pe) ,  .reset_p(reset_p) ,  .q(set_mode) );
    
    //-------��ư�� �ð����� �Ҵ�------//
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne( incmin ) );   
    button_cntr bcntr_inchour(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne( inchour ) );   
    
    


   //-------------------------------60�� ī����-------------------------------------------//
    wire [3:0] sec1, sec10 ;
    loadable_counter_dec_60 sec_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .load_enable(btn_set_pe),
        .set_value1(sec1_set) , .set_value10(sec10_set), .dec1(sec1), .dec10(sec10)
    );
    
    
    wire [3:0] min1 , min10;
    loadable_counter_dec_60 min_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_min), .load_enable(btn_set_pe),
        .set_value1(min1_set) , .set_value10(min10_set), .dec1(min1), .dec10(min10)
    );
                        //----------��----------------//
    
    wire [3:0] hour1, hour10 ;
    loadable_up_counter_dec_24 hour_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_hour), .load_enable(btn_set_pe),
        .set_value1(hour1_set) , .set_value10(hour10_set), .dec1(hour1), .dec10(hour10)
    );   
                                //----------�ð�--------------//
   
   
   // ---------------------------------ī���ͼ���------------------------------//   
    wire [3:0] sec1_set, sec10_set ;
    loadable_counter_dec_60 set_sec(
        .clk(clk), .reset_p(reset_p), .clk_time(incsec), .load_enable(btn_set_pe),
        .set_value1(sec1) , .set_value10(sec10), .dec1(sec1_set), .dec10(sec10_set)
    );         
    
    wire [3:0] min1_set , min10_set;
    loadable_counter_dec_60 set_min(
        .clk(clk), .reset_p(reset_p), .clk_time(incmin), .load_enable(btn_set_pe),
        .set_value1(min1) , .set_value10(min10), .dec1(min1_set), .dec10(min10_set) 
    );      


    wire [3:0] hour1_set, hour10_set ;
    loadable_up_counter_dec_24 set_hour(
        .clk(clk), .reset_p(reset_p), .clk_time(inchour), .load_enable(btn_set_pe),
        .set_value1(hour1) , .set_value10(hour10), .dec1(hour1_set), .dec10(hour10_set)
    );                     
                           
    //-----------------------------���ýð�, ����ð� --------------------------------//

   wire [15:0] cur_time , set_time ;
   assign cur_time = {hour10, hour1 , min10, min1} ;
   assign set_time = {hour10_set, hour1_set , min10_set, min1_set};


   //---------------------------------------------------------------------------------//
   

   assign value_watch = set_mode ?  set_time : cur_time ;

endmodule


module watch_hour_min_project_original(
    input clk, reset_p,
    input [2:0] btn,
    output [15:0] value_watch
    );
    
        
    //---------------------------------Clock ------------------------------------------//            
    wire clk_usec, clk_msec, clk_sec ,clk_min, clk_hour;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec) );
    clock_div_1000 msec(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec) );
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec) );
    
    wire set_mode, upcount_min;
    assign upcount_min = set_mode ? incmin : clk_min;   

    clock_min min_clk(.clk(clk), .clk_sec(clk_sec), .reset_p(reset_p), .clk_min(clk_min));
    clock_min hour_clk(.clk(clk), .clk_sec(upcount_min), .reset_p(reset_p), .clk_min(clk_hour));
    
   
   //----------------------------Button-----------------------------------//   

    wire btn_set_pe;
    button_cntr bcntr_setmode(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe( btn_set_pe) );
    T_flip_flop_n tff_mode(.clk(clk),  .t(btn_set_pe) ,  .reset_p(reset_p) ,  .q(set_mode) );
    
    //-------��ư�� �ð����� �Ҵ�------//
    button_cntr bcntr_incmin(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_ne( incmin ) );   
    button_cntr bcntr_inchour(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_ne( inchour ) );   
    
    


   //-------------------------------60�� ī����-------------------------------------------//

    
    wire [3:0] min1 , min10;
    loadable_counter_dec_60 min_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_min), .load_enable(btn_set_pe),
        .set_value1(min1_set) , .set_value10(min10_set), .dec1(min1), .dec10(min10)
    );
                        //----------��----------------//
    
    wire [3:0] hour1, hour10 ;
    loadable_up_counter_dec_24 hour_up(
        .clk(clk), .reset_p(reset_p), .clk_time(clk_hour), .load_enable(btn_set_pe),
        .set_value1(hour1_set) , .set_value10(hour10_set), .dec1(hour1), .dec10(hour10)
    );   
                                //----------�ð�--------------//
   
   
   // ---------------------------------ī���ͼ���------------------------------//   

    wire [3:0] min1_set , min10_set;
    loadable_counter_dec_60 set_min(
        .clk(clk), .reset_p(reset_p), .clk_time(incmin), .load_enable(btn_set_pe),
        .set_value1(min1) , .set_value10(min10), .dec1(min1_set), .dec10(min10_set) 
    );      


    wire [3:0] hour1_set, hour10_set ;
    loadable_up_counter_dec_24 set_hour(
        .clk(clk), .reset_p(reset_p), .clk_time(inchour), .load_enable(btn_set_pe),
        .set_value1(hour1) , .set_value10(hour10), .dec1(hour1_set), .dec10(hour10_set)
    );                     
                           
    //-----------------------------���ýð�, ����ð� --------------------------------//

   wire [15:0] cur_time , set_time ;
   assign cur_time = {hour10, hour1 , min10, min1} ;
   assign set_time = {hour10_set, hour1_set , min10_set, min1_set};


   //---------------------------------------------------------------------------------//
   
   assign value_watch = set_mode ?  cur_time : set_time;



endmodule





















































