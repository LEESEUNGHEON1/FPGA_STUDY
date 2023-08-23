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
    output [3:0] com,
    output [7:0] seg_7
    );
    
    reg [16 : 0] clk_div;
    wire start_stop_pedge, start_stop;
    always @(posedge clk)clk_div = clk_div+1;
    
    D_flip_flop_p dff (.d(btn1), .clk(clk_div[16]), .reset_p(reset_p), .q(start_stop));            //¾à1ms
    
    wire clk_usec, clk_msec, clk_sec;
    clock_usec usec_clk (.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    clock_msec msec_clk (.clk(clk), .clk_usec(clk_usec), .reset_p(reset_p), .clk_msec(clk_msec));
    clock_sec sec_clk (.clk(clk), .clk_msec(clk_msec), .reset_p(reset_p), .clk_sec(clk_sec));
    
    wire [3:0] sec1, sec10;
    
    counter_dec_60 dec60 (.clk(clk), .reset_p(reset_p), .clk_time(clk_sec), .dec1(sec1), .dec10(sec10));
    
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value({8'b0, sec10, sec1}), .com(com), .seg_7(seg_7)); 
    
endmodule
/*==================================================================================================*/


















































