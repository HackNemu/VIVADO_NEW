module CNT60(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT6);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [2:0]CNT6;
output OUT_CARRY; 

reg [3:0]CNT10;
reg [2:0]CNT6;
reg OUT_CARRY, CARRY;

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
                else
                    CNT10 <= CNT10 + 4'h1;  //ŒJ‚èã‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
        else                                //Œ¸ŽZ
            begin
                if(CNT10 == 4'h0)           //ŒJ‚è‰º‚ª‚èŽž‚Ìˆ—       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //ŒJ‚è‰º‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
end
//CNT10==9 CARRY@
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                          //‰ÁŽZ
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1)//CARRY10 ‚ª—§‚Â@=@ˆêŒ…–Ú‚ª9
                CARRY <= 1'b1;                   //Œ…ã‚ª‚è‚ ‚è
            else                                 //ˆêŒ…–Ú‚ª9ˆÈŠO
                CARRY <= 1'b0;                   //Œ…ã‚ª‚è‚È‚µ
        else                                     //Œ¸ŽZ
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)//ˆêŒ…–Ú‚ª0     
                CARRY <= 1'b1;                   //Œ…ã‚ª‚è‚ ‚è 
             else                                //ˆêŒ…–Ú‚ª0ˆÈŠO
                CARRY <= 1'b0;                   //Œ…ã‚ª‚è‚È‚µ 
end                                             


//6 COUNT
always@(posedge CLK or posedge RESET)       //CLK‚ª“ü‚é or RESET‚ª‰Ÿ‚³‚ê‚é
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT6 <= 3'b000;                  //COUNTER = 0 ‰Šú‰»
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1)     //ENABLE‚Æ‚Í1•bƒ^ƒCƒ}[‚Å1“x‚¾‚¯“ü‚é@ƒpƒ‹ƒX && @‰ºˆÊ‚©‚ç‚ÌŒJ‚èã‚ª‚è(‰ºˆÊ‚©‚çCARRY‚ª—ˆ‚½‚Æ‚«‚¾‚¯“®‚«‚½‚¢‚©‚ç•K—vH)
        if(DEC == 1'b0)                     //‰ÁŽZ
            begin
                if(CNT6 == 3'b101)          //ŒJ‚èã‚ª‚Á‚½Žž‚Ìˆ—
                   CNT6 <= 3'b000;          //0‚É–ß‚·
                else
                    CNT6 <= CNT6 + 3'b001;  //ŒJ‚èã‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
        else                                //Œ¸ŽZ
            begin
                if(CNT6 == 3'b000)          //ŒJ‚è‰º‚ª‚èŽž‚Ìˆ—       
                   CNT6 <= 3'b101;          
                else
                    CNT6 <= CNT6 - 3'b001;  //ŒJ‚è‰º‚ª‚èŽžˆÈŠO‚Ìˆ—
            end
end
//CNT6==5 CARRY@ì¬
always@(CNT6 or DEC or CARRY)
begin
        if(DEC == 1'b0)                         //‰ÁŽZ       
            if(CNT6 == 4'h5 && CARRY == 1'b1)   //“ñŒ…–Ú‚ª5
                OUT_CARRY <= 1'b1;              //Œ…ã‚ª‚è‚ ‚è   
            else                                //“ñŒ…–Ú‚ª5ˆÈŠO  
                OUT_CARRY <= 1'b0;              //Œ…ã‚ª‚è‚È‚µ   
        else                                    //Œ¸ŽZ       
            if(CNT6 == 4'h0 && CARRY == 1'b1)   //“ñŒ…–Ú‚ª0    
                OUT_CARRY <= 1'b1;              //Œ…ã‚ª‚è‚ ‚è   
             else                               //“ñŒ…–Ú‚ª0ˆÈŠO  
                OUT_CARRY <= 1'b0;              //Œ…ã‚ª‚è‚È‚µ   
end
endmodule