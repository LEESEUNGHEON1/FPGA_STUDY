`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/12 17:21:37
// Design Name: 
// Module Name: Ultrasonic_top
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

module Ultrasonic_top(
    input clk, reset_p,
    input Echo_data,
    output Trig_sig,
    output [7:0] led_bar,
    output [3:0] com,
    output [7:0] seg_7
    );

    wire [11:0] Trig_data;
    //Ultrasonic??¡§?????? Trig_data??? ??¢¥??¢¥?¨©??¢¬¡Æ ?????? wire

    Ultrasonic Ultra(.clk(clk), .reset_p(reset_p), .Echo_data(Echo_data), .Trig_sig(Trig_sig), .Trig_data(Trig_data), .led_bar(led_bar));

    wire [15:0] bcd_Trig_data;
    bin_to_dec btd(.bin(Trig_data), .bcd(bcd_Trig_data));       //12bit(bin) Trig_data??? 16bit(bcd) bcd_Trig_data??? ?©©????

    wire [15:0] value;
    assign value = bcd_Trig_data;

    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7));

endmodule
