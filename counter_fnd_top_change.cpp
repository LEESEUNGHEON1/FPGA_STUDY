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
                 
        D_flip_flop_p dff (.d(btn1), .clk(clk_div[16]), .reset_p(reset_p), .q(up_down));            //��1ms
        
        reg up;
        
        always @(posedge up_down)begin      //clk�� ������� ��ư�Է����� ���� ����ȭ������ ���->PDT����� �ȵ�
            up = ~up;
        end
        //�ø��÷��� ���鶧�� CLK , Reset �ܿ��� edge�� ���� �� ��
        //���� �����͸� ����ϴ� ������ ��ư �Է°��� CLK�� ������ �Է��� CLK�� �����ϰ� ���� ����ȭ������ ������ �ʰ�, ��, PDT�� ������ �ʰ� �ϱ� ���ؼ���
//        edge_detector_n ed0 (.clk(clk), .cp_in(up_down), .reset_p(reset_p), .p_edge(up_down_p));
        
//        wire up;                            //up=1�̸� ��ī��Ʈ 0�̸� �ٿ�ī��Ʈ
        
//        T_flip_flop_p T_up(.clk(clk), .t(up_down_p), .reset_p(reset_p), .q(up));               //T�ø��÷��� clk�� ��ư�� ��¿����϶��� ������ ��ư�� ���������� T�ø��÷��� ����� ��� �ȴ�
        //T f/f�� D f/f�� clk�� ���������
        up_counter_p_Nbit #(.N(12)) counter_find(.clk(clk_div[25]), .reset_p(reset_p), .up_down(~up),.count(count));            //~up���� �ٲ����ν� ó���� ��ī��Ʈ�� ������
        
        wire [15:0] dec_value;
        
        bin_to_dec bin2dec (.bin(count), .bcd(dec_value));                   
        
         FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(dec_value), .com(com), .seg_7(seg_7));                               
endmodule
//------------------------------------------------------------------//
