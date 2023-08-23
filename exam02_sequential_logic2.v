`timescale 1ns / 1ps


////天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
//module RS_latch(
//            input R, S,
//            output Q, Qbar   
//        );
        
//        nor (Q, R, Qbar);               //檣蝶欐蝶貲檜 橈擠
//        nor (Qbar, S, Q);
        
//endmodule    
////天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//

////天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
//module RS_latch_en(
//        input R, S ,en,
//        output Q, Qbar
//);
//        wire w_r, w_s;
//        and (w_r, R, en);
//        and (w_s, S, en);
        
//        nor(Q, w_r, Qbar);
//        nor(Qbar, w_s, Q);
//endmodule
////天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//    

//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module D_flip_flop_n(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop 翕濛薄 賅筐葭
        always @(negedge clk or posedge reset_p)begin          //sensativity response縑 negedge clk : clk曖 negative edge 橾陽虜 always 1廓 褒ч
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //偽擎 殮溘縑 渠п憮紫 棻艇 轎溘檜 氈晦 陽僥縑
        end

//        always @(clk)begin
//                if(clk) q = d;                  //clk = 1(high Level)橾 陽 
//                else q = q;                     //clk = 0(low Level)橾 陽
//        end

//            always @(clk)begin                      //褻м喱葬�虞帤� 楚纂陛 虜菟橫韓 熱 氈擠 -> 顫檜墅 縑楝陛 儅望 熱 氈棻
//                if(clk) q = d;
//                else q = 0;            //and啪檜お陛 虜菟橫颶 檜 還檜 橈棻賊 楚纂陛 虜菟橫螳憮 顫檜墅 縑楝陛 儅望 熱 氈擠

//            always @(clk)begin
//                    q = 0;                  //檜溢啪 蟾晦縑 雖薑п 輿賊 惘雛擠 
//                    if(clk) q = d;
//            end
endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module D_flip_flop_p(
        input d,
        input clk,
        input reset_p,
        output reg q
);
            //        D flip flop 翕濛薄 賅筐葭
        always @(posedge clk or posedge reset_p)begin          //sensativity response縑 negedge clk : clk曖 negative edge 橾陽虜 always 1廓 褒ч
                if(reset_p) q = 0;
                else q = d;
                q = d;                                          //偽擎 殮溘縑 渠п憮紫 棻艇 轎溘檜 氈晦 陽僥縑
        end

endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module T_flip_flop_n(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //轎溘 q蒂 嫡擊 wire
//            assign d = ~q;
            //reg temp = 0;                                       //滲熱 摹樹й 陽 蟾晦 摹樹擊 ж溥賊 reg虜 脾 //wire朝 0戲煎 ж賊 啗樓 蕾雖鼻鷓歜
                                                                           //爾萄縑憮朝 蟾晦高 撲薑擊 寰п紫 瞪錳擊 鼯陽 葬撢戲煎 0戲煎 蟾晦�飛� 霞чл
                                                                           
            always @(negedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//

//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module T_flip_flop_p(
            input clk,
            input reset_p,
            output reg q = 0
);
//            wire d;         //轎溘 q蒂 嫡擊 wire
//            assign d = ~q;
            //reg temp = 0;                                       //滲熱 摹樹й 陽 蟾晦 摹樹擊 ж溥賊 reg虜 脾 //wire朝 0戲煎 ж賊 啗樓 蕾雖鼻鷓歜
                                                                           //爾萄縑憮朝 蟾晦高 撲薑擊 寰п紫 瞪錳擊 鼯陽 葬撢戲煎 0戲煎 蟾晦�飛� 霞чл
                                                                           
            always @(posedge clk)begin          
                   if(reset_p) q = 0;
                   else q = ~q;
            end

endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module up_counter_asyc(         //綠翕晦衝
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_n T0 (.clk(clk), .reset_p(reset_p), .q(count[0]));
        T_flip_flop_n T1 (.clk(count[0]), .reset_p(reset_p), .q(count[1]));
        T_flip_flop_n T2 (.clk(count[1]), .reset_p(reset_p), .q(count[2]));
        T_flip_flop_n T3 (.clk(count[2]), .reset_p(reset_p), .q(count[3]));
        
endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module down_counter_asyc(           //綠翕晦衝
            input clk,
            input reset_p,
            output [3:0] count
);

        T_flip_flop_p H1 (.clk(clk), .reset_p(reset_p),. q(count[0]));
        T_flip_flop_p H2 (.clk(count[0]), .reset_p(reset_p),. q(count[1]));
        T_flip_flop_p H3 (.clk(count[1]), .reset_p(reset_p),. q(count[2]));
        T_flip_flop_p H4 (.clk(count[2]), .reset_p(reset_p),. q(count[3]));

endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module up_counter_p(                      //翕晦衝
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count + 1;
                end
endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//

//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module down_counter_p(                      //翕晦衝
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else count = count - 1;
                end
endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//



//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module up_down_counter(
            input clk, reset_p,
            input up_down,                              //0檜賊 down 1檜賊 up 蘋遴攪煎 翕濛ж啪莖
            output reg [3:0] count
);

            always @(posedge clk or posedge reset_p) begin
                    if(reset_p) count = 0;
                    else if(up_down) count = count + 1;
                    else count = count - 1;
            end



endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module counter_fnd_top(     //updown count曖 轎溘擊 fnd煎
        input clk, reset_p, up_down,
        output [7:0] seg_7,
        output [3:0] com
);

        wire [3:0] count;
        
        assign com = 4'b0011;
        
        reg [25:0] clk_div;
        
        always @(posedge clk)clk_div = clk_div + 1;             //衛嘆溯檜暮й陽朝 ns欽嬪煎 だ⑽虜 �挫恉牉� 腎朝等
                                                                                                    //褒薯 爾萄縑憮 獐陽朝 碟輿綠蒂 撲薑п邀
        
        up_down_counter counter_fnd (.clk(clk_div[25]), .reset_p(reset_p), .up_down(up_down), .count(count));
        
        decoder_7seg(.hex_value(count), .seg_7(seg_7));


endmodule
//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//


//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//
module up_counter_p_BCD(                      //BCD 機蘋遴攪  0,1,2,3,4,5,6,7,8,9,0,1,2,3,...
                input clk,
                input reset_p,
                output reg [3:0] count
);

                always @(posedge clk or posedge reset_p) begin
                        if(reset_p) count = 0;
                        else begin
                            if (count >= 9) count = 0;
                            else count = count + 1;
                         end
                end
endmodule

//天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天天//














