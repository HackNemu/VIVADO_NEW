  module TEST_CNT60_ALL;
  reg clk, reset, dec,sw;
  wire [7:0] led;
  wire [3:0] sa;

  parameter CYCLE = 100;

  CLOCK_24 i10(.CLK(clk), .RESET(reset), .DEC(dec), .LED(led), .SA(sa), .SW(sw));

   always #(CYCLE/2)
       clk = ~clk;

   initial
   begin
      reset = 1'b1; clk = 1'b0; dec = 1'b1; sw=1'b0;
      #CYCLE reset = 1'b0;
     // #(30*CYCLE*10) sw = 1'b1; //swÇÃêÿÇËë÷Ç¶
      #(10*CYCLE*50) dec = 1'b0;//â¡éZå∏éZÇÃêÿÇËë÷Ç¶
      #(10*CYCLE*100) $finish;
   end

   initial
      //$monitor($time,,"clk=%b reset=%b dec=%b count60=%d%d", clk, reset, dec, i1.i1.CNT6_SEC , i1.i1.CNT10_SEC);
      $monitor($time,,"clk=%b reset=%b dec=%b count24=%d%d count60MIN=%d%d count60SEC=%d%d MIN_CARRY=%b HOUR_CARRY=%b",
       clk, reset, dec, i10.i3.CNT3, i10.i3.CNT10, i10.i2.CNT6, i10.i2.CNT10,    i10.i1.CNT6, i10.i1.CNT10, i10.i2.IN_CARRY,i10.i3.IN_CARRY);
      //$monitor($time,,"clk=%b reset=%b dec=%b count24=%d%d count60MIN=%d%d count60SEC=%d%d MIN_CARRY=%btenntousaki = hh[%d][%d]:mm[%d][%d]:ss[%d][%d]",
       //clk, reset, dec, i10.i3.CNT3, i10.i3.CNT10, i10.i2.CNT6, i10.i2.CNT10,    i10.i1.CNT6, i10.i1.CNT10, i10.i2.IN_CARRY,);
   endmodule
 