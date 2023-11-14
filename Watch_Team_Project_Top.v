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

module up_counter_p_3(                      //동기식
    input clk,
    input reset_p,
    input [3:0] btn,
    output reg [1:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 3;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn[0]) begin
                    count = count + 1;    
                    if(count == 2'b11)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
                end
            end
    end
endmodule

module up_counter_p_5(                      //동기식
    input clk,
    input reset_p,
    input btn,
    output reg [2:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn) begin
                    count = count + 1;    
                    if(count == 5)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
                end
            end
    end
endmodule

module up_counter_p_test(                      //동기식
    input clk,
    input reset_p,
    input btn,
    output reg [7:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn) begin
                    count = count + 1;    
                    if(count == 140)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
                end
            end
    end
endmodule

module up_counter_p_100(                      //동기식
    input clk,
    input reset_p,
    input [3:0] btn,
    output reg [6:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 99;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn[0]) begin
                    count = count + 1;    
                    if(count == 100)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
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

    //버튼[3] 눌러질 때마다 mode바뀌게//
    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(btn3_press));
    up_counter_p_3 up_c(.clk(clk), .reset_p(reset_p), .btn(btn3_press), .count(Mode));
    //버튼[3] 눌러질 때마다 mode바뀌게//
    
    reg [2:0] btn_module1, btn_module2, btn_module3;
    //Mode마다 btn을 따로 받을 Reg
    

    reg [15:0] value;               //FND에 뿌려줄 reg
    wire [15:0] value_watch;   
    wire [15:0] value_stop_watch;
    wire [15:0] value_cook_timer;

    watch_hour_min_project watch(.clk(clk), .reset_p(reset_p), .btn(btn_module1), .value_watch(value_watch));
    //Watch module
    stop_watch_top_pro2_counter100_top_project stop_watch(.clk(clk), .reset_p(reset_p), .btn(btn_module2), .value_stop_watch(value_stop_watch));
    //Stop Watch module
    cook_timer_project cook_timer(.clk(clk), .reset_p(reset_p), .btn(btn_module3), .value_cook_timer(value_cook_timer), .buzzer(buzzer));
    //Cook Timer module

    //여기서는 mode가 변경될 때마다 모드에 맞는 데이터를 FND에 뿌려주는 always문
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) led_bar = 0;
        else begin
            if(Mode == 2'b00) begin         //Mode1일 때 Watch로 작동
                led_bar = 8'b0000_0001;     //Mode1인지 확인 하기 위한 LED
                btn_module1 = btn[2:0];     //Mode1일 때 btn을 누른 값을 btn_module1이라는 reg에 저장
                value = value_watch;        //FND에 뿌려줄 value에 Watch Module의 출력 value_watch
            end
            else if(Mode == 2'b01) begin    //Mode2일 때 Stop_watch로 작동
                led_bar = 8'b0000_0010;     //Mode2인지 확인 하기 위한 LED
                btn_module2 = btn[2:0];     //Mode2일 때 btn을 누른 값을 btn_module2이라는 reg에 저장
                value = value_stop_watch;   //FND에 뿌려줄 value에 Stop Watch Module의 출력 value_stop_watch
            end
            else begin                      //Mode3일 때 Cook_timer로 작동
                led_bar = 8'b0000_0100;     //Mode3인지 확인하기 위한 LED
                btn_module3 = btn[2:0];     //Mode3일 때 btn을 누른 값을 btn_module3이라는 reg에 저장
                value = value_cook_timer;   //FND에 뿌려줄 value에 Cook Timer의 출력 value_cook_timer
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























