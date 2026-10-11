/*
   CS 147 Spring 26
   Filename        : regFile.v
   Description     : 8x16 register file with two read ports and one write port.
*/
`default_nettype none

module regFile (
   input  wire        clk,
   input  wire        rst,

   input  wire [2:0]  read1RegSel,
   input  wire [2:0]  read2RegSel,

   input  wire        write_in,
   input  wire [2:0]  writeregsel_in,
   input  wire [15:0] writedata_in,

   output wire [15:0] read1Data,
   output wire [15:0] read2Data,

   output wire        write,
   output wire [2:0]  writeregsel,
   output wire [15:0] writedata
);

   wire [15:0] r0;
   wire [15:0] r1;
   wire [15:0] r2;
   wire [15:0] r3;
   wire [15:0] r4;
   wire [15:0] r5;
   wire [15:0] r6;
   wire [15:0] r7;

   wire en0;
   wire en1;
   wire en2;
   wire en3;
   wire en4;
   wire en5;
   wire en6;
   wire en7;

   wire err0;
   wire err1;
   wire err2;
   wire err3;
   wire err4;
   wire err5;
   wire err6;
   wire err7;

   assign en0 = write_in & (writeregsel_in == 3'b000);
   assign en1 = write_in & (writeregsel_in == 3'b001);
   assign en2 = write_in & (writeregsel_in == 3'b010);
   assign en3 = write_in & (writeregsel_in == 3'b011);
   assign en4 = write_in & (writeregsel_in == 3'b100);
   assign en5 = write_in & (writeregsel_in == 3'b101);
   assign en6 = write_in & (writeregsel_in == 3'b110);
   assign en7 = write_in & (writeregsel_in == 3'b111);

   register #(.WIDTH(16)) reg0(
      .q(r0), .err(err0),
      .clk(clk), .rst(rst), .en(en0), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg1(
      .q(r1), .err(err1),
      .clk(clk), .rst(rst), .en(en1), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg2(
      .q(r2), .err(err2),
      .clk(clk), .rst(rst), .en(en2), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg3(
      .q(r3), .err(err3),
      .clk(clk), .rst(rst), .en(en3), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg4(
      .q(r4), .err(err4),
      .clk(clk), .rst(rst), .en(en4), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg5(
      .q(r5), .err(err5),
      .clk(clk), .rst(rst), .en(en5), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg6(
      .q(r6), .err(err6),
      .clk(clk), .rst(rst), .en(en6), .d(writedata_in)
   );

   register #(.WIDTH(16)) reg7(
      .q(r7), .err(err7),
      .clk(clk), .rst(rst), .en(en7), .d(writedata_in)
   );

   assign read1Data =
      (read1RegSel == 3'b000) ? r0 :
      (read1RegSel == 3'b001) ? r1 :
      (read1RegSel == 3'b010) ? r2 :
      (read1RegSel == 3'b011) ? r3 :
      (read1RegSel == 3'b100) ? r4 :
      (read1RegSel == 3'b101) ? r5 :
      (read1RegSel == 3'b110) ? r6 : r7;

   assign read2Data =
      (read2RegSel == 3'b000) ? r0 :
      (read2RegSel == 3'b001) ? r1 :
      (read2RegSel == 3'b010) ? r2 :
      (read2RegSel == 3'b011) ? r3 :
      (read2RegSel == 3'b100) ? r4 :
      (read2RegSel == 3'b101) ? r5 :
      (read2RegSel == 3'b110) ? r6 : r7;

   assign write = write_in;
   assign writeregsel = writeregsel_in;
   assign writedata = writedata_in;

endmodule

`default_nettype wire

