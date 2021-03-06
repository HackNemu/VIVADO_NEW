module CNT24(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT3);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [1:0]CNT3;
output OUT_CARRY;

reg [3:0]CNT10;
reg [1:0]CNT3;
reg OUT_CARRY,CARRY;

//10 COUNT
always@(posedge CLK or posedge RESET)       //CLKが入る or RESETが押される
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT10 <= 4'h0;                  //COUNTER = 0 初期化
        end
    else if(ENABLE == 1'b1 && IN_CARRY == 1'b1) //ENABLEとは1秒タイマーで1度だけ入るパルス && 　下位からの繰り上がり(下位からCARRYが来たときだけ動きたいから必要？)  
        if(DEC == 1'b0)                     //加算
            begin
                if(CNT10 == 4'h9)
                    CNT10 <= 4'h0;          //繰り上がった時の処理
                else if(CNT10 == 4'h3 && CNT3 == 2'b10)    //3時間の時かつ20時間
                    CNT10 <= 4'h0; 
                else
                    CNT10 <= CNT10 + 4'h1;  //繰り上がり時以外の処理
            end
        else                                //減算
            begin
                if(CNT10 == 4'h0 && CNT3 == 2'b00)
                   CNT10 <= 4'h3; 
                else if(CNT10 == 4'h0)           //繰り下がり時の処理       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //繰り下がり時以外の処理
            end
end


//3 COUNT
always@(posedge CLK or posedge RESET)       //CLKが入る or RESETが押される
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT3 <= 2'b00;                  //COUNTER = 0 初期化
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1) //ENABLEとは1秒タイマーで1度だけ入るパルス && 中間キャリー  
        if(DEC == 1'b0)                     //加算
            begin
                if(CNT3 == 2'b10)
                    CNT3 <= 2'b00;          //繰り上がった時の処理
                else
                    CNT3 <= CNT3 + 2'b01;  //繰り上がり時以外の処理
            end
        else                                //減算
            begin
                if(CNT3 == 2'b00)           //繰り下がり時の処理       
                   CNT3 <= 2'b10;
                else
                    CNT3 <= CNT3 - 2'b01;  //繰り下がり時以外の処理
            end
end

//CNT10 CARRY　作成
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                         //加算
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1) //CARRY10 が立つ　=　一桁目が9　&& 下位からの繰り上がりが1
                CARRY <= 1'b1;                //桁上がりあり
            else if(CNT10 == 4'h3 && CNT3 == 2'b10)//3時間の時かつ20時間
                CARRY <= 1'b1;
            else                              //一桁目が9以外
                CARRY <= 1'b0;                //桁上がりなし
        else                                  //減算
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)                 //一桁目が0     
                CARRY <= 1'b1;                //桁上がりあり
            else if(CNT10 == 4'h0 && CNT3 == 2'b00)//3時間の時かつ20時間　下がるときは必要なし
                CARRY <= 1'b1; 
            else                             //一桁目が0以外
                CARRY <= 1'b0;                //桁上がりなし 
end                                             

//CNT3 CARRY　作成
always@(CNT3 or DEC or CARRY)
begin
        if(DEC == 1'b0)                      //加算       
            if(CNT3 == 2'b10 && CARRY == 1'b1)//二桁目が2 かつ　一桁目が桁上がり
                OUT_CARRY <= 1'b1;              //桁上がりあり   
            else                             //二桁目が5以外  
                OUT_CARRY <= 1'b0;              //桁上がりなし   
        else                                 //減算       
            if(CNT3 == 2'h00 && CARRY == 1'b1)                //二桁目が0    
                OUT_CARRY <= 1'b1;              //桁上がりあり   
             else                            //二桁目が0以外  
                OUT_CARRY <= 1'b0;              //桁上がりなし   
end
endmodule