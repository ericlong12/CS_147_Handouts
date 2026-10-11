/*
   CS 147 Spring 26
   Filename: decode.v
   Description: Decode stage and register-file connection.
*/
`default_nettype none

module decode (
   input wire        clk,
   input wire        rst,
   input wire [15:0] instr,

   // writeback inputs
   input wire        write_in,
   input wire [2:0]  writeregsel_in,
   input wire [15:0] writedata_in,

   // instruction field
   output wire [4:0]  opcode,
   output wire [2:0]  rsSel,
   output wire [2:0]  rtSel,
   output wire [2:0]  rdSel,
   output wire [1:0]  ext,

   // register file data
   output wire [15:0] rsData,
   output wire [15:0] rtData,

   // decoded immediate
   output wire [15:0] immediate
);

   // get the instruction fields
   assign opcode = instr[15:11];
   assign rsSel  = instr[10:8];
   assign rtSel  = instr[7:5];
   assign rdSel  = instr[4:2];
   assign ext    = instr[1:0];

   // select and extend the instruction immediate
   assign immediate =
      // J and JAL
      // signed 11 bit immediate
      ((opcode == 5'b00100) | (opcode == 5'b00110))
         ? {{5{instr[10]}}, instr[10:0]}

      // branches and jump register instructions
      // signed 8-bit immediate
      : ((opcode == 5'b01100) |
         (opcode == 5'b01101) |
         (opcode == 5'b01110) |
         (opcode == 5'b01111) |
         (opcode == 5'b00101) |
         (opcode == 5'b00111) |
         (opcode == 5'b11000))
         ? {{8{instr[7]}}, instr[7:0]}

      // XORI and ANDNI
      // zero-extended 5-bit immediate
      : ((opcode == 5'b01010) | (opcode == 5'b01011))
         ? {11'b0, instr[4:0]}

      // SLBI
      // zero-extended 8-bit immediate
      : (opcode == 5'b10010)
         ? {8'b0, instr[7:0]}

      // default: 
      // sign-extended 5-bit immediate
      : {{11{instr[4]}}, instr[4:0]};

   // functional register file
   regFile regFile0(
      .clk            (clk),
      .rst            (rst),

      .read1RegSel    (rsSel),
      .read2RegSel    (rtSel),
      .read1Data      (rsData),
      .read2Data      (rtData),

      .write_in       (write_in),
      .writeregsel_in (writeregsel_in),
      .writedata_in   (writedata_in),

      // signals monitored by the project testbench
      .write          (),
      .writeregsel    (),
      .writedata      ()
   );

endmodule

`default_nettype wire