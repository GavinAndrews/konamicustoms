//labels = ["#DA1", "#DA2", "#DA3", "#DA4", ">CLK", ">INnOUT", ">2H",
//          ">nLDOUT", ">n256HD", ">IO1", ">IO2", ">IO3", ">IO4", "VSS",
//          "CC4", "CC3", "CC2", "CC1", "ZERO", "P20", "P21",
//          "LDOUT", "#DB4", "#DB3", "#DB2", "#DB1", ">nRESET", "VCC"];


// Top-level module
module konami_502 (p01_io, p02_io, p03_io, p04_io, p05_i, p06_i, p07_i, 
                   p08_i, p09_i, p10_i, p11_i, p12_i, p13_i, /*p14_i,*/ 
                   p15_o, p16_o, p17_o, p18_o, p19_o, p20_o, p21_o, 
                   p22_o, p23_io, p24_io, p25_io, p26_io, p27_i /*, p28_i */);
inout  p01_io;
inout p02_io;
inout p03_io;
inout p04_io;
input p05_i;
input p06_i;
input p07_i;
input p08_i;
input p09_i;
input p10_i;
input p11_i;
input p12_i;
input p13_i;
//input p14_i;
output p15_o;
output p16_o;
output p17_o;
output p18_o;
output p19_o;
output p20_o;
output p21_o;
output p22_o;
inout p23_io;
inout p24_io;
inout p25_io;
inout p26_io;
input p27_i;
//input p28_i;
  
reg [3:0] da;
  
wire [3:0] io = {p10_i, p11_i, p12_i, p13_i};
  
wire drive_da;
wire drive_db;
  
wire custom_drives = ~p06_i;
  
wire [3:0] driven_da = drive_da ? io : 4'b0;
wire [3:0] driven_db = io;
  
  assign {p01_io, p02_io, p03_io, p04_io} = custom_drives == 1'b1 ? driven_da : 4'bZ;
  assign {p26_io, p25_io, p24_io, p23_io} = custom_drives == 1'b1 ? driven_db : 4'bZ;

wire flop1q;
DFlop flop1(.d(p09_i), .clk(p08_i), .nReset(s27_i), .q(flop1q), .nq());

wire flop2q;
wire flop2nq;
DFlop flop2(.d(flop2nq), .clk(flop1q), .nReset(s27_i), .q(flop2q), .nq(flop2nq));

wire flop3q;
wire flop3nq;
DFlop flop3(.d(flop2q), .clk(p07_i), .nReset(s27_i), .q(flop3q), .nq(flop3nq));

assign p22_o = flop3q;

wire flop4q;
wire flop4nq;
DFlop flop4(.d(flop3q), .clk(~p07_i), .nReset(s27_i), .q(flop4q), .nq(flop4nq));

assign p20_o = flop4nq;

wire flop5q;
wire flop5nq;
DFlop flop5(.d(flop4q), .clk(p05_i), .nReset(s27_i), .q(flop5q), .nq(flop5nq));

assign p21_o = flop5q;
  
assign drive_da = flop4q;
assign drive_db = flop4nq;
  
reg [3:0] cc;
  
wire [3:0] da_in = {p01_io, p02_io, p03_io, p04_io};
wire [3:0] db_in = {p26_io, p25_io, p24_io, p23_io};
  
  assign cc = p05_i ? (p21_o ? da_in : db_in) : cc;
  
assign {p18_o, p17_o, p16_o, p15_o} = cc;

assign p19_o = ~(|cc);

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
          state = 1'b0;
        end
        else
        begin
          state = d;
       end
    end
  
  
endmodule