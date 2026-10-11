/*
   CS 147 Spring 26
   Filename        : execute.v
   Description     : Execute stage of the processor.
*/
`default_nettype none

module execute (
   input wire        clk,
   input wire        rst,

   input wire [15:0] pcCurrent,
   input wire [4:0]  opcode,
   input wire [1:0]  ext,
   input wire [2:0]  rsSel,
   input wire [2:0]  rtSel,
   input wire [2:0]  rdSel,
   input wire [15:0] rsData,
   input wire [15:0] rtData,
   input wire [15:0] immediate,

   output wire [15:0] aluResult,
   output wire [15:0] storeData,
   output wire [2:0]  writeRegSel,

   output wire        regWrite,
   output wire        memRead,
   output wire        memReadorWrite,
   output wire        memWrite,

   output wire [1:0]  wbSel,

   output wire [15:0] pcNext,
   output wire        pcWe,
   output wire        halt
);

   // instruction wire
   wire isRAlu;
   wire isAddI;
   wire isSubI;
   wire isXorI;
   wire isAndnI;

   wire isSubR;
   wire isXorR;
   wire isAndnR;

   wire isRoli;
   wire isSlli;
   wire isRori;
   wire isSrli;
   wire isRShift;

   wire isAlu;
   wire isShift;
   wire isSub;
   wire isXor;
   wire isAndn;

   wire isLBI;
   wire isSLBI;
   wire isST;
   wire isLD;
   wire isSTU;
   wire isMem;
   wire isBTR;

   wire isBEQZ;
   wire isBNEZ;
   wire isBLTZ;
   wire isBGEZ;

   wire isJ;
   wire isJR;
   wire isJAL;
   wire isJALR;
   wire isSIIC;
   wire isRTI;

   wire isBranch;
   wire isJump;
   wire isLink;

   reg [15:0] savedPc;

   // comparison wires
   wire isSEQ;
   wire isSLT;
   wire isSLE;
   wire isSCO;
   wire isCompare;
   wire compareEqual;
   wire compareLess;
   wire compareResult;

   wire unsignedLess;
   wire eq15, eq14, eq13, eq12;
   wire eq11, eq10, eq9,  eq8;
   wire eq7,  eq6,  eq5,  eq4;
   wire eq3,  eq2,  eq1;

   // ALU signals
   wire [15:0] aluA;
   wire [15:0] aluB;
   wire [2:0]  aluOper;
   wire        aluInvA;
   wire        aluInvB;
   wire        aluCin;
   wire        aluSign;

   wire [15:0] aluOut;
   wire        aluZero;
   wire        aluOfl;

   // PC and branch signals
   wire [15:0] pcPlus2;
   wire [15:0] branchOffset;
   wire [15:0] branchTarget;
   wire [15:0] registerTarget;

   wire pcCarry1;
   wire pcCarry2;
   wire pcCarry3;
   wire branchTaken;

   // shifter wire signals
   wire [15:0] shiftOut;
   wire [1:0]  shiftOper;
   wire [3:0]  shiftAmount;
   wire [15:0] btrResult;
   wire [15:0] rorResult;

   assign btrResult = {
      rsData[0],
      rsData[1],
      rsData[2],
      rsData[3],
      rsData[4],
      rsData[5],
      rsData[6],
      rsData[7],
      rsData[8],
      rsData[9],
      rsData[10],
      rsData[11],
      rsData[12],
      rsData[13],
      rsData[14],
      rsData[15]
   };

   assign isRAlu = (opcode == 5'b11011);

   assign isAddI  = (opcode == 5'b01000);
   assign isSubI  = (opcode == 5'b01001);
   assign isXorI  = (opcode == 5'b01010);
   assign isAndnI = (opcode == 5'b01011);

   assign isSubR  = isRAlu & (ext == 2'b01);
   assign isXorR  = isRAlu & (ext == 2'b10);
   assign isAndnR = isRAlu & (ext == 2'b11);

   assign isRoli   = (opcode == 5'b10100);
   assign isSlli   = (opcode == 5'b10101);
   assign isRori   = (opcode == 5'b10110);
   assign isSrli   = (opcode == 5'b10111);
   assign isRShift = (opcode == 5'b11010);

   assign isLBI  = (opcode == 5'b11000);
   assign isSLBI = (opcode == 5'b10010);

   assign isST  = (opcode == 5'b10000);
   assign isLD  = (opcode == 5'b10001);
   assign isSTU = (opcode == 5'b10011);
   assign isMem = isST | isLD | isSTU;

   assign isBTR = (opcode == 5'b11001);

   assign isBEQZ = (opcode == 5'b01100);
   assign isBNEZ = (opcode == 5'b01101);
   assign isBLTZ = (opcode == 5'b01110);
   assign isBGEZ = (opcode == 5'b01111);

   assign isJ    = (opcode == 5'b00100);
   assign isJR   = (opcode == 5'b00101);
   assign isJAL  = (opcode == 5'b00110);
   assign isJALR = (opcode == 5'b00111);
   assign isSIIC = (opcode == 5'b00010);
   assign isRTI  = (opcode == 5'b00011);

   assign isBranch = isBEQZ | isBNEZ | isBLTZ | isBGEZ;
   assign isJump   = isJ | isJR | isJAL | isJALR;
   assign isLink   = isJAL | isJALR;

   assign isAlu = isAddI | isSubI | isXorI | isAndnI | isRAlu;

   assign isShift =
      isRoli |
      isSlli |
      isRori |
      isSrli |
      isRShift;

   assign isSub  = isSubI | isSubR;
   assign isXor  = isXorI | isXorR;
   assign isAndn = isAndnI | isAndnR;

   // compare instruction decoding
   assign isSEQ = (opcode == 5'b11100);
   assign isSLT = (opcode == 5'b11101);
   assign isSLE = (opcode == 5'b11110);
   assign isSCO = (opcode == 5'b11111);

   assign isCompare = isSEQ | isSLT | isSLE | isSCO;

   // check if they are equal
   assign compareEqual = ~(|(rsData ^ rtData));

   // signals for unsigned comparison
   assign eq15 = ~(rsData[15] ^ rtData[15]);
   assign eq14 = eq15 & ~(rsData[14] ^ rtData[14]);
   assign eq13 = eq14 & ~(rsData[13] ^ rtData[13]);
   assign eq12 = eq13 & ~(rsData[12] ^ rtData[12]);
   assign eq11 = eq12 & ~(rsData[11] ^ rtData[11]);
   assign eq10 = eq11 & ~(rsData[10] ^ rtData[10]);
   assign eq9  = eq10 & ~(rsData[9]  ^ rtData[9]);
   assign eq8  = eq9  & ~(rsData[8]  ^ rtData[8]);
   assign eq7  = eq8  & ~(rsData[7]  ^ rtData[7]);
   assign eq6  = eq7  & ~(rsData[6]  ^ rtData[6]);
   assign eq5  = eq6  & ~(rsData[5]  ^ rtData[5]);
   assign eq4  = eq5  & ~(rsData[4]  ^ rtData[4]);
   assign eq3  = eq4  & ~(rsData[3]  ^ rtData[3]);
   assign eq2  = eq3  & ~(rsData[2]  ^ rtData[2]);
   assign eq1  = eq2  & ~(rsData[1]  ^ rtData[1]);

   // unsigned comparison: rsData < rtData
   assign unsignedLess =
      (~rsData[15] & rtData[15]) |
      (eq15 & ~rsData[14] & rtData[14]) |
      (eq14 & ~rsData[13] & rtData[13]) |
      (eq13 & ~rsData[12] & rtData[12]) |
      (eq12 & ~rsData[11] & rtData[11]) |
      (eq11 & ~rsData[10] & rtData[10]) |
      (eq10 & ~rsData[9]  & rtData[9])  |
      (eq9  & ~rsData[8]  & rtData[8])  |
      (eq8  & ~rsData[7]  & rtData[7])  |
      (eq7  & ~rsData[6]  & rtData[6])  |
      (eq6  & ~rsData[5]  & rtData[5])  |
      (eq5  & ~rsData[4]  & rtData[4])  |
      (eq4  & ~rsData[3]  & rtData[3])  |
      (eq3  & ~rsData[2]  & rtData[2])  |
      (eq2  & ~rsData[1]  & rtData[1])  |
      (eq1  & ~rsData[0]  & rtData[0]);


   // signed less-than comparison
   assign compareLess =
      (rsData[15] & ~rtData[15]) |
      (~(rsData[15] ^ rtData[15]) & unsignedLess);

   assign compareResult =
      isSEQ ? compareEqual :
      isSLT ? compareLess :
      isSLE ? (compareLess | compareEqual) :
      isSCO ? aluOfl :
              1'b0;

   // our branch conditions
   assign branchTaken =
      isBEQZ ? (~(|rsData)) :
      isBNEZ ? ( |rsData ) :
      isBLTZ ? rsData[15] :
      isBGEZ ? (~rsData[15]) :
               1'b0;

   // PC + 2
   cla_16b pcAdder(
      .sum   (pcPlus2),
      .c_out (pcCarry1),
      .a     (pcCurrent),
      .b     (16'h0002),
      .c_in  (1'b0)
   );

   // branch offset
   assign branchOffset = immediate;

   // branch target
   cla_16b branchAdder(
      .sum   (branchTarget),
      .c_out (pcCarry2),
      .a     (pcPlus2),
      .b     (branchOffset),
      .c_in  (1'b0)
   );

   // JR/JALR target
   cla_16b registerAdder(
      .sum   (registerTarget),
      .c_out (pcCarry3),
      .a     (rsData),
      .b     (immediate),
      .c_in  (1'b0)
   );

   // saving the return address for SIIC
   always @(posedge clk) begin
      if (rst) begin
         savedPc <= 16'h0000;
      end
      else if (isSIIC) begin
         savedPc <= pcPlus2;
      end
   end

   // ALU operands
   assign aluA =
      isSubI ? immediate :
      isSubR ? rtData :
               rsData;

   assign aluB =
      isSubI ? rsData :
      isSubR ? rsData :
      (isAddI | isSubI | isXorI | isAndnI) ? immediate :
                                             rtData;

   // ALU operation codes
   assign aluOper =
      isXor  ? 3'b111 :
      isAndn ? 3'b101 :
               3'b100;

   assign aluInvA = 1'b0;
   assign aluInvB = isSub | isAndn | isSLT | isSLE;
   assign aluCin  = isSub | isSLT | isSLE;
   assign aluSign = isSLT | isSLE;

   alu alu0(
      .InA   (aluA),
      .InB   (aluB),
      .Cin   (aluCin),
      .Oper   (aluOper),
      .invA   (aluInvA),
      .invB   (aluInvB),
      .sign   (aluSign),
      .Out    (aluOut),
      .Zero   (aluZero),
      .Ofl    (aluOfl)
   );

   // shift control
   assign shiftOper =
      (isRoli | (isRShift & (ext == 2'b00))) ? 2'b00 :
      (isSlli | (isRShift & (ext == 2'b01))) ? 2'b01 :
      (isSrli | (isRShift & (ext == 2'b11))) ? 2'b11 :
                                                2'b10;

   assign shiftAmount =
      isRShift ? rtData[3:0] : immediate[3:0];

   // rotate right
   assign rorResult =
      (rsData >> shiftAmount) |
      (rsData << (16 - shiftAmount));

   shifter shifter0(
      .In    (rsData),
      .ShAmt (shiftAmount),
      .Oper  (shiftOper),
      .Out   (shiftOut)
   );

   // pick result
   assign aluResult =
      isMem ? registerTarget :
      isBTR ? btrResult :
      (isRori | (isRShift & (ext == 2'b10))) ? rorResult :
      isSEQ ? {15'b0, compareResult} :
      isSLT ? {15'b0, compareResult} :
      isSLE ? {15'b0, compareResult} :
      isSCO ? {15'b0, compareResult} :
      isLink ? pcPlus2 :
      isLBI ? immediate :
      isSLBI ? ((rsData << 8) | {8'b0, immediate[7:0]}) :
      isShift ? shiftOut :
                aluOut;

   // destination register
   assign writeRegSel =
      isLink
         ? 3'b111
         : isSTU
            ? rsSel
            : isLD
               ? rtSel
               : (isLBI | isSLBI)
                  ? rsSel
                  : ((isAddI | isSubI | isXorI | isAndnI) |
                     (isRoli | isSlli | isRori | isSrli))
                     ? rtSel
                     : rdSel;

   // register write
   assign regWrite =
      isAlu | isShift | isLBI | isSLBI |
      isLink | isCompare | isBTR | isLD | isSTU;

   // store data
   assign storeData = rtData;


   // memory
   assign memRead        = isLD;
   assign memReadorWrite = isMem;
   assign memWrite       = isST | isSTU;


   // 01 selects memory data
   // 00 selects ALU result
   assign wbSel = isLD ? 2'b01 : 2'b00;

   // check the next PC selection
   assign pcNext =
      isSIIC ? 16'h0002 :
      isRTI  ? savedPc :
      isBranch ? branchTarget :
      (isJ | isJAL) ? branchTarget :
      (isJR | isJALR) ? registerTarget :
                        16'h0000;

   assign pcWe =
      isSIIC |
      isRTI |
      (isBranch & branchTaken) |
      isJump;

   // the opcode 00000 means halt
   assign halt = (opcode == 5'b00000);

endmodule

`default_nettype wire