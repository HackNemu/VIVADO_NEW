module DCOUNT(CLK, ENABLE, L1, L2, L3, L4, L5, L6, SA, L, SW);
input CLK, ENABLE, SW;
input [3:0] L1, L2, L3, L4, L5, L6;
output[3:0] SA,L;

parameter MAX_COUNT = 3'b111;
reg [2:0] sa_count_tmp = 3'b000;
reg [3:0] sa_count;
reg [3:0] L_tmp;

assign SA = ~sa_count;
assign L = L_tmp;

always@(posedge CLK)
begin
    if(ENABLE == 1'b1)
        if(sa_count_tmp == MAX_COUNT)
           sa_count_tmp <= 3'b000;
        else
           sa_count_tmp <= sa_count_tmp + 1'b1;
end

always@(posedge CLK)
begin
    if(sa_count_tmp[0] == 1'b0)     //Å‰ºˆÊbit‚ª0‚¾‚Á‚½‚ç = LED‚ªÁ‚¦‚é
       begin
            sa_count <= 4'b1111; L_tmp <= L_tmp;
       end
    else                            //Å‰ºˆÊbit‚ª1‚¾‚Á‚½‚ç = LED‚ª“_“”
        if(SW == 1'b0)
            begin
                case (sa_count_tmp[2:1])
                       3'b00:begin
                                sa_count <= 4'b1110; L_tmp <= L1;
                             end
                       3'b01:begin
                                sa_count <= 4'b1101; L_tmp <= L2;
                             end
                       3'b10:begin
                                sa_count <= 4'b1011; L_tmp <= L3;
                             end
                       3'b11:begin
                                sa_count <= 4'b0111; L_tmp <= L4;
                             end
                       default:begin
                                sa_count <= 4'bxxxx;L_tmp <= 4'bxxxx;
                             end
               endcase
           end
       else
           begin
                case (sa_count_tmp[2:1])
                       3'b00:begin
                                sa_count <= 4'b1110; L_tmp <= L3;
                             end
                       3'b01:begin
                                sa_count <= 4'b1101; L_tmp <= L4;
                             end
                       3'b10:begin
                                sa_count <= 4'b1011; L_tmp <= L5;
                             end
                       3'b11:begin
                                sa_count <= 4'b0111; L_tmp <= L6;
                             end
                       default:begin
                                sa_count <= 4'bxxxx;L_tmp <= 4'bxxxx;
                             end
               endcase
           end
           
end
endmodule
                                                  