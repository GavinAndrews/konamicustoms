module konami_504 (p01_i, p02_o, p03_o, p04_o, p05_i, p06_i, p07_i, 
                   p08_i, p09_i, p10_i, p11_i, p12_i, p13_i, /* p14_vss, */
				   p15_o, p16_o, p17_o, p18_o, p19_o, p20_o, p21_o, 
                   p22_o, p23_o, p24_o, p25_o, p26_o, p27_i /* p28_vcc */);
input p01_i;
output p02_o;
output p03_o;
output p04_o;
input p05_i;
input p06_i;
input p07_i;
input p08_i;
input p09_i;
input p10_i;
input p11_i;
input p12_i;
input p13_i;
//power p14_vss;
output p15_o;
output p16_o;
output p17_o;
output p18_o;
output p19_o;
output p20_o;
output p21_o;
output p22_o;
output p23_o;
output p24_o;
output p25_o;
output p26_o;
input p27_i;
//power p28_vcc;
   
  wire jkflop1q; 
  wire jkflop1nq; 
  jk_ff jkflop1(.nReset(p27_i), .j(jkflop2nq), .k(1), .clk(p01_i), .q(jkflop1q), .nq(jkflop1nq));
  
  assign p26_o=jkflop1nq;
  
  wire jkflop2q;
  wire jkflop2nq;
  jk_ff jkflop2(.nReset(p27_i), .j(jkflop1q), .k(1), .clk(p01_i), .q(jkflop2q), .nq(jkflop2nq));
  
  assign p02_o=jkflop2q;
  
  wire dflop1q;
  wire dflop1nq;
  DFlop dflop1(.d(dflop1nq), .clk(jkflop2nq), .nReset(p27_i), .q(dflop1q), .nq(dflop1nq));
  


  wire dflop2q;
  wire dflop2nq;
  DFlop dflop2(.d(dflop2nq), .clk(dflop1nq), .nReset(p27_i), .q(dflop2q), .nq(dflop2nq));
  
  assign p03_o = dflop2nq;

  wire dflop3q;
  wire dflop3nq;
  DFlop dflop3(.d(dflop3nq), .clk(dflop1q), .nReset(p27_i), .q(dflop3q), .nq(dflop3nq));

  assign p25_o = dflop3nq;
  
  wire watchdog_overflow;
  
  Counter counter1(.reset(~p05_i), .clk(~p09_i), .triggered(watchdog_overflow));

  wire dflop4q;
  DFlop dflop4(.d(watchdog_overflow), .clk(dflop2nq), .nReset(p27_i), .q(dflop4q));
  
  // Watchdog Reset
  assign p04_o=dflop4q;
  
  // GUESS
  assign p15_o = ~(p10_i & ~p11_i & ~p12_i);
  
  assign p16_o = ~p10_i & ~p11_i;
  assign p20_o = ~(p10_i & p11_i);
  assign p21_o = ~(p10_i & p11_i & p12_i);
  
  
  alias _n256H = p08_i;
  alias _nVBLANK = p09_i;
  alias _4H = p12_i;
  alias _8H = p13_i;
  
  wire dflop5q;
  wire dflop5nq;
  DFlop dflop5(.d(~_n256H), .clk(_8H), .nReset(p27_i), .q(dflop5q), .nq(dflop5nq));
  
  wire dflop6q;
  wire dflop6nq;
  DFlop dflop6(.d(dflop5q), .clk(_4H), .nReset(p27_i), .q(dflop6q), .nq(dflop6nq));
  
  assign p17_o = ~(dflop6nq & _nVBLANK);
  
  assign p18_o = ~(~p10_i & p11_i & p13_i);
  assign p19_o = p10_i & p11_i & ~p13_i;
  
  
  wire dflop7q;
  wire dflop7nq;
  DFlop dflop7(.d(p10_i), .clk(jkflop1q), .nReset(p27_i), .q(dflop7q), .nq(dflop7nq));
  
  wire p22 = p03_o | dflop7q | p06_i;
  assign p22_o = p22;  
  
 assign p23_o = p07_i | p10_i | p22; 

 assign p24_o = p07_i | dflop7q | ~p06_i;
  
  
  
  
  
endmodule


module jk_ff ( input nReset, input j, input k, input clk, output q, output nq);  
  
  reg state = 1'b0;
  
  assign q = state;
  assign nq = ~state;
  
  always @ (negedge clk or negedge nReset)  
     if (nReset == 1'b0)
        begin
          state <= 1'b0;
        end
     else
       begin
          case ({j,k})  
             2'b00 :  state <= state;  
             2'b01 :  state <= 1'b0;  
             2'b10 :  state <= 1'b1;  
             2'b11 :  state <= ~state;  
         endcase  
       end
endmodule 

module DFlop(d, clk, nReset, q, nq);
  
  input d, clk, nReset;
  output q, nq;
  
  reg state = 1'b0;
  
  assign q = state;
  assign nq = !state;
  
  always @(posedge clk or negedge nReset)
     begin
       if (nReset == 1'b0)
        begin
          state <= 1'b0;
        end
        else
        begin
          state <= d;
       end
    end
endmodule


module Counter(reset, clk, triggered);

input reset, clk;
output triggered;
  
reg[3:0] counter = 4'b0000;
  
assign triggered = counter[3];

always @(posedge clk or posedge reset)
   begin
       if (reset == 1'b1)
        begin
          counter <=  4'b0000;
        end
        else
        begin
          counter <= counter + 1;
        end
   end

endmodule