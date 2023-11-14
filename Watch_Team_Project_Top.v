`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 11:34:24
// Design Name: 
// Module Name: Watch_Team_Project_Top
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

module up_counter_p_3(                      //�����
    input clk,
    input reset_p,
    input [3:0] btn,
    output reg [1:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 3;                         //btn[0]�� ����ġ�� Full-Up�̱� ������ Program Device�� �� �������� ���� �߻�
                                                       //�׷��� count = 3���� �� �� �ѹ� �������� ���� �߻� �� count = 0�� �ǰ� ��
            else begin
                if(btn[0]) begin
                    count = count + 1;    
                    if(count == 2'b11)  count = 0;     //count == 2'b11�� �� �� count�� �ٽ� 0���ΰ�
                end
            end
    end
endmodule

module up_counter_p_5(                      //�����
    input clk,
    input reset_p,
    input btn,
    output reg [2:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]�� ����ġ�� Full-Up�̱� ������ Program Device�� �� �������� ���� �߻�
                                                       //�׷��� count = 3���� �� �� �ѹ� �������� ���� �߻� �� count = 0�� �ǰ� ��
            else begin
                if(btn) begin
                    count = count + 1;    
                    if(count == 5)  count = 0;     //count == 2'b11�� �� �� count�� �ٽ� 0���ΰ�
                end
            end
    end
endmodule

module up_counter_p_test(                      //�����
    input clk,
    input reset_p,
    input btn,
    output reg [7:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]�� ����ġ�� Full-Up�̱� ������ Program Device�� �� �������� ���� �߻�
                                                       //�׷��� count = 3���� �� �� �ѹ� �������� ���� �߻� �� count = 0�� �ǰ� ��
            else begin
                if(btn) begin
                    count = count + 1;    
                    if(count == 140)  count = 0;     //count == 2'b11�� �� �� count�� �ٽ� 0���ΰ�
                end
            end
    end
endmodule

module up_counter_p_100(                      //�����
    input clk,
    input reset_p,
    input [3:0] btn,
    output reg [6:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 99;                         //btn[0]�� ����ġ�� Full-Up�̱� ������ Program Device�� �� �������� ���� �߻�
                                                       //�׷��� count = 3���� �� �� �ѹ� �������� ���� �߻� �� count = 0�� �ǰ� ��
            else begin
                if(btn[0]) begin
                    count = count + 1;    
                    if(count == 100)  count = 0;     //count == 2'b11�� �� �� count�� �ٽ� 0���ΰ�
                end
            end
    end
endmodule

module Watch_Team_Project_Top(
    input clk, reset_p,
    input [3:0] btn,
    output [3:0] com,
    output [7:0] seg_7,
    output reg [7:0] led_bar,
    output buzzer
    );

    wire [1:0] Mode;        

    //��ư[3] ������ ������ mode�ٲ��//
    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(btn3_press));
    up_counter_p_3 up_c(.clk(clk), .reset_p(reset_p), .btn(btn3_press), .count(Mode));
    //��ư[3] ������ ������ mode�ٲ��//
    
    reg [2:0] btn_module1, btn_module2, btn_module3;
    //Mode���� btn�� ���� ���� Reg
    

    reg [15:0] value;               //FND�� �ѷ��� reg
    wire [15:0] value_watch;   
    wire [15:0] value_stop_watch;
    wire [15:0] value_cook_timer;

    watch_hour_min_project watch(.clk(clk), .reset_p(reset_p), .btn(btn_module1), .value_watch(value_watch));
    //Watch module
    stop_watch_top_pro2_counter100_top_project stop_watch(.clk(clk), .reset_p(reset_p), .btn(btn_module2), .value_stop_watch(value_stop_watch));
    //Stop Watch module
    cook_timer_project cook_timer(.clk(clk), .reset_p(reset_p), .btn(btn_module3), .value_cook_timer(value_cook_timer), .buzzer(buzzer));
    //Cook Timer module

    //���⼭�� mode�� ����� ������ ��忡 �´� �����͸� FND�� �ѷ��ִ� always��
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) led_bar = 0;
        else begin
            if(Mode == 2'b00) begin         //Mode1�� �� Watch�� �۵�
                led_bar = 8'b0000_0001;     //Mode1���� Ȯ�� �ϱ� ���� LED
                btn_module1 = btn[2:0];     //Mode1�� �� btn�� ���� ���� btn_module1�̶�� reg�� ����
                value = value_watch;        //FND�� �ѷ��� value�� Watch Module�� ��� value_watch
            end
            else if(Mode == 2'b01) begin    //Mode2�� �� Stop_watch�� �۵�
                led_bar = 8'b0000_0010;     //Mode2���� Ȯ�� �ϱ� ���� LED
                btn_module2 = btn[2:0];     //Mode2�� �� btn�� ���� ���� btn_module2�̶�� reg�� ����
                value = value_stop_watch;   //FND�� �ѷ��� value�� Stop Watch Module�� ��� value_stop_watch
            end
            else begin                      //Mode3�� �� Cook_timer�� �۵�
                led_bar = 8'b0000_0100;     //Mode3���� Ȯ���ϱ� ���� LED
                btn_module3 = btn[2:0];     //Mode3�� �� btn�� ���� ���� btn_module3�̶�� reg�� ����
                value = value_cook_timer;   //FND�� �ѷ��� value�� Cook Timer�� ��� value_cook_timer
            end
        end
    end

    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7)); 

endmodule

module demux_1_3_project(
    input d,
    input [1:0] s,
    output [2:0] f
    );
    
    assign f = (s == 2'b00) ? 3'b001 : (s == 2'b01) ? 3'b010 : 3'b100;

endmodule

module demux_3_9project(
    input [2:0] d,
    input [1:0] s,
    output [8:0] f
    );
    
    assign f = (s == 2'b00) ? {d[2:0], 6'b000000} : (s == 2'b01) ? {3'b000, d[2:0], 3'b000} : {6'b000000, d[2:0]};

endmodule























