`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/19 14:24:40
// Design Name: 
// Module Name: and_gate
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

//------------------------------------------------------------------------------------------------------------//
module and_gate(
    input A,
    input B,
    output F
    );
    
    and(F, A, B);    //괄호의 맨 처음이 출력   and같이 기본적인 것은 구현되어 있음  and(a,b,c)와 같은 것은 모듈로 만들지 않고 그냥 사용하면 됨
    
endmodule 
//------------------------------------------------------------------------------------------------------------//
module half_adder_structural(    //structural("구조적 모델링")   half_adder(반가산기) sum = 2입력 더한 결과 carry  = 2입력 더했을 때 발생하는 올림 수
    input A,                     
    input B,
    output sum,                       //00 - 0  /   01 - 1  /  10   -  1   / 11 - 0
    output carry                       //00 - 0  /  01 - 0    / 10   -  0  /  11 - 1
    );
    
    xor(sum, A, B);
    and(carry, A, B);
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module half_adder(    //dataflow modeling(데이터가 어떻게 흘러가는지 기술)
    input A,
    input B,
    output sum,
    output carry
    );
    
    assign sum = A ^ B;         //^ = XOR   assign을 사용하면 데이터 플로우 모델링임
    assign carry = A & B;       //& = AND
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
//module h_adder(    
//        input A,
//        input B,
//        output sum,
//        output carry
//);

//        assign sum = ({A,B} == 2'b00) ? 0 : ({A,B} == 2'b11) ? 0 : 1;
//        assign carry = ({A,B} == 2'b11) ? 1 : 0;
        
//endmodule
//------------------------------------------------------------------------------------------------------------//
module half_adder_behavioral(    //  "동작점 모델링" ->추상적 표현
    input A,
    input B,
    output reg sum,             // reg : 레지스터Type으로 바꿔주는 함수
    output reg carry
    );
    
    always @(A, B)begin
        case({A, B})                                                    //모든 입력에 대해서 다 기입해야함 or default를 사용하면 됨(지정되지 않은 조합은 전부 default로 됨)
            2'b00: begin sum = 0; carry = 0; end           //gate의 동작을 정의하는 것 (동작점 모델링)
            2'b01: begin sum = 1; carry = 0; end           //수식의 왼쪽은 레지스터Type이어야함
            2'b10: begin sum = 1; carry = 0; end           //비트 수가 정해져 있지 않으니 2'b 와 같이 2비트 바이너리와 같이 표현함
            2'b11: begin sum = 0; carry = 1; end           // {} : 결합연산자로 사용 // C언어의 {}는 verilog에서는 begin - end로 표현함
                                                                                    //MUX로 구현됨
        endcase
    end
endmodule
//------------------------------------------------------------------------------------------------------------//
//만들어진 모듈을 가지고 게이트를 만드는 것을 "인스턴스화"
//전가산기는 반가산기를 2개 사용함
module full_adder_structural(                 //구조적 모델링으로 구현한 것 구조적 모델링 사용X
    input A, B, cin,
    output sum, carry
    );
    
    wire sum_0, carry_0;            //half_adder의 sum, carry 출력을 나타낸 것임
    wire carry_1;
    
    half_adder ha0 (.A(A), .B(B), .sum(sum_0), .carry(carry_0));          //인스턴스를 만들때 .A라고 하면 "half_adder"의 입출력 변수를 말함
                                                                                                                            //(A) 괄호안의 A는 현재 "full_adder"의 입출력 변수를 말함
                                                                                                                 //정리하면 half_adder의 A를 full_adder의 A에 그대로 줌(B도 마찬가지)
    half_adder ha1 (.A(sum_0), .B(cin), .sum(sum), .carry(carry_1));
                                                                                                                    //.A(sum_0) -> half_adder의 A를 full_adder의 sum_0변수로 가져오는 것을 뜻함
    
    or (carry, carry_0, carry_1);
endmodule
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
module f_add(       //4bit 전가산기 데이터 플로우 모델링
        input [3:0] A, B,
        input C,
        output [3:0] sum,
        output carry 
);
        wire [4:0] temp;
        
        assign temp = A+B+C;
        assign sum = temp[3:0];
        assign carry = temp[4];

endmodule
//------------------------------------------------------------------------------------------------------------//
module f_add_top();
        reg [3:0] A, B;
        reg C;
        wire [3:0] sum;
        wire carry;
        
        

endmodule
//------------------------------------------------------------------------------------------------------------//
module full_adder(                 //구조적 모델링으로 구현한 것
    input A, B, cin,
    output sum, carry
    );
    
    assign sum = A ^ B ^ cin;                                                                           //일반적인 프로그램 같이 윗줄이 먼저 시작되지 않음
    assign carry = (cin & (A ^ B)) | (A & B);        //cin(A xor B) + AB      // 병렬구조로 동시다발적으로 실행됨
    
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//4bits 병렬가산기 : 전가산기 4개를 병렬로 연결한 회로  ripple carry adder(RCA)라고도 함(carry를 넘기는 방식)
module fadder_4bit_structural(
    input [3:0] a, b,                 //0,1,2,3 bit를 가지는 a가 만들어짐   [최상위 비트(MSB) : 최하위 비트(LSB)]
    input cin,
    output [3:0] sum,
    output carry
    );
    
    wire [2:0] carry_in;
    
    full_adder fa0 (.A(a[0]), .B(b[0]), .cin(cin), .sum(sum[0]), .carry(carry_in[0]));    
    full_adder fa1 (.A(a[1]), .B(b[1]), .cin(carry_in[0]), .sum(sum[1]), .carry(carry_in[1]));
    full_adder fa2 (.A(a[2]), .B(b[2]), .cin(carry_in[1]), .sum(sum[2]), .carry(carry_in[2]));
    full_adder fa3 (.A(a[3]), .B(b[3]), .cin(carry_in[2]), .sum(sum[3]), .carry(carry));
    
endmodule
//------------------------------------------------------------------------------------------------------------//
module fadder_4bit(         //데이터 모델링 full_adder
    input [3:0] a, b,                 //0,1,2,3 bit를 가지는 a가 만들어짐   [최상위 비트(MSB) : 최하위 비트(LSB)]
    input cin,
    output [3:0] sum,
    output carry
    );
    
    wire [4:0] temp;
    
    assign temp = a + b + cin;          //4bit + 4bit + carry = 5bit
    assign sum = temp[3:0];            //하위 4비트는 sum
    assign carry = temp[4];              //최상위 1비트는 carry 가 된다
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//8비트 일 시 최상위 비트가 1이면(1000 0000 = -128(음수)) 최상위비트가 0이면(0111 1111 = 127(양수)) 
// -> -128~127
//-1을 표현할 때는 -1의 양수인 1을 비트반전 시킨 후 +1 해주면 됨
//-> 1000 0000(-1)의 양수인 0000 0001(1)을 반전 시키면 1111 1110 여기에 +1 = 1111 1111 -> 
//bit clear : AND, bit set : OR , bit toglle : XOR
//------------------------------------------------------------------------------------------------------------//
module fadd_sub_4bit_s(
    input [3:0] a, b,                 //0,1,2,3 bit를 가지는 a가 만들어짐   [최상위 비트(MSB) : 최하위 비트(LSB)]
    input s,                                //s = 0(가산기) , s = 1(감산기)
    output [3:0] sum,
    output carry
    );
    
    wire [2:0] carry_in;
    
    full_adder fa0 (.A(a[0]), .B(b[0] ^ s), .cin(s), .sum(sum[0]), .carry(carry_in[0]));             //b입력을 s와 XOR함
    full_adder fa1 (.A(a[1]), .B(b[1] ^ s), .cin(carry_in[0]), .sum(sum[1]), .carry(carry_in[1]));
    full_adder fa2 (.A(a[2]), .B(b[2] ^ s), .cin(carry_in[1]), .sum(sum[2]), .carry(carry_in[2]));
    full_adder fa3 (.A(a[3]), .B(b[3] ^ s), .cin(carry_in[2]), .sum(sum[3]), .carry(carry));
    
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//SYNTHESIS : RTL(VHDL, Verilog source)을 gate level의 netlist로 변환하는 단계입니다.
//  → 비교적 간단한 RTL 설계를 power, timing과 같은 constraint를 고려하여
//     gate로 이루어진 netlist로 바꿔주는 중요한 작업입니다.

//PDT 게이트마다 전파지연시간이 있음 
//최대동작주파수가 작을수록 빠름

//조합논리회로 : 입력에 의해 출력이 정해짐
//순차논리회로 : 이전 상태의 출력에 따라서 출력이 정해짐(CLK을 사용)

//------------------------------------------------------------------------------------------------------------//
module fadd_sub_4bit(
    input [3:0] a, b,                 //0,1,2,3 bit를 가지는 a가 만들어짐   [최상위 비트(MSB) : 최하위 비트(LSB)]
    input s,                                //s = 0(가산기) , s = 1(감산기)
    output [3:0] sum,
    output carry
    );
    
    wire [4:0] temp;                                     //5비트 짜리
    
    assign temp = s ? a - b:  a + b;                        //더하기일 경우     조건연산자 ?앞이 참이면 : 왼쪽이 temp로 ?앞이 거짓이면 : 오른쪽이 temp로 들어감                       
    assign sum = temp[3:0];
    assign carry = temp[4];
    
    //가장 빠른 알고리즘임
    
endmodule
//------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------//
module comparator (
            input A, B,
            output equal, greater, less
        );
        
    assign equal = A ~^ B;                  //assign문을 사용했지만 구조적모델링과 같음
    assign greater = A & ~B;
    assign less = ~A & B;
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module comparator2 #(parameter N = 4)(              //N을 4로 바꿔라 compile 전에
            input [N-1:0] A, B,
            output equal, greater, less
        );
        
    assign equal = (A == B) ? 1'b1 : 1'b0;                  //? : 앞의 수식이 참이면 : 왼쪽 
    assign greater = (A > B) ? 1'b1 : 1'b0;
    assign less = (A < B)? 1'b1 : 1'b0;
    
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module decoder_2_4 (            
            input [1:0] A,
            output [3:0] Y

            );
            //데이터 플로우 모델링
            assign Y = (A == 2'b00) ? 4'b0001 : (A == 2'b01) ? 4'b0010 : (A == 2'b10) ? 4'b0100 : 4'b1000;
            //?가 참이면 왼쪽 실행 거짓이면 : 오른쪽의 조건문을 추가하여 계속 이어나갈 수 있음
            
            //디코더 동작점 모델링
//            always @(A) begin    //@(A) 이 A는 입력을 말함 --> always문은 @(여기의 변수가 값이 변하면 한번 실행한다)
//                    case(A)                 
//                        2'b00: Y = 4'b0001;     //A=00이면
//                        2'b01: Y = 4'b0010; 
//                        2'b10: Y = 4'b0100; 
//                        2'b11: Y = 4'b1000;
//                                                                        //만약 A를 4가지 전부를 사용하지 않으면 에러남 default값을 만들어 줘야함                                                
//                    endcase  
//            end

//            always @(A) begin    //@(A) 이 A는 입력을 말함 --> always문은 @(여기의 변수가 값이 변하면 한번 실행한다)
//                    if(A == 2'b00) Y = 4'b0001;
//                    else if(A == 2'b01) Y = 4'b0010;
//                    else if(A == 2'b10) Y = 4'b0100;
//                    else Y = 4'b1000;
//            end

endmodule
//------------------------------------------------------------------------------------------------------------//



//------------------------------------------------------------------------------------------------------------//

module decoder_2_4_en (            
            input [1:0] A,
            input en,
            output reg [3:0] Y

            );
            //데이터 플로우 모델링
            //assign Y = (en == 0) ? 4'b0000 : (A == 2'b00) ? 4'b0001 : (A == 2'b01) ? 4'b0010 : (A == 2'b10) ? 4'b0100 : 4'b1000;
            //?가 참이면 왼쪽 실행 거짓이면 : 오른쪽의 조건문을 추가하여 계속 이어나갈 수 있음
            
//            always @(A) begin    //@(A) 이 A는 입력을 말함 --> always문은 @(여기의 변수가 값이 변하면 한번 실행한다)
//                if(en == 1) begin
//                    case(A)                 
//                        2'b00: Y = 4'b0001;     //A=00이면
//                        2'b01: Y = 4'b0010; 
//                        2'b10: Y = 4'b0100; 
//                        2'b11: Y = 4'b1000;
//                                                                        //만약 A를 4가지 전부를 사용하지 않으면 에러남 default값을 만들어 줘야함                                                
//                    endcase  
//            end
//            else Y = 0;
//            end

            always @(A) begin    //@(A) 이 A는 입력을 말함 --> always문은 @(여기의 변수가 값이 변하면 한번 실행한다)
                if(en == 1)begin
                    if(A == 2'b00) Y = 4'b0001;
                    else if(A == 2'b01) Y = 4'b0010;
                    else if(A == 2'b10) Y = 4'b0100;
                    else Y = 4'b1000;
                end
                else Y = 0;
            end
            
endmodule

//------------------------------------------------------------------------------------------------------------//
module decoder_3_8 (                    //구조적 모델링으로 3X8디코더 구현
        input [2:0] D,
        output [7:0] Y
                
        );

        decoder_2_4_en de0 (.A(D[1:0]), .en(!D[2]), .Y(Y[3:0]));
        
        decoder_2_4_en de1 (.A(D[1:0]), .en(D[2]), .Y(Y[7:4]));

endmodule
//------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------//
module decoder_7seg(
                input [3:0] hex_value ,
                output reg [7:0] seg_7
);
                //동작점 모델링
        always @(hex_value) begin
                case(hex_value)
                    4'b0000 : seg_7 = 8'b0000_0011;              //진리표의 A를 최상위비트로 사용
                    4'b0001 : seg_7 = 8'b1001_1111;         //1
                    4'b0010 : seg_7 = 8'b0010_0101;         //2
                    4'b0011 : seg_7 = 8'b0000_1101;         //3
                    4'b0100 : seg_7 = 8'b1001_1001;         //4
                    4'b0101 : seg_7 = 8'b0100_1001;         //5
                    4'b0110 : seg_7 = 8'b0100_0001;         //6
                    4'b0111 : seg_7 = 8'b0001_1111;         //7
                    4'b1000 : seg_7 = 8'b0000_0001;         //8
                    4'b1001 : seg_7 = 8'b0000_1001;         //9
                    4'b1010 : seg_7 = 8'b0001_0001;         //A
                    4'b1011 : seg_7 = 8'b1100_0001;         //B
                    4'b1100 : seg_7 = 8'b0110_0011;         //C
                    4'b1101 : seg_7 = 8'b1000_0101;         //D
                    4'b1110 : seg_7 = 8'b0110_0001;         //E
                    4'b1111 : seg_7 = 8'b0111_0001;         //F
                    
                endcase
        end  

endmodule

//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module fnd_test_top(            //보드의 입출력과 연결해주는 모듈 : TOP
        input clk,                        //clk이 있다는 것은 순차논리회로라는 뜻임            
        output [7:0] seg_7,
        output [3:0] com        //4비트 짜리 FND이므로 COM 단자 4개 필요
);
        
        assign com = 4'b0011;
        
        reg [25:0] clk_div;
        
        always @(posedge clk) clk_div = clk_div + 1;        //rising edge마다 26비트짜리 clk_div(reg)를 1씩 증가 시킨다 분주비
                                                                                    
        reg [3:0] count;
        always @(negedge clk_div[25])begin          //8ns X 2^26 ~= 0.5s
                count = count + 1;
        end
        //wire [7:0] seg_7_font;        common
    decoder_7seg seg7(.hex_value(count), .seg_7(seg_7));            //
        //assign seg_7 = ~seg_7_font;
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module encoder_4_2(           
            input [3:0] D,
            output [1:0] B
);

        assign B = (D == 4'b0001) ? 2'b00 : (D == 4'b0010) ? 2'b01 : (D == 4'b0100) ? 2'b10 : 2'b11;
        //엔코더는 입력이 정해진다는 가정 하에 진행되어야함 여기서는 D의 4입력 외에는 없다라는 가정을 한 것임
        //하지만 vivado 프로그램에서는 입력이 4개밖에 없는다는 것을 모르는 상태임    -> 입력으로 지정된 것이 아닌 D값은 모두 조건문의 맨 끝인 11로 저장함

endmodule

//------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------//
module mux_2_1(
            input [1:0] d,
            input s,
            output f
);
            
            assign f = s ? d[1] : d[0];
endmodule
//구조적 모델링
//        wire sbar, in0, in1;        
        
//        not (sbar, s);
//        and (in0, d[0], sbar);
//        and (in1, d[1], s);
//        or (f, in0, in1);


//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module mux_4_1(
            input [3:0] d,
            input [1:0] s,
            output f
);
            //assign f = s ? d[1] : d[0];
            //간단하게 할 수 있음
            assign f = d[s];        //이렇게               

endmodule


//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module mux_8_1(
            input [7:0] d,
            input [2:0] s,
            output f
);
            assign f = d[s];        //이렇게   s가 3비트로 들어감

endmodule


//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module demux_1_4(
        input d,
        input [1:0] s,
        output [3:0] f
//        output reg [3:0] f
);

//        always @*begin  //d나 s가 바뀌면 always문 1번 실행  always @(d, s)begin = always @*begin   * : 입력이 무엇이라도 변하면 always문 1번 실행
//            f = 0;              //f의 정해지지않은 부분은 0으로 함
//            f[s] = d;       //s=0이면 d가 f[0]으로 s=1이면 d가 f[1]로 하지만 
//        end

        assign f = (s == 2'b00) ? {3'b000, d} : (s == 2'b01) ? {2'b00, d, 1'b0} : (s == 2'b10) ? {1'b0, d, 2'b00} : {d, 3'b000};
endmodule
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------//
module mux_test_top(
        input [7:0] d,
        input [2:0] s_mux,
        input [1:0] s_demux,
        output [3:0] f
);

         wire w;                //mux의 출력 wire하나 필요
         
         mux_8_1 mux(.d(d), .s(s_mux), .f(w));
       
         demux_1_4 demux(.d(w), .s(s_demux), .f(f));
        
        
endmodule
//------------------------------------------------------------------------------------------------------------//



































