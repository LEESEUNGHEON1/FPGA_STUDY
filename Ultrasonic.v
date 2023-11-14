`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/12 16:07:49
// Design Name: 
// Module Name: Ultrasonic
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


module Ultrasonic(
    input clk, reset_p,
    input Echo_data,                        //input Echo
    output reg Trig_sig,                    //output Trig
    output reg [11:0] Trig_data,
    output reg [7:0] led_bar
    );

    parameter S_START = 4'b0001;            //State1 : 60ms? ???(?? Echo??? ?? ? ??? ??)
    parameter S_START_BIT = 4'b0010;        //State2 : Start?? "1" 12us?? ? Trig_out ?? "0"??
    parameter S_WAIT_ECHO = 4'b0100;        //State3 : ??????? 40kHz? 8?? ?? ?? Wait
    parameter S_RECEIVE_PULSE = 4'b1000;    //State4 : Pedge???? usec? count?? Nedge? ???? count??
                                            //usec_count? 58? ??? 1cm??? ??

    reg [15:0] count_usec;                  //usec? count? reg
    
    wire clk_usec;                  
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));

    reg count_usec_e;    //enable 1??? count

    always @(negedge clk or posedge reset_p) begin
        if(reset_p) count_usec = 0;
        else begin
            if(clk_usec && count_usec_e) count_usec = count_usec + 1;      //enable = 1??? count_usec? ?????
            else if(!count_usec_e) count_usec = 0;                         //enable = 0?? count_usee CLR
        end
    end

    wire dht_pedge, dht_nedge;
    edge_detector_n e_d_n(.clk(clk), .cp_in(Echo_data), .reset_p(reset_p), .p_edge(dht_pedge), .n_edge(dht_nedge));
    //Echo_data??? Rising Edge, Falling Edge ???? ?? ??

    //State ??? ?? reg
    reg [3:0] state, next_state;

    always @(negedge clk or posedge reset_p) begin
        if(reset_p) state = S_START;      //State1?? ??
        else state = next_state;         //? CLK?? state? next_state? ????.
    end
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin               //???
            count_usec_e = 0;
            next_state = S_START;
            Trig_sig = 0;
            led_bar = 8'b0000_0000;
            Trig_data = 0;
        end

        else begin
            case(state)
                S_START: begin                      //State1 : 60ms? ???(?? Echo??? ?? ? ??? ??)
                    if(count_usec < 22'd60_000)begin
                        count_usec_e = 1;           //usec count start
                        Trig_sig = 0;               //Trig LOW
                        led_bar[0] = 1;             
                    end
                    else begin                      //60ms??
                        next_state = S_START_BIT;   //?? Nedge?? State? ??
                        count_usec_e = 0;           //usec count stop , CLR
                    end
                end

                S_START_BIT: begin                  //State2 : Start?? "1" 12us?? ? Trig_out ?? "0"??
                    led_bar[1] = 1;
                    if(count_usec < 12)begin        //12us??
                        count_usec_e = 1;           //usec count start
                        Trig_sig = 1;               //Trig HIGH
                    end
                    else begin                      //12us??
                        next_state = S_WAIT_ECHO;   //?? Nedge?? State? ??
                        count_usec_e = 0;           //usec count stop, CLR
                        Trig_sig = 0;               //TRIG LOW
                    end
                end

                S_WAIT_ECHO: begin                  //State3 : ??????? 40kHz? 8?? ?? ?? Wait
                    led_bar[2] = 1;                 //40kHz 8? = 200us?? ??? 4us? ????
                    if(count_usec < 200) begin      //200us??
                        count_usec_e = 1;           //usec count start
                    end
                    else begin                          //4us??
                        next_state = S_RECEIVE_PULSE;   //?? Nedge?? State? ??
                        count_usec_e = 0;               //usec count stop
                    end
                end

                S_RECEIVE_PULSE: begin                          //State4 : Pedge???? usec? count?? Nedge? ???? count??
                    led_bar[3] = 1;
                    if(dht_pedge) begin                         //Echo??? Pedge????
                        count_usec_e = 1;                       //usec count start
                    end
                    else if(dht_nedge) begin                    //Echo??? Nedge????
                        count_usec_e = 0;                       //usec count stop
                        Trig_data = (count_usec / 6'b11_1010);  //usec_count? 58? ??? 1cm??? ??
                                                                //usec_count? count_usec_e = 0?? ??????
                                                                //?? negedge clk?? count_usec? ????? ??? ??? ??
                        next_state = S_START;                   //?? Nedge?? State? ??
                    end
                end
                default : next_state = S_START;
            endcase
        end

    end

endmodule
