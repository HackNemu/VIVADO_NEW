module CNT24(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT3);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [1:0]CNT3;
output OUT_CARRY;

reg [3:0]CNT10;
reg [1:0]CNT3;
reg OUT_CARRY,CARRY;

//10 COUNT
always@(posedge CLK or posedge RESET)       //CLK‚ª“ü‚é or RESET‚ª‰Ÿ‚³‚ê‚é
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT10 <= 4'h0;                  //COUNTER = 0 ‰Šú‰»
        end
    else if(ENABLE == 1'b1 && IN_CARRY == 1'b1) //ENABLE‚Æ‚Í1•bƒ^ƒCƒ}[‚Å1“x‚¾‚¯“ü‚éƒpƒ‹ƒX && @‰ºˆÊ‚©‚ç‚ÌŒJ‚èã‚ª‚è(‰ºˆÊ‚©‚çCARRY‚ª—ˆ‚½‚Æ‚«‚¾‚¯“®‚«‚½‚¢‚©‚ç•K—vH)  
        if(DEC == 1'b0)                     //‰ÁŽZ
            begin
                if(CNT10 == 4'h9)
                    CNT10 <= 4'h0;          //ŒJ‚èã‚ª‚Á‚½Žž‚Ìˆ—
                else if(CNT10 == 4'h3 && CNT3 == 2'b10)    //3ŽžŠÔ‚ÌŽž‚©‚Â20ŽžŠÔ
                    CNT10 <= 4'h0; 
                else
                    CNT10 <= CNT10 + 4'h1;  //ŒJ‚èã‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
        else                                //Œ¸ŽZ
            begin
                if(CNT10 == 4'h0 && CNT3 == 2'b00)
                   CNT10 <= 4'h3; 
                else if(CNT10 == 4'h0)           //ŒJ‚è‰º‚ª‚èŽž‚Ìˆ—       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //ŒJ‚è‰º‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
end


//3 COUNT
always@(posedge CLK or posedge RESET)       //CLK‚ª“ü‚é or RESET‚ª‰Ÿ‚³‚ê‚é
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT3 <= 2'b00;                  //COUNTER = 0 ‰Šú‰»
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1) //ENABLE‚Æ‚Í1•bƒ^ƒCƒ}[‚Å1“x‚¾‚¯“ü‚éƒpƒ‹ƒX && ’†ŠÔƒLƒƒƒŠ[  
        if(DEC == 1'b0)                     //‰ÁŽZ
            begin
                if(CNT3 == 2'b10)
                    CNT3 <= 2'b00;          //ŒJ‚èã‚ª‚Á‚½Žž‚Ìˆ—
                else
                    CNT3 <= CNT3 + 2'b01;  //ŒJ‚èã‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
        else                                //Œ¸ŽZ
            begin
                if(CNT3 == 2'b00)           //ŒJ‚è‰º‚ª‚èŽž‚Ìˆ—       
                   CNT3 <= 2'b10;
                else
                    CNT3 <= CNT3 - 2'b01;  //ŒJ‚è‰º‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
end

//CNT10 CARRY@ì¬
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                         //‰ÁŽZ
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1) //CARRY10 ‚ª—§‚Â@=@ˆêŒ…–Ú‚ª9@&& ‰ºˆÊ‚©‚ç‚ÌŒJ‚èã‚ª‚è‚ª1
                CARRY <= 1'b1;                //Œ…ã‚ª‚è‚ ‚è
            else if(CNT10 == 4'h3 && CNT3 == 2'b10)//3ŽžŠÔ‚ÌŽž‚©‚Â20ŽžŠÔ
                CARRY <= 1'b1;
            else                              //ˆêŒ…–Ú‚ª9ˆÈŠO
                CARRY <= 1'b0;                //Œ…ã‚ª‚è‚È‚µ
        else                                  //Œ¸ŽZ
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)                 //ˆêŒ…–Ú‚ª0     
                CARRY <= 1'b1;                //Œ…ã‚ª‚è‚ ‚è
            else if(CNT10 == 4'h0 && CNT3 == 2'b00)//3ŽžŠÔ‚ÌŽž‚©‚Â20ŽžŠÔ@‰º‚ª‚é‚Æ‚«‚Í•K—v‚È‚µ
                CARRY <= 1'b1; 
            else                             //ˆêŒ…–Ú‚ª0ˆÈŠO
                CARRY <= 1'b0;                //Œ…ã‚ª‚è‚È‚µ 
end                                             

//CNT3 CARRY@ì¬
always@(CNT3 or DEC or CARRY)
begin
        if(DEC == 1'b0)                      //‰ÁŽZ       
            if(CNT3 == 2'b10 && CARRY == 1'b1)//“ñŒ…–Ú‚ª2 ‚©‚Â@ˆêŒ…–Ú‚ªŒ…ã‚ª‚è
                OUT_CARRY <= 1'b1;              //Œ…ã‚ª‚è‚ ‚è   
            else                             //“ñŒ…–Ú‚ª5ˆÈŠO  
                OUT_CARRY <= 1'b0;              //Œ…ã‚ª‚è‚È‚µ   
        else                                 //Œ¸ŽZ       
            if(CNT3 == 2'h00 && CARRY == 1'b1)                //“ñŒ…–Ú‚ª0    
                OUT_CARRY <= 1'b1;              //Œ…ã‚ª‚è‚ ‚è   
             else                            //“ñŒ…–Ú‚ª0ˆÈŠO  
                OUT_CARRY <= 1'b0;              //Œ…ã‚ª‚è‚È‚µ   
end
endmodule