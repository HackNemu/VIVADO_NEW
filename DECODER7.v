module DECODER7(COUNT,LED);
input [3:0]COUNT;
output[7:0]LED;
reg[7:0]LED;

always@(COUNT)
begin
    case(COUNT) //ABCDEFG_Dp
        4'b0000:LED<=8'b0000001_1;  //0
        4'b0001:LED<=8'b1001111_1;  //1
        4'b0010:LED<=8'b0010010_1;  //2
        4'b0011:LED<=8'b0000110_1;  //3
        4'b0100:LED<=8'b1001100_1;  //4
        4'b0101:LED<=8'b0100100_1;  //5
        4'b0110:LED<=8'b0100000_1;  //6
        4'b0111:LED<=8'b0001101_1;  //7
        4'b1000:LED<=8'b0000000_1;  //8
        4'b1001:LED<=8'b0000100_1;  //9
        4'b1111:LED<=8'b1111111_1;  //F
        default:LED<=8'b0110000_1;  //Error
    endcase
end
endmodule