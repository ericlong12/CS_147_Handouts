/*
    CS 147 Spring 26
    Homework #2, problem 1

    Barrel shifter implementation.
*/
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate




// rotate left we will use 2-to-1 mux logic 

    wire [15:0] s1_rot, s2_rot, s3_rot, s4_rot;
    assign s1_rot = ShAmt[0] ? {In[14:0], In[15]} : In;
    assign s2_rot = ShAmt[1] ? {s1_rot[13:0], s1_rot[15:14]} : s1_rot;
    assign s3_rot = ShAmt[2] ? {s2_rot[11:0], s2_rot[15:12]} : s2_rot;
    assign s4_rot = ShAmt[3] ? {s3_rot[7:0], s3_rot[15:8]} : s3_rot;

    // logical left shift
    wire [15:0] s1_ll, s2_ll, s3_ll, s4_ll;
    assign s1_ll = ShAmt[0] ? {In[14:0], 1'b0} : In;
    assign s2_ll = ShAmt[1] ? {s1_ll[13:0], 2'b00} : s1_ll;
    assign s3_ll = ShAmt[2] ? {s2_ll[11:0], 4'b0000} : s2_ll;
    assign s4_ll = ShAmt[3] ? {s3_ll[7:0], 8'b00000000} : s3_ll;

    // arithmetic right shift
    wire [15:0] s1_ars, s2_ars, s3_ars, s4_ars;
    assign s1_ars = ShAmt[0] ? {In[15], In[15:1]} : In;
    assign s2_ars = ShAmt[1] ? {{2{s1_ars[15]}}, s1_ars[15:2]} : s1_ars;
    assign s3_ars = ShAmt[2] ? {{4{s2_ars[15]}}, s2_ars[15:4]} : s2_ars;
    assign s4_ars = ShAmt[3] ? {{8{s3_ars[15]}}, s3_ars[15:8]} : s3_ars;

    // logical right shift 
    wire [15:0] s1_lr, s2_lr, s3_lr, s4_lr;
    assign s1_lr = ShAmt[0] ? {1'b0, In[15:1]} : In;
    assign s2_lr = ShAmt[1] ? {2'b00, s1_lr[15:2]} : s1_lr;
    assign s3_lr = ShAmt[2] ? {4'b0000, s2_lr[15:4]} : s2_lr;
    assign s4_lr = ShAmt[3] ? {8'b00000000, s3_lr[15:8]} : s3_lr;

    // we use a mux to select based on oper 
    // 00 = rot left
    // 01 = log left
    // 10 = arith right
    // 11 = log right
    assign Out = (Oper == 2'b00) ? s4_rot :
                 (Oper == 2'b01) ? s4_ll  :
                 (Oper == 2'b10) ? s4_ars : s4_lr;

endmodule