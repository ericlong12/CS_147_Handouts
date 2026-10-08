/*
    CS 147 Spring 26
    Homework #3, problem 1

    8x16 register file with 2 read ports and 1 write port.
*/
// Shared via symlink between assignments/hw03/hw3_1/regFile.v and assignments/hw03/hw3_2/regFile.v.
// WARNING: This file can be edited from either path, but DO NOT move or duplicate this file.
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [15:0] r0;
   wire [15:0] r1;
   wire [15:0] r2;
   wire [15:0] r3;
   wire [15:0] r4;
   wire [15:0] r5;
   wire [15:0] r6;
   wire [15:0] r7;
    dff ready_dff(
    .q(ready),
    .d(1'b1),
    .clk(clk),
    .rst(rst)
    );

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
   wire ready;

   assign en0 = writeEn & ~rst & ready & (writeRegSel == 3'b000);
   assign en1 = writeEn & ~rst & ready & (writeRegSel == 3'b001);
   assign en2 = writeEn & ~rst & ready & (writeRegSel == 3'b010);
   assign en3 = writeEn & ~rst & ready & (writeRegSel == 3'b011);
   assign en4 = writeEn & ~rst & ready & (writeRegSel == 3'b100);
   assign en5 = writeEn & ~rst & ready & (writeRegSel == 3'b101);
   assign en6 = writeEn & ~rst & ready & (writeRegSel == 3'b110);
   assign en7 = writeEn & ~rst & ready & (writeRegSel == 3'b111);


   register #(.WIDTH(16)) reg0(
       .q(r0), .err(err0),
       .clk(clk), .rst(rst), .en(en0), .d(writeData)
   );

   register #(.WIDTH(16)) reg1(
       .q(r1), .err(err1),
       .clk(clk), .rst(rst), .en(en1), .d(writeData)
   );

   register #(.WIDTH(16)) reg2(
       .q(r2), .err(err2),
       .clk(clk), .rst(rst), .en(en2), .d(writeData)
   );

   register #(.WIDTH(16)) reg3(
       .q(r3), .err(err3),
       .clk(clk), .rst(rst), .en(en3), .d(writeData)
   );

   register #(.WIDTH(16)) reg4(
       .q(r4), .err(err4),
       .clk(clk), .rst(rst), .en(en4), .d(writeData)
   );

   register #(.WIDTH(16)) reg5(
       .q(r5), .err(err5),
       .clk(clk), .rst(rst), .en(en5), .d(writeData)
   );

   register #(.WIDTH(16)) reg6(
       .q(r6), .err(err6),
       .clk(clk), .rst(rst), .en(en6), .d(writeData)
   );

   register #(.WIDTH(16)) reg7(
       .q(r7), .err(err7),
       .clk(clk), .rst(rst), .en(en7), .d(writeData)
   );

   assign read1Data = (read1RegSel == 3'b000) ? r0 :
                      (read1RegSel == 3'b001) ? r1 :
                      (read1RegSel == 3'b010) ? r2 :
                      (read1RegSel == 3'b011) ? r3 :
                      (read1RegSel == 3'b100) ? r4 :
                      (read1RegSel == 3'b101) ? r5 :
                      (read1RegSel == 3'b110) ? r6 : r7;

   assign read2Data = (read2RegSel == 3'b000) ? r0 :
                      (read2RegSel == 3'b001) ? r1 :
                      (read2RegSel == 3'b010) ? r2 :
                      (read2RegSel == 3'b011) ? r3 :
                      (read2RegSel == 3'b100) ? r4 :
                      (read2RegSel == 3'b101) ? r5 :
                      (read2RegSel == 3'b110) ? r6 : r7;

   assign err = (rst === 1'b0) &
                (err0 | err1 | err2 | err3 |
                 err4 | err5 | err6 | err7 |
                 (clk === 1'bx) |
                 (rst === 1'bx) |
                 (writeEn === 1'bx) |
                 (^read1RegSel === 1'bx) |
                 (^read2RegSel === 1'bx) |
                 (^writeRegSel === 1'bx) |
                 (^writeData === 1'bx));

endmodule
