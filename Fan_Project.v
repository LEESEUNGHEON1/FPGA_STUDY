`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 10:51:24
// Design Name: 
// Module Name: Fan_Project
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

//===========================================================================================================================//
module Fan_Project(
    input clk, reset_p,
    input [3:0] btn,
    input vaux6_n, vaux6_p,
    output pwmpin_1, pwmpin_2, pwmpin_3,
    output [3:0] com,
    output [7:0] seg_7,           
    output [7:0] led_bar
    );

    wire timeout;
    wire motor_reset;
    assign motor_reset = reset_p ? 1 : timeout ? 1 : 0;
    //1�� : ���� PWM ����
    dcmotor_pwm_project2 demotor(.clk(clk), .reset_p(motor_reset), .btn(btn[0]), .pwmpin_1(pwmpin_1), .led_bar(led_bar[7:4]));

    //2�� : LED ��� PWM ����
    LED_PWM_Project2 led(.clk(clk), .reset_p(motor_reset), .btn(btn[1]), .pwmpin_2(pwmpin_2));

    //3�� : Off Ÿ�̸�
    Fan_timer_project2 timer(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .led_bar(led_bar[3:0]), .com(com), .seg_7(seg_7), .timeout(timeout));

    //�߰���� : ���̽�ƽADC������ �������� ����
    adc_ch6_joystick_project joystick_survo(.clk(clk), .reset_p(motor_reset), .vaux6_n(vaux6_n), .vaux6_p(vaux6_p), .pwmpin_3(pwmpin_3));

    //FND���� Ÿ�̸� �ð� �����
    //Motor, LED ��� �� counter��⿡ reset_p�� Ÿ�̸Ӱ� ������ �� ������ ����̶� ���� ����
endmodule
//===========================================================================================================================//









































