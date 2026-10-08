/*
    CS 147 Spring 26
    Homework #3, problem 2

    Bypass wrapper around the register file.
*/
module regFile_bypass (
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



   wire [15:0] rfRead1Data;
   wire [15:0] rfRead2Data;
   wire        rfErr;

   regFile rf0(
       .read1Data   (rfRead1Data),
       .read2Data   (rfRead2Data),
       .err         (rfErr),
       .clk         (clk),
       .rst         (rst),
       .read1RegSel (read1RegSel),
       .read2RegSel (read2RegSel),
       .writeRegSel (writeRegSel),
       .writeData   (writeData),
       .writeEn     (writeEn)
   );

   assign read1Data = (writeEn & ~rst &
                       (read1RegSel == writeRegSel))
                       ? writeData : rfRead1Data;

   assign read2Data = (writeEn & ~rst &
                       (read2RegSel == writeRegSel))
                       ? writeData : rfRead2Data;

   assign err = rfErr;


endmodule
