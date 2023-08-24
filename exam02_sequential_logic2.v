`timescale 1ns / 1ps


////ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
//module RS_latch(
//            input R, S,
//            output Q, Qbar   
//        );
        
//        nor (Q, R, Qbar);               //인스턴스명이 없음
//        nor (Qbar, S, Q);
        
//endmodule    
////ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//

////ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
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
////ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//    

//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module D_flip_flop_n(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop 동작점 모델링
        always @(negedge clk or posedge reset_p)begin          //sensativity response에 negedge clk : clk의 negative edge 일때만 always 1번 실행
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //같은 입력에 대해서도 다른 출력이 있기 때문에
        end

//        always @(clk)begin
//                if(clk) q = d;                  //clk = 1(high Level)일 때 
//                else q = q;                     //clk = 0(low Level)일 때
//        end

//            always @(clk)begin                      //조합논리회로는 래치가 만들어질 수 있음 -> 타이밍 에러가 생길 수 있다
//                if(clk) q = d;
//                else q = 0;            //and게이트가 만들어짐 이 줄이 없다면 래치가 만들어져서 타이밍 에러가 생길 수 있음

//            always @(clk)begin
//                    q = 0;                  //이렇게 초기에 지정해 주면 괜찮음 
//                    if(clk) q = d;
//            end
endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module D_flip_flop_p(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop 동작점 모델링
        always @(posedge clk or posedge reset_p)begin          //sensativity response에 negedge clk : clk의 negative edge 일때만 always 1번 실행
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //같은 입력에 대해서도 다른 출력이 있기 때문에
        end

endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module T_flip_flop_n(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //출력 q를 받을 wire
//            assign d = ~q;
            //reg temp = 0;                                       //변수 선언할 때 초기 선언을 하려면 reg만 됨 //wire는 0으로 하면 계속 접지상태임
                                                                           //보드에서는 초기값 설정을 안해도 전원을 켤때 리셋으로 0으로 초기화를 진행함
                                                                           
            always @(negedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//

//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module T_flip_flop_p(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //출력 q를 받을 wire
//            assign d = ~q;
            //reg temp = 0;                                       //변수 선언할 때 초기 선언을 하려면 reg만 됨 //wire는 0으로 하면 계속 접지상태임
                                                                           //보드에서는 초기값 설정을 안해도 전원을 켤때 리셋으로 0으로 초기화를 진행함
                                                                           
            always @(posedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module up_counter_asyc(         //비동기식
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_n T0 (.clk(clk), .reset_p(reset_p), .q(count[0]));
        T_flip_flop_n T1 (.clk(count[0]), .reset_p(reset_p), .q(count[1]));
        T_flip_flop_n T2 (.clk(count[1]), .reset_p(reset_p), .q(count[2]));
        T_flip_flop_n T3 (.clk(count[2]), .reset_p(reset_p), .q(count[3]));
        
endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module down_counter_asyc(           //비동기식
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_p H1 (.clk(clk), .reset_p(reset_p),. q(count[0]));
        T_flip_flop_p H2 (.clk(count[0]), .reset_p(reset_p),. q(count[1]));
        T_flip_flop_p H3 (.clk(count[1]), .reset_p(reset_p),. q(count[2]));
        T_flip_flop_p H4 (.clk(count[2]), .reset_p(reset_p),. q(count[3]));

endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module up_counter_p(                      //동기식
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count + 1;
                end
endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//

//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module down_counter_p(                      //동기식
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count - 1;
                end
endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//



//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module up_down_counter(
            input clk, reset_p,
            input up_down,                              //0이면 down 1이면 up 카운터로 동작하게끄
            output reg [3:0] count
);

            always @(posedge clk or posedge reset_p) begin
                    if(reset_p) count = 0;
                    else if(up_down) count = count + 1;
                    else count = count - 1;
            end



endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module counter_fnd_top(     //updown count의 출력을 fnd로
        input clk, reset_p, up_down,
        output [7:0] seg_7,
        output [3:0] com
);

        wire [3:0] count;
        
        assign com = 4'b0011;
        
        reg [25:0] clk_div;
        
        always @(posedge clk)clk_div = clk_div + 1;             //시뮬레이션할때는 ns단위로 파형만 확인하면 되는데
                                                                                                    //실제 보드에서 볼때는 분주비를 설정해줌
        
        up_down_counter counter_fnd (.clk(clk_div[25]), .reset_p(reset_p), .up_down(up_down), .count(count));
        
        decoder_7seg(.hex_value(count), .seg_7(seg_7));


endmodule
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//


//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//
module up_counter_p_BCD(                      //BCD 업카운터  0,1,2,3,4,5,6,7,8,9,0,1,2,3,...
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

//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//














