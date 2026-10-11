/*
    CS 147 Spring 26
    Homework #3, problem 1

    Parameterized N-bit register built from DFFs.
*/
// Shared via symlink between assignments/hw03/hw3_1/register.v and assignments/hw03/hw3_2/register.v.
// WARNING: This file can be edited from either path, but DO NOT move or duplicate this file.
module register (
                 // Outputs
                 q, err,
                 // Inputs
                 clk, rst, en, d
                 );

   parameter WIDTH = 16;

   input              clk, rst, en;
   input  [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   output             err;

   wire [WIDTH-1:0] dff_d;
   // we should hold the current value when the register not enabled
   assign dff_d = en ? d : q;

   dff dff0(.q(q[0]),  .d(dff_d[0]),  .clk(clk), .rst(rst));
   dff dff1(.q(q[1]),  .d(dff_d[1]),  .clk(clk), .rst(rst));
   dff dff2(.q(q[2]),  .d(dff_d[2]),  .clk(clk), .rst(rst));
   dff dff3(.q(q[3]),  .d(dff_d[3]),  .clk(clk), .rst(rst));
   dff dff4(.q(q[4]),  .d(dff_d[4]),  .clk(clk), .rst(rst));
   dff dff5(.q(q[5]),  .d(dff_d[5]),  .clk(clk), .rst(rst));
   dff dff6(.q(q[6]),  .d(dff_d[6]),  .clk(clk), .rst(rst));
   dff dff7(.q(q[7]),  .d(dff_d[7]),  .clk(clk), .rst(rst));
   dff dff8(.q(q[8]),  .d(dff_d[8]),  .clk(clk), .rst(rst));
   dff dff9(.q(q[9]),  .d(dff_d[9]),  .clk(clk), .rst(rst));
   dff dff10(.q(q[10]), .d(dff_d[10]), .clk(clk), .rst(rst));
   dff dff11(.q(q[11]), .d(dff_d[11]), .clk(clk), .rst(rst));
   dff dff12(.q(q[12]), .d(dff_d[12]), .clk(clk), .rst(rst));
   dff dff13(.q(q[13]), .d(dff_d[13]), .clk(clk), .rst(rst));
   dff dff14(.q(q[14]), .d(dff_d[14]), .clk(clk), .rst(rst));
   dff dff15(.q(q[15]), .d(dff_d[15]), .clk(clk), .rst(rst));

   assign err = (rst === 1'b0) &
                ((clk === 1'bx) |
                 (rst === 1'bx) |
                 (en  === 1'bx) |
                 (^d  === 1'bx));
endmodule
