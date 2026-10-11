/*
   CS 147 Spring 26
   Filename: wb.v
   Description: Writeback stage.
*/
`default_nettype none

module wb (
   input wire        clk,
   input wire        rst,

   input wire [15:0] aluResult_in,
   input wire [15:0] memoryData_in,
   input wire [15:0] pcPlus2_in,

   input wire [1:0]  wbSel,
   input wire [2:0]  writeRegSel_in,
   input wire        regWrite_in,

   output wire        write,
   output wire [2:0]  writeregsel,
   output wire [15:0] writedata
);

   // the value written to the register file
   assign writedata =
      (wbSel == 2'b00) ? aluResult_in :
      (wbSel == 2'b01) ? memoryData_in :
                         pcPlus2_in;

   // writeback control
   assign write       = regWrite_in;
   assign writeregsel = writeRegSel_in;

endmodule

`default_nettype wire