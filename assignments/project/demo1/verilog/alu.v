/*
    CS 147 Spring 26
    Homework #2, problem 2

    Multi-bit ALU implementation.
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);


    // our input and output list
    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0

    // Arithmetic Logic Unit also known as the ALU
    wire [15:0] A;
    wire [15:0] B;


    // we create internal version of inA and inB and have them called A and B 
    // we can flip these for subtraction

    assign A = invA ? ~InA : InA;
    assign B = invB ? ~InB : InB;

    // we get the barrel shifter result
    wire [15:0] shiftResult;
    shifter shifterUnit(
        .In(A),
        .ShAmt(B[3:0]),
        .Oper(Oper[1:0]),
        .Out(shiftResult)
    );



    // we get the CLA result
    // CLA is also known as carry look ahread adder
    // as mentioned in class, this is much faster then using the ripple method
    // ripple method has dependencey

    wire [15:0] addResult;
    wire carryOut;
    cla_16b adderUnit(
        .sum(addResult),
        .c_out(carryOut),
        .a(A),
        .b(B),
        .c_in(Cin)
    ); // gets the sum and the carry out bit




    // get the logic results
    wire [15:0] andResult;
    wire [15:0] orResult;
    wire [15:0] xorResult;
    assign andResult = A & B;
    assign orResult  = A | B;
    assign xorResult = A ^ B;

    // now we create the mux. this is hardware version of if else statements

    // first we check if the top bit is 0, if it is then we use shift result
    // otherwise it is 1, then we check the other conditions add, and , or xor
    assign Out = (Oper[2] == 1'b0) ? shiftResult:
                (Oper == 3'b100) ? addResult:
                (Oper == 3'b101) ? andResult:
                (Oper == 3'b110) ? orResult:
                xorResult;

    // we check for zero, it OR 16 bits from out
    // if zero can only equal 1 if every bit out out is 0
    assign Zero = ~|Out;

    // now we check for overflow when we do additon
    // we should use Out[15] ^ A[15] ^ B[15] ^ carryOut 
    // to detect signed overflow

    wire signedOverflow;
    assign signedOverflow = Out[15] ^ A[15] ^ B[15] ^ carryOut;
    assign Ofl = (Oper == 3'b100)
               ? (sign ? signedOverflow : carryOut)
               : 1'b0;

endmodule