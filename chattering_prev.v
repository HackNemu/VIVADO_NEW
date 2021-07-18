module CHATTERING_PREV(CLK,RESET,SW_IN,SW_OUT);
 input CLK, RESET, SW_IN;
 output SW_OUT;
 reg BUF_SW1, BUF_SW2, BUF_OUT;

//クロックで待ち時間を発生させたい　周期10ms　くらいのクロック

// チャタリング除去
 always @(posedge CLK or posedge RESET)
 begin
 
    if(reset == 1'b0)   //初期化
       begin
        BUF_SW1 <= 1'b0;
        //BUF_SW2 <= 1'b0;
        BUF_OUT <= 1'b0;
       end
    else
       begin
　　　     if(BUF_SW1 == SW_IN)  //SWの入力2クロックで同じであれば
             begin
　　　　        BUF_OUT <= SW_IN;
　　          end
           else
             begin
                BUF_SW2 = BUF_SW1;  //1回目のSW_INをSW2に
                BUF_SW1 = SW_IN;    //2回目のSW_INをSW1に
　　         end
       end
 end
// 出力
assign SW_OUT = BUF_OUT;
endmodule 