`timescale 1ns / 1ps
//------------------------------------------------------------------//
module D_flip_flop_n (
        input d,
        input clk,
        input reset_p,
        output reg q
    );
    always @(negedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else q = d;
    end
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module D_flip_flop_p (
        input d,
        input clk,
        input reset_p,
        output reg q
    );
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else q = d;
    end
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module T_flip_flop_n (
        input clk,
        input t,          //edge detection을 사용하기 위함
        input reset_p,
        output reg q
    );
    always @(negedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else if(t) q = ~q;
        else q = q;             //f/f이므로 else문을 안써줘도 값을 유지함      조합논리회로일때는 else문을 사용해야함
    end
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module T_flip_flop_p (
        input clk,
        input t,        //edge detection을 사용하기 위함
        input reset_p,
        output reg q
    );
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else if(t) q = ~q;      //f/f이므로 else문을 안써줘도 값을 유지함      조합논리회로일때는 else문을 사용해야함
        else q = q;
    end
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module up_counter_asyc(
        input clk,
        input reset_p,
        output [3:0] count
        );
         T_flip_flop_n T0(.clk(clk),.reset_p(reset_p), .q(count[0]));
         T_flip_flop_n T1(.clk(count[0]),.reset_p(reset_p), .q(count[1]));
         T_flip_flop_n T2(.clk(count[1]),.reset_p(reset_p), .q(count[2]));
         T_flip_flop_n T3(.clk(count[2]),.reset_p(reset_p), .q(count[3]));
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module down_counter_asyc(
        input clk,
        input reset_p,
        output [3:0] count
        );
        T_flip_flop_p T0(.clk(clk),.reset_p(reset_p), .q(count[0]));
        T_flip_flop_p T1(.clk(count[0]),.reset_p(reset_p), .q(count[1]));
        T_flip_flop_p T2(.clk(count[1]),.reset_p(reset_p), .q(count[2]));
        T_flip_flop_p T3(.clk(count[2]),.reset_p(reset_p), .q(count[3]));
 endmodule
 //------------------------------------------------------------------//
 
 //------------------------------------------------------------------//
module up_counter_p(
        input clk,
        input reset_p,
        output reg [3:0] count
        );
        always @(posedge clk or posedge reset_p)begin
        if(reset_p) count = 0;
        else count = count +1;
        end
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module down_counter_p(
        input clk,
        input reset_p,
        output reg [3:0] count
        );
        always @(posedge clk or posedge reset_p)begin
        if(reset_p) count = 0;
        else count = count -1;
        end
endmodule
//------------------------------------------------------------------//



//------------------------------------------------------------------//
module up_down_counter(
        input clk, reset_p,
        input up_down,
        output reg [3:0] count
        );
        always @(posedge clk or posedge reset_p)begin
        if(reset_p) count = 0;
        else if (up_down)count = count+1;
        else count = count-1;
        end
endmodule
//------------------------------------------------------------------//



//------------------------------------------------------------------//
module counter_find_top(
    input clk, reset_p, up_down,
    output[7:0] seg_7,
    output[3:0] com                                     
);
        wire [11:0] count;     
        
        reg [25:0]clk_div;
        
        always @(posedge clk)clk_div = clk_div+1;
        
        up_counter_p_Nbit #(.N(12)) counter_find(.clk(clk_div[25]), .reset_p(reset_p), .up_down(up_down),.count(count));
        
        FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value({4'b0000, count}), .com(com), .seg_7(seg_7));
        
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module up_counter_p_BCD(
        input clk, up_down,
        input reset_p,
        output reg [3:0] count
);

        always @(posedge clk or posedge reset_p)begin
                if(reset_p) count = 0;
                else begin
                    if(up_down)begin
                        if(count>=9)count=0;
                        else count = count +1;
                    end
            else begin
                    if(count==0)count=9;
                    else count = count-1;
                     end
            end
            end
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module ring_counter_fnd(
            input clk, reset_p,
            output [3:0] com 
);

            reg [3:0] temp;
            
            always @(posedge clk)begin
                    if(temp != 4'b1110 && temp != 4'b1101 && temp != 4'b1011 && temp != 4'b0111) temp = 4'b1110;            //초기값 설정을 위함
                    else if(temp == 4'b0111) temp = 4'b1110;
                    else temp = {temp[2:0], 1'b1};                    //좌쉬프트
                    
            end
            
            assign com = temp;
endmodule
//------------------------------------------------------------------//





//------------------------------------------------------------------//
module up_counter_p_12bit(
        input clk, up_down,
        input reset_p,
        output reg [11:0] count
);

        always @(posedge clk or posedge reset_p)begin
                if(reset_p) count = 0;
                else begin
                    if(up_down)begin
                        count = count +1;
                    end
                else begin
                        count = count-1;
                        end
                end
            end
endmodule
//------------------------------------------------------------------//



//------------------------------------------------------------------//
module up_counter_p_Nbit2 #(parameter N = 4)(
        input clk, up_down,
        input reset_p,
        output reg [N-1:0] count
);

        always @(posedge clk or posedge reset_p)begin
                if(reset_p) count = 0;
                else if(up_down) count = count +1;
                else count = count - 1;
         end
endmodule
//------------------------------------------------------------------//






//------------------------------------------------------------------//
module up_counter_p_Nbit #(parameter N = 4)(        //T플립플롭을 이용해서 버튼을 누를때마다 업/다운으로 토글되게끔
        input clk, up_down,
        input reset_p,
        output reg [N-1:0] count
);

                    

        always @(posedge clk or posedge reset_p)begin
                if(reset_p) count = 0;
                else if(up_down) count = count +1;
                else count = count - 1;
         end
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module edge_detector_n (
            input clk,
            input cp_in,            //cp클럭펄스를 받아서
            input reset_p,
            output p_edge,          //posedge경우 아주 짧은 pulse하나를 내보낸다.
            output n_edge           //negedge경우 아주 짧은 pulse하나를 내보낸다.
);

        reg cp_in_old, cp_in_cur;           //D F/F 2개
        
        always @(negedge clk or posedge reset_p)begin
                if(reset_p)begin cp_in_old = 0; cp_in_cur = 0; end
                else begin 
                        cp_in_old <= cp_in_cur;     //2번째 D F/F         //clk의 neg 엣지에서 cp_in이 cp_in_cur로 들어가고 cp_cur이 
                        cp_in_cur <= cp_in;             //1번째 D F/F
                                                                      //always문 안에서는 그냥 "="을 사용하면 라인이 순차적으로 진행된다.
                                                                      //"<="를 사용하면 병렬로 동작한다. 오른쪽값은 동시에 결정되고 왼쪽에 값을 넣는 것은 순차적으로 진행한다.(non blocking)
                                                                      //ex in=1일 때 cur = 0은 동시에 되고 집어넣는 거는 순차적으로 진행됨
                                                                      //그러면 최종적으로 old = 1이되고 cur=0dl 된다.        f/f사용할 때는 defalut값을 non blocking문을 사용한다고 생각하자
                                                                      //shift레지스터를 만들 때는 non blocking문을 사용해야함
                                                                      //edge가 아니라 레벨트리거링을 할때는 조합회로가 만들어지기 때문에 blocking문을 사용해야함
                end
        end
        
        assign p_edge = ~cp_in_old & cp_in_cur;         
        assign n_edge = cp_in_old & ~cp_in_cur;

endmodule
//------------------------------------------------------------------//


////------------------------------------------------------------------//
//module shift_register_SISO_struct(                 //D f/f4개로 4비트 직렬입력-직렬출력 레지스터
//        input d,
//        input clk,
//        input reset_p,
//        output q
//);
//        wire [2:0] w;
        
//        D_flip_flop_n D3(.d(d), .clk(clk), .reset_p(reset_p), .q(w[2]));
//        D_flip_flop_n D2(.d(w[2]), .clk(clk), .reset_p(reset_p), .q(w[1]));
//        D_flip_flop_n D1(.d(w[1]), .clk(clk), .reset_p(reset_p), .q(w[0]));
//        D_flip_flop_n D0(.d(w[0]), .clk(clk), .reset_p(reset_p), .q(q));
       
        
//endmodule
////------------------------------------------------------------------//

//------------------------------------------------------------------//
module shift_register_SISO_n(                 //D f/f4개로 4비트 직렬입력-직렬출력 레지스터       //동작점 모델링
        input d,
        input clk,
        input reset_p,
        output reg q
);
        
        reg [3:0] siso;
        
        always @(negedge clk or posedge reset_p)begin
                if(reset_p) siso = 0;
                else begin
                siso[3] <= d;                                //non-blocking문
                siso[2] <= siso[3];
                siso[1] <= siso[2];
                siso[0] <= siso[1];
                q <= siso[0];
                end
        end
       
        
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module shift_register_PISO(
        input [3:0] d,
        input clk, reset_p, shift_load,                //shift_load = 0이면 MUX의 A가 출력으로(Load) ,shift_load = 1이면 MUX B가 출력으로(Shift)
        output q
);

        reg [3:0] data;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) data = 0;
                else if(shift_load) data = {1'b0, data[3:1]};           //shift_load = 1이면 shift하니까 최상위비트를 0으로 채워주고, 원래 data[3:1]이 [2:0]으로 간다.
                else data = d;                  //data : shift 레지스터         shift_load = 0이면 load니까 input d가 data에 저장됨
        end
        
        assign q = data[0];
        
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module shift_register_SIPO_str(                             //구조적 모델링
        input d,
        input clk, reset_p,
        input rd_en,                             //출력을 활성화할지 말지 정함
        output [3:0] q                          //병렬출력이므로 4비트 출력
);
         wire [3:0] shift_register;      
        
        D_flip_flop_n D3(.d(d), .clk(clk), .reset_p(reset_p), .q(shift_register[3]));
        D_flip_flop_n D2(.d(shift_register[3]), .clk(clk), .reset_p(reset_p), .q(shift_register[2]));
        D_flip_flop_n D1(.d(shift_register[2]), .clk(clk), .reset_p(reset_p), .q(shift_register[1]));
        D_flip_flop_n D0(.d(shift_register[1]), .clk(clk), .reset_p(reset_p), .q(shift_register[0]));

        
        bufif1 (q[0], shift_register[0], rd_en);            
        bufif1 (q[1], shift_register[1], rd_en);
        bufif1 (q[2], shift_register[2], rd_en);
        bufif1 (q[3], shift_register[3], rd_en);                  

endmodule
//------------------------------------------------------------------//



//------------------------------------------------------------------//
module shift_register_SIPO(                         //동작점모델링
            input d,
            input clk, reset_p,
            input rd_en,
            output [3:0] q
);

        reg [3:0] shift_register;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) shift_register <= 0;
                else shift_register <= {d, shift_register[3:1]};
                
        end
        
        assign q = (rd_en) ? shift_register : 4'bz;
        
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module shift_register(                                      //범용 shift_register임
        input clk, reset_p, shift, load, sin,
        input [7:0] data_in,
        output reg [7:0] data_out
);

        reg [7:0] shift_register;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) data_out = 0;
                else if(shift) data_out = {sin, data_out[7:1]};                     //shift=1일때    오픈쪽 shift 수행
                else if(load) data_out = data_in;                                           //shift = 0이고 load = 1일때    병렬 입력 수행
                else data_out = data_out;                                                       //shift = 0이고 load = 0일때 데이터 유지
        end
        
        //assign data_out = (load) ? shift_register : 4'bz;

endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module register_p(          
            input [3:0] d,
            input clk, reset_p, wr_en, rd_en,
            output q
);

        reg [3:0] register;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) register = 0;
                else if(wr_en) register = d;
                else register = register;
        end
        
        assign q = rd_en ? register : 'bz;

endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module register_Nbit_p #(parameter N = 8)(          
            input [N-1:0] d,
            input clk, reset_p, wr_en, rd_en,
            output q
);

        reg [N-1:0] register;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) register = 0;
                else if(wr_en) register = d;
                else register = register;
        end
        
        assign q = rd_en ? register : 'bz;

endmodule
//------------------------------------------------------------------//



//------------------------------------------------------------------//
module sram_8bit_1024(                      //8bit 1K짜리 메모리
        input clk, wr_en, rd_en,
        input [9:0] addr,                                            //select bit가 10개 2^10이므로 1K
        inout [7:0] data                                        //inout : input도되고 output도 됨
        //메모리는 reset하지 않는다
);

        reg [7:0] mem [0:1023];                             //0~1024개의 배열이 있다는 것임
                                                                                //8비트짜리 메모리가 1024개 있다는 뜻임
                                                                                //0번 bit에 접근할때는 mem[0] << [0]는 주소임(배열 인덱스)
        
        always @(posedge clk)
                if(wr_en) mem[addr] <= data;
        
        assign data = rd_en ? mem[addr] : 8'bz;


endmodule
//------------------------------------------------------------------//























