`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 09:20:34
// Design Name: 
// Module Name: FND_4digit_cntr
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


//------------------------------------------------------------------//
module FND_4digit_cntr(
            input clk, reset_p,
            input [15:0] value,
            output [3:0] com,
            output [7:0] seg_7 
);
                                            //ring카운터에 주는 clock이 1ms를 줄 것임
            reg [16:0] clk_1ms;             //1비트에 8ns임 대충 1ms를 만들기 위해 17bit clk_1ms만든것
            wire [7:0] seg_7_temp;
            
            always @(negedge clk) clk_1ms = clk_1ms + 1;

            ring_counter_fnd ddd(.clk(clk_1ms[16]), .com(com));

            reg [3:0] hex_value;
            
            decoder_7seg decoder(.hex_value(hex_value), .seg_7(seg_7_temp)); 
            assign seg_7 = ~seg_7_temp;

            always @(negedge clk)begin
                    case(com)
                        4'b1110 : hex_value = value[15:12];     
                        4'b1101 : hex_value = value[11:8]; 
                        4'b1011 : hex_value = value[7:4];    
                        4'b0111 : hex_value = value[3:0];
                    endcase
            end
endmodule
//------------------------------------------------------------------//
