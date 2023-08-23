`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 09:19:04
// Design Name: 
// Module Name: counter_fnd_top
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
module counter_find_top2(
    input clk, reset_p, btn1,
    output[7:0] seg_7,
    output[3:0] com                                     
);
        wire [11:0] count;     
        
        reg [25:0]clk_div;
        
        wire up_down_p, up_down;
        
        always @(posedge clk)clk_div = clk_div+1;
                 
        D_flip_flop_p dff (.d(btn1), .clk(clk_div[16]), .reset_p(reset_p), .q(up_down));            //약1ms
        
        reg up;
        
        always @(posedge up_down)begin      //clk과 상관없는 버튼입력으로 인해 동기화오류가 뜬다->PDT계산이 안됨
            up = ~up;
        end
        //플립플롭을 만들때는 CLK , Reset 외에는 edge로 잡지 말 것
        //엣지 디텍터를 사용하는 이유는 버튼 입력같은 CLK과 무관한 입력을 CLK과 유관하게 만들어서 동기화오류가 생기지 않게, 즉, PDT가 생기지 않게 하기 위해서임
//        edge_detector_n ed0 (.clk(clk), .cp_in(up_down), .reset_p(reset_p), .p_edge(up_down_p));
        
//        wire up;                            //up=1이면 업카운트 0이면 다운카운트
        
//        T_flip_flop_p T_up(.clk(clk), .t(up_down_p), .reset_p(reset_p), .q(up));               //T플립플롭의 clk은 버튼의 상승에지일때로 설정함 버튼을 누를때마다 T플립플롭의 출력이 토글 된다
        //T f/f과 D f/f의 clk을 맞춰줘야함
        up_counter_p_Nbit #(.N(12)) counter_find(.clk(clk_div[25]), .reset_p(reset_p), .up_down(~up),.count(count));            //~up으로 바꿈으로써 처음에 업카운트로 동작함
        
        wire [15:0] dec_value;
        
        bin_to_dec bin2dec (.bin(count), .bcd(dec_value));                   
        
         FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(dec_value), .com(com), .seg_7(seg_7));                               
endmodule
//------------------------------------------------------------------//
