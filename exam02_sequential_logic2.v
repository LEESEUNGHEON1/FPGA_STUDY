`timescale 1ns / 1ps


////�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
//module RS_latch(
//            input R, S,
//            output Q, Qbar   
//        );
        
//        nor (Q, R, Qbar);               //�ν��Ͻ����� ����
//        nor (Qbar, S, Q);
        
//endmodule    
////�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//

////�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
//module RS_latch_en(
//        input R, S ,en,
//        output Q, Qbar
//);
//        wire w_r, w_s;
//        and (w_r, R, en);
//        and (w_s, S, en);
        
//        nor(Q, w_r, Qbar);
//        nor(Qbar, w_s, Q);
//endmodule
////�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//    

//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module D_flip_flop_n(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop ������ �𵨸�
        always @(negedge clk or posedge reset_p)begin          //sensativity response�� negedge clk : clk�� negative edge �϶��� always 1�� ����
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //���� �Է¿� ���ؼ��� �ٸ� ����� �ֱ� ������
        end

//        always @(clk)begin
//                if(clk) q = d;                  //clk = 1(high Level)�� �� 
//                else q = q;                     //clk = 0(low Level)�� ��
//        end

//            always @(clk)begin                      //���ճ���ȸ�δ� ��ġ�� ������� �� ���� -> Ÿ�̹� ������ ���� �� �ִ�
//                if(clk) q = d;
//                else q = 0;            //and����Ʈ�� ������� �� ���� ���ٸ� ��ġ�� ��������� Ÿ�̹� ������ ���� �� ����

//            always @(clk)begin
//                    q = 0;                  //�̷��� �ʱ⿡ ������ �ָ� ������ 
//                    if(clk) q = d;
//            end
endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module D_flip_flop_p(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop ������ �𵨸�
        always @(posedge clk or posedge reset_p)begin          //sensativity response�� negedge clk : clk�� negative edge �϶��� always 1�� ����
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //���� �Է¿� ���ؼ��� �ٸ� ����� �ֱ� ������
        end

endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module T_flip_flop_n(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //��� q�� ���� wire
//            assign d = ~q;
            //reg temp = 0;                                       //���� ������ �� �ʱ� ������ �Ϸ��� reg�� �� //wire�� 0���� �ϸ� ��� ����������
                                                                           //���忡���� �ʱⰪ ������ ���ص� ������ �Ӷ� �������� 0���� �ʱ�ȭ�� ������
                                                                           
            always @(negedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//

//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module T_flip_flop_p(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //��� q�� ���� wire
//            assign d = ~q;
            //reg temp = 0;                                       //���� ������ �� �ʱ� ������ �Ϸ��� reg�� �� //wire�� 0���� �ϸ� ��� ����������
                                                                           //���忡���� �ʱⰪ ������ ���ص� ������ �Ӷ� �������� 0���� �ʱ�ȭ�� ������
                                                                           
            always @(posedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module up_counter_asyc(         //�񵿱��
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_n T0 (.clk(clk), .reset_p(reset_p), .q(count[0]));
        T_flip_flop_n T1 (.clk(count[0]), .reset_p(reset_p), .q(count[1]));
        T_flip_flop_n T2 (.clk(count[1]), .reset_p(reset_p), .q(count[2]));
        T_flip_flop_n T3 (.clk(count[2]), .reset_p(reset_p), .q(count[3]));
        
endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module down_counter_asyc(           //�񵿱��
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_p H1 (.clk(clk), .reset_p(reset_p),. q(count[0]));
        T_flip_flop_p H2 (.clk(count[0]), .reset_p(reset_p),. q(count[1]));
        T_flip_flop_p H3 (.clk(count[1]), .reset_p(reset_p),. q(count[2]));
        T_flip_flop_p H4 (.clk(count[2]), .reset_p(reset_p),. q(count[3]));

endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module up_counter_p(                      //�����
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count + 1;
                end
endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//

//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module down_counter_p(                      //�����
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count - 1;
                end
endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//



//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module up_down_counter(
            input clk, reset_p,
            input up_down,                              //0�̸� down 1�̸� up ī���ͷ� �����ϰԲ�
            output reg [3:0] count
);

            always @(posedge clk or posedge reset_p) begin
                    if(reset_p) count = 0;
                    else if(up_down) count = count + 1;
                    else count = count - 1;
            end



endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module counter_fnd_top(     //updown count�� ����� fnd��
        input clk, reset_p, up_down,
        output [7:0] seg_7,
        output [3:0] com
);

        wire [3:0] count;
        
        assign com = 4'b0011;
        
        reg [25:0] clk_div;
        
        always @(posedge clk)clk_div = clk_div + 1;             //�ùķ��̼��Ҷ��� ns������ ������ Ȯ���ϸ� �Ǵµ�
                                                                                                    //���� ���忡�� ������ ���ֺ� ��������
        
        up_down_counter counter_fnd (.clk(clk_div[25]), .reset_p(reset_p), .up_down(up_down), .count(count));
        
        decoder_7seg(.hex_value(count), .seg_7(seg_7));


endmodule
//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//


//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//
module up_counter_p_BCD(                      //BCD ��ī����  0,1,2,3,4,5,6,7,8,9,0,1,2,3,...
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else begin
                            if (count >= 9) count = 0;
                            else count = count + 1;
                         end
                end
endmodule

//�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�//














