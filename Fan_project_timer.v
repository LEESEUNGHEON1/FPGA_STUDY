`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 11:28:42
// Design Name: 
// Module Name: Fan_project_timer
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



//===========================================================================================================================//
module Fan_timer_project2(
    input clk, reset_p,
    input btn,
    output reg [3:0] led_bar,
    output [3:0] com,
    output [7:0] seg_7,
    output timeout
    );

    wire start;
    button_cntr bcntr_start(.clk(clk), .reset_p(reset_p), .btn(btn), .btn_ne(start));
    // T_flip_flop_n (.clk(clk), .reset_p(reset_p), .t(start), .q()
    // );
    

    wire clk_usec, clk_msec, clk_sec, clk_min;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    clock_div_1000 msec_clk (.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    clock_div_1000 sec_clk (.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec)); 
    clock_div_1000 min_clk (.clk(clk), .clk_source(clk_sec), .reset_p(reset_p), .clk_div_1000(clk_min));
    
    reg [1:0] cnt;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) cnt = 0;
        else begin
            if(start) begin
                cnt = cnt + 1;
                if(zero_count) begin
                    cnt = 0;
                end
            end
        end
    end

    wire zero_count;
    edge_detector_n ed(.clk(clk), .cp_in(count_time), .reset_p(reset_p), .n_edge(zero_count));

    assign timeout = zero_count ? ((count_time == 0) ? 1 : 0) : 0;
    //(zero_count && count_time == 0) ? 1 : 0;

    reg [3:0] hour1_set, hour10_set, min1_set, min10_set;

    // reg [15:0] set_time;
    // always @(posedge clk or posedge reset_p) begin
    //   if(reset_p) set_time = 0;      
    //   else set_time = {hour10_set, hour1_set, min10_set, min1_set}; 
    // end 

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            hour1_set = 0;
            hour10_set = 0;
            min1_set = 0;
            min10_set = 0;
            led_bar = 0;
        end
        else begin
            case (cnt)
                0: begin
                    hour1_set =1;
                    hour10_set =0;
                    min1_set =0;
                    min10_set =0;
                    led_bar = 4'b0001;
                end 
                1: begin
                    hour1_set =3;
                    hour10_set =0;
                    min1_set =0;
                    min10_set =0;
                    led_bar = 4'b0011;
                end 
                2: begin
                    hour1_set =5;
                    hour10_set =0;
                    min1_set =0;
                    min10_set =0;
                    led_bar = 4'b0111;
                end 
                3: begin
                    hour1_set =0;
                    hour10_set =0;
                    min1_set =0;
                    min10_set =0;
                    led_bar = 4'b1111;
                end 
                default: begin
                    hour1_set =0;
                    hour10_set =0;
                    min1_set =0;
                    min10_set =0;
                end
            endcase
        end
    end

    wire clk_start;
    assign clk_start = (count_time==0) ? 0 : clk_sec;
    assign load_enable = (start) ? 1 :0 ;

    reg [15:0] count_time;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count_time = 0;
        else count_time= {0, hour1, min10, min1};
    end
    
    wire check_dec_clk, dec_clk;
    assign check_dec_clk = (count_time == 0) ? 0 : dec_clk;

    wire[3:0] min1, min10;
    loadable_down_counter_dec_60_project dc_min(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(load_enable), .set_value1(min1_set), .set_value10(min10_set), .dec1(min1), .dec10(min10), .dec_clk(dec_clk));
    
    wire [3:0] hour1;
    loadable_down_counter_dec_24_project dc_hour(.clk(clk), .reset_p(reset_p), .clk_time(check_dec_clk), .load_enable(load_enable), .set_value1(hour1_set), .dec1(hour1));
    
    wire [15:0] value;
    assign value = count_time;
   
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7));


endmodule
//===========================================================================================================================//

//===========================================================================================================================//
module loadable_down_counter_dec_24_project(
    input clk, reset_p,
    input clk_time, load_enable,
    input [3:0] set_value1,
    output reg [3:0]dec1
    
);

    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
        dec1 = 0;
        end
        else if(load_enable)begin
            dec1 = set_value1;           
        end
        else if(clk_time)begin
            dec1 = dec1 - 1;   
        end
    end

endmodule

module loadable_down_counter_dec_60_project(
    input clk, reset_p,
    input clk_time, load_enable,
    input [3:0] set_value1, set_value10,
    output reg [3:0]dec1, dec10,
    output reg dec_clk
);

    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
        dec1 = 0;
        dec10 = 0;
        dec_clk = 0;
        end
        else if(load_enable)begin
            dec1 = set_value1;
            dec10 = set_value10;            
        end
        else if(clk_time)begin
            if(dec1 == 0)begin 
                dec1 = 9;
                if(dec10 == 0)begin
                    dec10 = 5;
                    dec_clk = 1;
                end
                else dec10 = dec10 - 1;
            end    
            else dec1 = dec1 - 1;
         end
         else dec_clk = 0;
    end

endmodule
//===========================================================================================================================//





























