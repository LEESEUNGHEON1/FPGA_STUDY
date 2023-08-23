`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/23 14:37:48
// Design Name: 
// Module Name: clock_library
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

/*==================================================================================================*/
//system clock 125MHz
module clock_usec(          //1us clock
    input clk, reset_p,
    output clk_usec
    );
    
    reg [6:0] cnt_8nsec;
    wire cp_usec;
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) cnt_8nsec = 0;                                  
        else if(cnt_8nsec >= 124) cnt_8nsec = 0;
        else cnt_8nsec = cnt_8nsec + 1;
    end
    
    assign cp_usec = cnt_8nsec < 63 ? 0 : 1;                //0~63 : 0 , 64~124 : 1, 0~124 : 1us
    
    edge_detector_n ed0 (.clk(clk), .cp_in(cp_usec), .reset_p(reset_p), .n_edge(clk_usec));
    
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
//system clock 125MHz
module clock_msec(          //1ms clock
    input clk, clk_usec, reset_p,
    output clk_msec
    );
    
    reg [8:0] cnt_usec;
    reg cp_msec;
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) cnt_usec = 0;
        else if(clk_usec)begin                                  
            if(cnt_usec >= 499)begin
                cnt_usec = 0;
                cp_msec = ~cp_msec;     
            end
            else cnt_usec = cnt_usec + 1;
        end
    end
    
    edge_detector_n ed0 (.clk(clk), .cp_in(cp_msec), .reset_p(reset_p), .n_edge(clk_msec));
    
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
//system clock 125MHz
module clock_sec(          //1s clock
    input clk, clk_msec, reset_p,
    output clk_sec
    );
    
    reg [8:0] cnt_msec;
    reg cp_sec;
    
    always @(posedge clk_msec or posedge reset_p)begin
        if(reset_p) cnt_msec = 0;         
        else if(clk_msec)begin                         
            if(cnt_msec >= 499)begin
                cnt_msec = 0;
                cp_sec = ~cp_sec;     
            end
            else cnt_msec = cnt_msec + 1;
        end
    end
    
    edge_detector_n ed0 (.clk(clk), .cp_in(cp_sec), .reset_p(reset_p), .n_edge(clk_sec));
    
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
//system clock 125MHz
module clock_min(          //1s clock
    input clk, clk_sec, reset_p,
    output clk_min
    );
    
    reg [8:0] cnt_sec;
    reg cp_min;
    
    always @(posedge clk_sec or posedge reset_p)begin
        if(reset_p) cnt_sec = 0;    
        else if(clk_sec)begin                              
            if(cnt_sec >= 29)begin
                cnt_sec = 0;
                cp_min = ~cp_min;     
            end
            else cnt_sec = cnt_sec + 1;
        end
    end
    
    edge_detector_n ed0 (.clk(clk), .cp_in(cp_min), .reset_p(reset_p), .n_edge(clk_min));
    
endmodule
/*==================================================================================================*/

/*==================================================================================================*/
module counter_dec_60(
    input clk, reset_p,
    input clk_time,
    output reg [3:0]dec1, dec10
    );
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            dec1 = 0;
            dec10 = 0;
        end
        else if(clk_time)begin      //clk_time에 sec가 들어오면 sec마다 실행
            if(dec1 >= 9)begin
                dec1 = 0;
                if(dec10 >= 5) dec10 = 0;
                else dec10 = dec10 + 1;
            end
            else dec1 = dec1 + 1;
        end
    end
endmodule


/*==================================================================================================*/






















