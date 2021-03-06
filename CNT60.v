module CNT60(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT6);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [2:0]CNT6;
output OUT_CARRY; 

reg [3:0]CNT10;
reg [2:0]CNT6;
reg OUT_CARRY, CARRY;

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
                else
                    CNT10 <= CNT10 + 4'h1;  //繰り上がり時以外の処理
            end
        else                                //減算
            begin
                if(CNT10 == 4'h0)           //繰り下がり時の処理       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //繰り下がり時以外の処理
            end
end
//CNT10==9 CARRY　
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                          //加算
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1)//CARRY10 が立つ　=　一桁目が9
                CARRY <= 1'b1;                   //桁上がりあり
            else                                 //一桁目が9以外
                CARRY <= 1'b0;                   //桁上がりなし
        else                                     //減算
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)//一桁目が0     
                CARRY <= 1'b1;                   //桁上がりあり 
             else                                //一桁目が0以外
                CARRY <= 1'b0;                   //桁上がりなし 
end                                             


//6 COUNT
always@(posedge CLK or posedge RESET)       //CLKが入る or RESETが押される
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT6 <= 3'b000;                  //COUNTER = 0 初期化
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1)     //ENABLEとは1秒タイマーで1度だけ入る　パルス && 　下位からの繰り上がり(下位からCARRYが来たときだけ動きたいから必要？)
        if(DEC == 1'b0)                     //加算
            begin
                if(CNT6 == 3'b101)          //繰り上がった時の処理
                   CNT6 <= 3'b000;          //0に戻す
                else
                    CNT6 <= CNT6 + 3'b001;  //繰り上がり時以外の処理
            end
        else                                //減算
            begin
                if(CNT6 == 3'b000)          //繰り下がり時の処理       
                   CNT6 <= 3'b101;          
                else
                    CNT6 <= CNT6 - 3'b001;  //繰り下がり時以外の処理
            end
end
//CNT6==5 CARRY　作成
always@(CNT6 or DEC or CARRY)
begin
        if(DEC == 1'b0)                         //加算       
            if(CNT6 == 4'h5 && CARRY == 1'b1)   //二桁目が5
                OUT_CARRY <= 1'b1;              //桁上がりあり   
            else                                //二桁目が5以外  
                OUT_CARRY <= 1'b0;              //桁上がりなし   
        else                                    //減算       
            if(CNT6 == 4'h0 && CARRY == 1'b1)   //二桁目が0    
                OUT_CARRY <= 1'b1;              //桁上がりあり   
             else                               //二桁目が0以外  
                OUT_CARRY <= 1'b0;              //桁上がりなし   
end
endmodule