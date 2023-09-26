`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 15:08:08
// Design Name: 
// Module Name: pwm_100
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


module pwm_100(
    input clk, reset_p,
    input [6:0] duty,               //duty는 100까지이므로 7bit 설정
    input [13:0] pwm_preq,
    output reg pwm_100per
    );
    //pwm_preq에 1000을 주고 duty에 50을 주면 주파수가 1000hz고 duty가 50인 출력이 나온다.
    parameter sys_clk_preq = 125_000_000;

    reg [26:0] cnt;
    reg clk_preqX100;
    

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt = 0;
            clk_preqX100 = 0;
        end
              //LED는 주파수가 1kHz ~ 10kHz까지 해야 켜져있는 것 처럼 보임
                        //(최소 2ms주기로 주면 켜져있는 것처럼 보이며 Duty %에 따라 밝기 조절 가능)
                        //모터 경우에는 100~1000Hz까지 줘도 이어지는 것처럼 잘 동작함
            else begin
                if(cnt >= sys_clk_preq / pwm_preq / 200) begin
                    cnt = 0;
                    clk_preqX100 = ~clk_preqX100;
                end
                else begin
                    cnt = cnt + 1;
                end
            end
        
        //LED에 Duty가 50%인데 주파수가 1hz이면 0.5s동안 on 0.5s동안 off임 깜빡깜빡 
    end

    wire clk_preqX100_ne;

    edge_detector_p ed_btn(.clk(clk), .cp_in(clk_preqX100), .reset_p(reset_p), .n_edge(clk_preqX100_ne));

    reg [6:0] cnt_duty;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt_duty = 0;
            pwm_100per = 0;
        end
        else if(clk_preqX100_ne) begin
            if(cnt_duty >= 99) cnt_duty = 0;
            else cnt_duty = cnt_duty + 1;

            if(cnt_duty < duty) pwm_100per = 1;
            else pwm_100per = 0;
        end
    end

endmodule

module pwm_1000_fre(           //DUTY를 1/1000 정밀도를 만드는 모듈
    input clk, reset_p,
    input [9:0] dutyX10,               //duty는 100까지이므로 7bit 설정
    input [13:0] pwm_freq,
    output reg pwm_1000per
    );
    parameter sys_clk_freq = 125_000_000;

    reg [26:0] cnt;
    reg clk_freqX1000;
    

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt = 0;
            clk_freqX1000 = 0;
        end
            else begin
                if(cnt >= sys_clk_freq / pwm_freq / 2000) begin     //기존에는 pwm_freq를 100단위로 나누기 위해 
                                                                    //100으로 나누고 0과 1을 위해 2로 나눠서 200을 나눠줬지만
                                                                    //이번에는 pwm_freq를 1000단위로 나누기 위해
                                                                    //1000으로 나누고 0과 1을 위해 2로 나눠서 2000을 나눠줬다.
                    cnt = 0;
                    clk_freqX1000 = ~clk_freqX1000;
                end
                else begin
                    cnt = cnt + 1;
                end
            end
    end

    wire clk_freqX1000_ne;

    edge_detector_p ed_btn(.clk(clk), .cp_in(clk_freqX1000), .reset_p(reset_p), .n_edge(clk_freqX1000_ne));

    reg [9:0] cnt_duty;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt_duty = 0;
            pwm_1000per = 0;
        end
        else if(clk_freqX1000_ne) begin
            if(cnt_duty >= 999) cnt_duty = 0;           //1/1000정확도를 위해 0~999까지
            else cnt_duty = cnt_duty + 1;

            if(cnt_duty < dutyX10) pwm_1000per = 1;
            else pwm_1000per = 0;
        end
    end

endmodule


module led_pwm_top(
    input clk, reset_p,
    output led_r,
    output led_b,
    output led_g
    );

    //Duty를 카운터를 이용해서 바꿔줄 것임
    reg [27:0] clk_div;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) clk_div = 0;
        else clk_div = clk_div + 1;
    end

    pwm_100 pwm_r(.clk(clk), .reset_p(reset_p), .duty({2'b000, clk_div[27:24]}), .pwm_preq(10000), .pwm_100per(led_r));
    //LED경우 밝기를 조절하고 싶을 땐 10000Hz가 적당함
    //LED경우 50%의 밝기만 되도 최대 밝기가 되버리기 때문에

    pwm_100 pwm_b(.clk(clk), .reset_p(reset_p), .duty({2'b000, clk_div[26:23]}), .pwm_preq(10000), .pwm_100per(led_b));
    pwm_100 pwm_g(.clk(clk), .reset_p(reset_p), .duty({2'b000, clk_div[25:22]}), .pwm_preq(10000), .pwm_100per(led_g));


endmodule


module ServoMotor(
    input clk, reset_p,
    input [3:0] btn,
    output pwmpin_1,
    output [3:0] com,
    output [7:0] seg_7
    );
    
    wire [2:0] Mode;        
    reg [6:0] value;
    //버튼[3] 눌러질 때마다 mode바뀌게//
    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(btn3_press));
    up_counter_p_5 up_c(.clk(clk), .reset_p(reset_p), .btn(btn3_press), .count(Mode));
    //버튼[3] 눌러질 때마다 mode바뀌게//

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin end
        else begin
            if(Mode == 0) begin         
                value = 21;
            end
            else if(Mode == 1) begin   
                value = 50;
            end
            else if(Mode == 2) begin
                value = 75;
            end
            else if(Mode == 3) begin
                value = 100;
            end
            else if(Mode == 4) begin
                value = 123;
            end
            
        end
    end

    pwm_1000_fre servopwm(.clk(clk), .reset_p(reset_p), .dutyX10(value), .pwm_freq(50), .pwm_1000per(pwmpin_1));
    
    wire [15:0] bcd_duty;
    bin_to_dec(.bin(value), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7));

endmodule


module ServoMotor_test(
    input clk, reset_p,
    input [3:0] btn,
    output pwmpin_1
    );
    
    wire [2:0] Mode;        
    reg [6:0] value;
    //버튼[3] 눌러질 때마다 mode바뀌게//
    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(btn3_press));
    up_counter_p_5 up_c(.clk(clk), .reset_p(reset_p), .btn(btn3_press), .count(Mode));
    //버튼[3] 눌러질 때마다 mode바뀌게//

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin end
        else begin
            if(Mode == 0) begin         
                value = 21;
            end
            else if(Mode == 1) begin   
                value = 50;
            end
            else if(Mode == 2) begin
                value = 75;
            end
            else if(Mode == 3) begin
                value = 100;
            end
            else if(Mode == 4) begin
                value = 125;
            end
            
        end
    end

    pwm_1000_fre servopwm(.clk(clk), .reset_p(reset_p), .dutyX10(value), .pwm_freq(50), .pwm_1000per(pwmpin_1));
    
    wire [15:0] bcd_duty;
    bin_to_dec(.bin(value), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7)); 

endmodule

module servo_sg90_pro (
    input clk, reset_p,
    output pwmpin_1,
    output [3:0] com,
    output [7:0] seg_7
    );
    
    reg [9:0] duty;

    pwm_1000_fre servo(.clk(clk), .reset_p(reset_p), .dutyX10(duty), .pwm_freq(50), .pwm_1000per(pwmpin_1));

    reg [21:0] clk_div;
    always @(posedge clk) begin
        clk_div = clk_div + 1;
    end

    wire clk_div_21_ne;
    edge_detector_n ed(.clk(clk), .cp_in(clk_div[21]), .reset_p(reset_p), .n_edge(clk_div_21_ne));

    reg down_up;
    parameter UP = 0;
    parameter DOWN = 1;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            duty = 20;
            down_up = 0;
        end
        else if(clk_div_21_ne) begin
            if(down_up) begin
                if(duty < 20) down_up = UP;          
                else duty = duty - 1;
            end
            else begin
                if(duty > 130) down_up = DOWN;
                else duty = duty + 1;
            end
        end
    end

    wire [15:0] bcd_duty;
    bin_to_dec(.bin(duty), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7)); 

endmodule


module dcmotor(
    input clk, reset_p,
    input [3:0] btn,
    output pwmpin_1,
    output [3:0] com,
    output [7:0] seg_7
    );
    
    wire [6:0] duty;

    wire btn3_press;

    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(btn3_press));
    up_counter_p_100 up_count(.clk(clk), .reset_p(reset_p), .btn(btn3_press), .count(duty));
    //버튼3번이 눌러질 때마다 duty를 1씩 올려서 모터가 duty 몇%부터 돌기 시작하는지 확인하기 위함

    pwm_100 dcpwm(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm_preq(100), .pwm_100per(pwmpin_1));

    wire [15:0] bcd_duty;
    bin_to_dec btd(.bin(duty), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7));

endmodule


module dcmotor_pwm_project2(
    input clk, reset_p,
    input btn,
    output pwmpin_1,
    output reg [7:4] led_bar
    );

    wire [6:0] duty;

    wire btn0_press;

    button_cntr btn_cnt0(.clk(clk), .reset_p(reset_p), .btn(btn), .btn_pe(btn0_press));
    up_counter_p_4 up_count(.clk(clk), .reset_p(reset_p), .btn(btn0_press), .count(duty));


    pwm_100 dcpwm(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm_preq(100), .pwm_100per(pwmpin_1));

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) led_bar = 0;
        else begin
            if(duty == 0)   led_bar = 4'b0000;
            else if(duty == 25)     led_bar = 4'b1000;
            else if(duty == 50)     led_bar = 4'b1100;
            else if(duty == 75)     led_bar = 4'b1110;
            else if(duty == 100)    led_bar = 4'b1111;
        end
    end

    
endmodule

module LED_PWM_Project2(
    input clk, reset_p,
    input btn,
    output pwmpin_2
    //output [3:0] com,
    //output [7:0] seg_7
    );

    wire [6:0] duty;

    wire btn1_press;

    button_cntr btn_cnt1(.clk(clk), .reset_p(reset_p), .btn(btn), .btn_ne(btn1_press));
    up_counter_p_3_led up_count(.clk(clk), .reset_p(reset_p), .btn(btn1_press), .count(duty));

    reg [21:0] clk_div;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) clk_div = 0;
        else    clk_div = clk_div + 1;    
        
    end
    
    wire clk_div_21_ne;
    edge_detector_n ed(.clk(clk), .cp_in(clk_div[21]), .reset_p(reset_p), .n_edge(clk_div_21_ne));

    wire [6:0] duty_div;
    assign duty_div = duty;
    reg [6:0] duty_30;
    reg [1:0] count;

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
           duty_30 = 0; 
           count = 0;
        end
        else begin
            if(btn1_press) begin
                count = count + 1;
                if(count == 1) duty_30 = 0;
                else if(count == 2) duty_30 = 30;
                else if(count == 3) duty_30 = 60;
            end
            else if(clk_div_21_ne) begin
                if(duty_div >= duty_30) begin
                    duty_30 = duty_30 + 1;
                end
                else if(duty_30 >= duty_div) begin
                    duty_30 = duty_30 - 1;
                end
            end
        end
    end

    pwm_100 ledpwm(.clk(clk), .reset_p(reset_p), .duty(duty_30), .pwm_preq(10000), .pwm_100per(pwmpin_2));

    //always @(posedge clk or posedge reset_p) begin
    //    if(reset_p) led_bar = 0;
    //    else begin
    //        if(duty == 0)   led_bar = 4'b0000;
    //        else if(duty == 30)     led_bar = 4'b0001;
    //        else if(duty == 60)     led_bar = 4'b0011;
    //        else if(duty == 90)     led_bar = 4'b0111;
    //    end
    //end

    //wire [15:0] bcd_duty;
    //bin_to_dec btd(.bin(duty), .bcd(bcd_duty));
    //FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7));
    
endmodule

module up_counter_p_4(                      //동기식
    input clk,
    input reset_p,
    input [3:0] btn,
    output reg [6:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn[0]) begin
                    count = count + 25;    
                    if(count > 100)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
                end
            end
    end
endmodule

module up_counter_p_3_led(                      //동기식
    input clk,
    input reset_p,
    input btn,
    output reg [6:0] count
    );

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;                         //btn[0]의 스위치가 Full-Up이기 때문에 Program Device할 때 눌러지는 판정 발생
                                                       //그래서 count = 3으로 한 뒤 한번 눌러지는 판정 발생 후 count = 0이 되게 함
            else begin
                if(btn) begin
                    count = count + 30;    
                    if(count > 90)  count = 0;     //count == 2'b11이 될 때 count는 다시 0으로감
                end
            end
    end
endmodule




























