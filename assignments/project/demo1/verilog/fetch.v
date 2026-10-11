/*
   CS 147 Spring 26
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (
   input  wire        clk,
   input  wire        rst,
   input  wire        pc_we,
   input  wire [15:0] pc_next,
   input  wire [15:0] instr_in,
   output wire [15:0] pcCurrent,
   output wire [15:0] instr
);

   // wires
   wire [15:0] pc_q;
   wire [15:0] pc_d;
   wire [15:0] pc_plus2;
   wire        pc_cout;


   // adder
   cla_16b pc_adder(
      .sum(pc_plus2),
      .c_out(pc_cout),
      .a(pc_q),
      .b(16'h0002),
      .c_in(1'b0)
   );

   assign pc_d = pc_we ? pc_next : pc_plus2;

   assign pcCurrent = pc_q;
   assign instr = instr_in;

   dff pc0 (.q(pc_q[0]),  .d(pc_d[0]),  .clk(clk), .rst(rst));
   dff pc1 (.q(pc_q[1]),  .d(pc_d[1]),  .clk(clk), .rst(rst));
   dff pc2 (.q(pc_q[2]),  .d(pc_d[2]),  .clk(clk), .rst(rst));
   dff pc3 (.q(pc_q[3]),  .d(pc_d[3]),  .clk(clk), .rst(rst));
   dff pc4 (.q(pc_q[4]),  .d(pc_d[4]),  .clk(clk), .rst(rst));
   dff pc5 (.q(pc_q[5]),  .d(pc_d[5]),  .clk(clk), .rst(rst));
   dff pc6 (.q(pc_q[6]),  .d(pc_d[6]),  .clk(clk), .rst(rst));
   dff pc7 (.q(pc_q[7]),  .d(pc_d[7]),  .clk(clk), .rst(rst));
   dff pc8 (.q(pc_q[8]),  .d(pc_d[8]),  .clk(clk), .rst(rst));
   dff pc9 (.q(pc_q[9]),  .d(pc_d[9]),  .clk(clk), .rst(rst));
   dff pc10(.q(pc_q[10]), .d(pc_d[10]), .clk(clk), .rst(rst));
   dff pc11(.q(pc_q[11]), .d(pc_d[11]), .clk(clk), .rst(rst));
   dff pc12(.q(pc_q[12]), .d(pc_d[12]), .clk(clk), .rst(rst));
   dff pc13(.q(pc_q[13]), .d(pc_d[13]), .clk(clk), .rst(rst));
   dff pc14(.q(pc_q[14]), .d(pc_d[14]), .clk(clk), .rst(rst));
   dff pc15(.q(pc_q[15]), .d(pc_d[15]), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
