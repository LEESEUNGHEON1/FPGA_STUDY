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
        input t,          //edge detection�� ����ϱ� ����
        input reset_p,
        output reg q
    );
    always @(negedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else if(t) q = ~q;
        else q = q;             //f/f�̹Ƿ� else���� �Ƚ��൵ ���� ������      ���ճ�ȸ���϶��� else���� ����ؾ���
    end
endmodule
//------------------------------------------------------------------//

//------------------------------------------------------------------//
module T_flip_flop_p (
        input clk,
        input t,        //edge detection�� ����ϱ� ����
        input reset_p,
        output reg q
    );
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) q =0;
        else if(t) q = ~q;      //f/f�̹Ƿ� else���� �Ƚ��൵ ���� ������      ���ճ�ȸ���϶��� else���� ����ؾ���
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
                    if(temp != 4'b1110 && temp != 4'b1101 && temp != 4'b1011 && temp != 4'b0111) temp = 4'b1110;            //�ʱⰪ ������ ����
                    else if(temp == 4'b0111) temp = 4'b1110;
                    else temp = {temp[2:0], 1'b1};                    //�½���Ʈ
                    
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
module up_counter_p_Nbit #(parameter N = 4)(        //T�ø��÷��� �̿��ؼ� ��ư�� ���������� ��/�ٿ����� ��۵ǰԲ�
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
            input cp_in,            //cpŬ���޽��� �޾Ƽ�
            input reset_p,
            output p_edge,          //posedge��� ���� ª�� pulse�ϳ��� ��������.
            output n_edge           //negedge��� ���� ª�� pulse�ϳ��� ��������.
);

        reg cp_in_old, cp_in_cur;           //D F/F 2��
        
        always @(negedge clk or posedge reset_p)begin
                if(reset_p)begin cp_in_old = 0; cp_in_cur = 0; end
                else begin 
                        cp_in_old <= cp_in_cur;     //2��° D F/F         //clk�� neg �������� cp_in�� cp_in_cur�� ���� cp_cur�� 
                        cp_in_cur <= cp_in;             //1��° D F/F
                                                                      //always�� �ȿ����� �׳� "="�� ����ϸ� ������ ���������� ����ȴ�.
                                                                      //"<="�� ����ϸ� ���ķ� �����Ѵ�. �����ʰ��� ���ÿ� �����ǰ� ���ʿ� ���� �ִ� ���� ���������� �����Ѵ�.(non blocking)
                                                                      //ex in=1�� �� cur = 0�� ���ÿ� �ǰ� ����ִ� �Ŵ� ���������� �����
                                                                      //�׷��� ���������� old = 1�̵ǰ� cur=0dl �ȴ�.        f/f����� ���� defalut���� non blocking���� ����Ѵٰ� ��������
                                                                      //shift�������͸� ���� ���� non blocking���� ����ؾ���
                                                                      //edge�� �ƴ϶� ����Ʈ���Ÿ��� �Ҷ��� ����ȸ�ΰ� ��������� ������ blocking���� ����ؾ���
                end
        end
        
        assign p_edge = ~cp_in_old & cp_in_cur;         
        assign n_edge = cp_in_old & ~cp_in_cur;

endmodule
//------------------------------------------------------------------//


////------------------------------------------------------------------//
//module shift_register_SISO_struct(                 //D f/f4���� 4��Ʈ �����Է�-������� ��������
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
module shift_register_SISO_n(                 //D f/f4���� 4��Ʈ �����Է�-������� ��������       //������ �𵨸�
        input d,
        input clk,
        input reset_p,
        output reg q
);
        
        reg [3:0] siso;
        
        always @(negedge clk or posedge reset_p)begin
                if(reset_p) siso = 0;
                else begin
                siso[3] <= d;                                //non-blocking��
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
        input clk, reset_p, shift_load,                //shift_load = 0�̸� MUX�� A�� �������(Load) ,shift_load = 1�̸� MUX B�� �������(Shift)
        output q
);

        reg [3:0] data;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) data = 0;
                else if(shift_load) data = {1'b0, data[3:1]};           //shift_load = 1�̸� shift�ϴϱ� �ֻ�����Ʈ�� 0���� ä���ְ�, ���� data[3:1]�� [2:0]���� ����.
                else data = d;                  //data : shift ��������         shift_load = 0�̸� load�ϱ� input d�� data�� �����
        end
        
        assign q = data[0];
        
endmodule
//------------------------------------------------------------------//


//------------------------------------------------------------------//
module shift_register_SIPO_str(                             //������ �𵨸�
        input d,
        input clk, reset_p,
        input rd_en,                             //����� Ȱ��ȭ���� ���� ����
        output [3:0] q                          //��������̹Ƿ� 4��Ʈ ���
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
module shift_register_SIPO(                         //�������𵨸�
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
module shift_register(                                      //���� shift_register��
        input clk, reset_p, shift, load, sin,
        input [7:0] data_in,
        output reg [7:0] data_out
);

        reg [7:0] shift_register;
        
        always @(posedge clk or posedge reset_p)begin
                if(reset_p) data_out = 0;
                else if(shift) data_out = {sin, data_out[7:1]};                     //shift=1�϶�    ������ shift ����
                else if(load) data_out = data_in;                                           //shift = 0�̰� load = 1�϶�    ���� �Է� ����
                else data_out = data_out;                                                       //shift = 0�̰� load = 0�϶� ������ ����
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
module sram_8bit_1024(                      //8bit 1K¥�� �޸�
        input clk, wr_en, rd_en,
        input [9:0] addr,                                            //select bit�� 10�� 2^10�̹Ƿ� 1K
        inout [7:0] data                                        //inout : input���ǰ� output�� ��
        //�޸𸮴� reset���� �ʴ´�
);

        reg [7:0] mem [0:1023];                             //0~1024���� �迭�� �ִٴ� ����
                                                                                //8��Ʈ¥�� �޸𸮰� 1024�� �ִٴ� ����
                                                                                //0�� bit�� �����Ҷ��� mem[0] << [0]�� �ּ���(�迭 �ε���)
        
        always @(posedge clk)
                if(wr_en) mem[addr] <= data;
        
        assign data = rd_en ? mem[addr] : 8'bz;


endmodule
//------------------------------------------------------------------//























