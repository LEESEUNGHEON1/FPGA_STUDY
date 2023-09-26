`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 15:08:54
// Design Name: 
// Module Name: adc_ch6_top
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


module adc_ch6_top(
    input clk, reset_p,
    input vaux6_n, vaux6_p,
    output [3:0] com,
    output [7:0] seg_7
    );

    wire [4:0] channel_out;
    wire [15:0] do_out;
    wire eoc_out;

    xadc_wiz_0 adc_ch6
          (
          .daddr_in({2'b00, channel_out}),            // Address bus for the dynamic reconfiguration port
          //xdc_wiz_0에 가보면 channel_out 4비트를 주면 됨 하지만 daddr_in은 6비트이므로 00으로 채워줌
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),              // Enable Signal for the dynamic reconfiguration port
          //eoc_out end of convert로써 변환이 끝났을 때 이 값(eoc_out)이 1이 나옴
          //그 뒤 do_out(16비트)을 읽으면 됨 -> 보드의 분해능은 12비트임 , 상위 12비트는 ADC값, 하위 4비트는 

        //  di_in,               // Input data bus for the dynamic reconfiguration port
        //  dwe_in,              // Write Enable for the dynamic reconfiguration port
          .reset_in(1'b0),            // Reset signal for the System Monitor control logic      //1에서 리셋됨 -> 리셋안할거라 0
          .vauxp6(vaux6_p),              // Auxiliary channel 6
          .vauxn6(vaux6_n),
        //  busy_out,            // ADC Busy signal
          .channel_out(channel_out),         // Channel Selection Outputs
          .do_out(do_out),              // Output data bus for dynamic reconfiguration port
        //  drdy_out,            // Data ready signal for the dynamic reconfiguration port
          .eoc_out(eoc_out)             // End of Conversion Signal
        //  eos_out,             // End of Sequence Signal            //end of sequencer 3개의 adc를 쓴다면 3개의 adc를 다 읽고나면 1됨
        //  alarm_out,           // OR'ed output of all the Alarms    
        //  vp_in,               // Dedicated Analog Input Pair
        //  vn_in
          );

    wire eco_out_pe;
    reg [11:0] adc_value;
    edge_detector_n ed_eoc(.clk(clk), .reset_p(reset_p), .cp_in(eoc_out), .p_edge(eco_out_pe));

    always @(posedge clk) begin
        if(eco_out_pe) adc_value = {2'b00, do_out[15:6]};
    end

    wire [15:0] bcd_adc;
    bin_to_dec btd(.bin(adc_value), .bcd(bcd_adc));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_adc), .com(com), .seg_7(seg_7));

endmodule


module adc_ch6_joystick_project(
    input clk, reset_p,
    input vaux6_n, vaux6_p,
    //output [3:0] com,
    //output [7:0] seg_7,
    //output reg [7:0] led_bar,
    output pwmpin_3
    );

    wire [4:0] channel_out;
    wire [15:0] do_out;
    wire eoc_out;

    xadc_wiz_0 adc_ch6
          (
          .daddr_in({2'b00, channel_out}),            // Address bus for the dynamic reconfiguration port
          //xdc_wiz_0에 가보면 channel_out 4비트를 주면 됨 하지만 daddr_in은 6비트이므로 00으로 채워줌
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),              // Enable Signal for the dynamic reconfiguration port
          //eoc_out end of convert로써 변환이 끝났을 때 이 값(eoc_out)이 1이 나옴
          //그 뒤 do_out(16비트)을 읽으면 됨 -> 보드의 분해능은 12비트임 , 상위 12비트는 ADC값, 하위 4비트는 

        //  di_in,               // Input data bus for the dynamic reconfiguration port
        //  dwe_in,              // Write Enable for the dynamic reconfiguration port
          .reset_in(1'b0),            // Reset signal for the System Monitor control logic      //1에서 리셋됨 -> 리셋안할거라 0
          .vauxp6(vaux6_p),              // Auxiliary channel 6
          .vauxn6(vaux6_n),
        //  busy_out,            // ADC Busy signal
          .channel_out(channel_out),         // Channel Selection Outputs
          .do_out(do_out),              // Output data bus for dynamic reconfiguration port
        //  drdy_out,            // Data ready signal for the dynamic reconfiguration port
          .eoc_out(eoc_out)             // End of Conversion Signal
        //  eos_out,             // End of Sequence Signal            //end of sequencer 3개의 adc를 쓴다면 3개의 adc를 다 읽고나면 1됨
        //  alarm_out,           // OR'ed output of all the Alarms    
        //  vp_in,               // Dedicated Analog Input Pair
        //  vn_in
          );

    wire eco_out_pe;
    reg [11:0] adc_value;
    edge_detector_n ed_eoc(.clk(clk), .reset_p(reset_p), .cp_in(eoc_out), .p_edge(eco_out_pe));

    always @(posedge clk) begin
        if(eco_out_pe) adc_value = do_out[15:10];
    end

    reg [9:0] duty;

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) duty = 0;
        else begin
           if(adc_value > 13 && adc_value < 25) duty = 75;
           else if(adc_value > 10 && adc_value <= 13) duty = 100;
           else if(adc_value <= 10) duty = 123;
           else if(adc_value >= 25 && adc_value < 50) duty = 50;
           else if(adc_value >= 50) duty = 21;
        end
    end 
    

    pwm_1000_fre servo(.clk(clk), .reset_p(reset_p), .dutyX10(duty), .pwm_freq(50), .pwm_1000per(pwmpin_3));

    //wire [9:0] bcd_adc;
    //bin_to_dec btd(.bin(adc_value), .bcd(bcd_adc));
    //FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value({6'b000000, bcd_adc}), .com(com), .seg_7(seg_7));

endmodule








































