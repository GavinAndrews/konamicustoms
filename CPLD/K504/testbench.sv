`timescale 1ns/100ps
module Konami504_tb1;

reg s01_i, 
    s05_i, s06_i, s07_i, s08_i, s09_i, 
    s10_i, s11_i, s12_i, s13_i,
    s27_i;
  
wire s02_o, s03_o, s04_o, 
     s15_o, s16_o, s17_o, s18_o, s19_o, s20_o, s21_o, 
     s22_o, s23_o, s24_o, s25_o, s26_o;

reg clk;

  konami_504 custom(.p01_i(s01_i), .p02_o(s02_o), .p03_o(s03_o), .p04_o(s04_o), 
                    .p05_i(s05_i), .p06_i(s06_i), .p07_i(s07_i), 
                    .p08_i(s08_i), .p09_i(s09_i), .p10_i(s10_i), .p11_i(s11_i), 
                    .p12_i(s12_i), .p13_i(s13_i), /* p14_vss, */
                    .p15_o(s15_o), .p16_o(s16_o), .p17_o(s17_o), .p18_o(s18_o), 
                    .p19_o(s19_o), .p20_o(s20_o), .p21_o(s21_o), 
                    .p22_o(s22_o), .p23_o(s23_o), .p24_o(s24_o), 
                    .p25_o(s25_o), .p26_o(s26_o), .p27_i(s27_i) /* p28_vcc */);

  
  
  
reg[15:0] i = 16'bX;
  
assign s01_i = clk;
    
initial begin
  
  $dumpfile("dump.vcd");
  $dumpvars(1);

#0;

clk = 1'b0;
s27_i = 1'b0; // nRESET Active
  
s06_i =1'b0;
s10_i =1'b0;
s11_i =1'b0;
s05_i =1'b0;
  
#10;
  
s27_i = 1'b1; // nRESET Inactive
s05_i = 1'b1;
  
#10;

  for (i=0; i<256; i=i+1) begin
    clk = i[0];  // CLK
    s09_i = i[0]; // nVBLANK
    s10_i = i[1];  // 1H
    s11_i = i[2];  // 2H
    s12_i = i[3];  // 4H
    s13_i = i[4];  // 8H
    s08_i = i[5];  // n256H

   #10;
end   

  
$stop;
end

endmodule
