module ENABLE_GEN(CLK, RESET, ENABLE, ENABLE_khz);
input CLK, RESET;
output ENABLE,ENABLE_khz;
reg [26:0] tmp_count;
wire ENABLE, ENABLE_khz;    //1bit信号なので省略してもよいが　あえて書くべき

//parameter SEC1_MAX = 125000000;  //125Mhz
parameter SEC1_MAX = 1;  //125Mhz
//parameter EN_Khz_MSB_BIT = 15;  //khzを作りたいときの　最上位ビット幅
//parameter EN_Khz_VAL = 16'hffff;// 65536
parameter EN_Khz_MSB_BIT = 2;  //khzを作りたいときの　最上位ビット幅
parameter EN_Khz_VAL = 1;// 65536

//１秒カウント用のカウンター
always@(posedge CLK or posedge RESET)
begin
        if(RESET == 1'b1)
                tmp_count <= 27'h0000000;
        else if (ENABLE == 1'b1)                //ENABLE立ってたら カウント0に戻す
                tmp_count <= 27'h0000000;
        else
               // tmp_count <= tmp_count + 27'h1; //カウント部分
               tmp_count <= tmp_count + 1'b1; //カウント部分
end                                             //なぜ27'h1なのか bit幅を合わせているだけ？　1増やすだけなら　1'b1ではだめ？

//外部へクロックを出力する処理
assign ENABLE = (tmp_count == (SEC1_MAX -1))? 1'b1 : 1'b0; //三項演算子  ENABLEは125MHZ - 1　で立つ
//125khzはカウント125000だが　ダイナミック点灯(つく：けす)は２処理で１つと考えれば　65536*2で大体125khzになる
assign ENABLE_khz = (tmp_count[EN_Khz_MSB_BIT:0] == EN_Khz_VAL)? 1'b1 : 1'b0;   //(16bitがFFFF)で立つ=65536カウント　

endmodule