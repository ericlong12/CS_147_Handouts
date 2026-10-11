/*
    CS 147 Spring 26
    Homework #1, problem 2

    4-bit carry-lookahead adder.
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // we will use p[i] and g[i] to check if the bit has a carry
    wire p0;
    wire p1;
    wire p2;
    wire p3;
    // we use g for creating the carry
    wire g0;
    wire g1;
    wire g2;
    wire g3;
    // nand gates for later
    wire ourNandSignal1;
    wire ourNandSignal2;
    wire ourNandSignal3;
    wire ourNandSignal4;

    // carry wires
    wire c0;
    wire c1;
    wire c2;
    wire c3;
    wire c4;
    assign c0 = c_in;
    wire ourCarryNandSignal1;
    wire ourCarryTerm1;
    wire ourCarryNorSignal1;

    wire ourC2NandSignal1;
    wire ourC2NandSignal2;
    wire ourC2Term1;
    wire ourC2PairSignal;
    wire ourC2Term3;
    wire ourC2Term4;
    wire ourC2NorSignal2;
    wire unusedFullAdderCarry0;
    wire unusedFullAdderCarry1;
    wire unusedFullAdderCarry2;
    wire unusedFullAdderCarry3;

    wire c3TermP2G1;
    wire c3TermP2P1;
    wire c3TermP2P1G0;
    wire c3TermP2P1P0;
    wire c3TermP2P1P0C0;
    wire c3NandP2G1;
    wire c3NandP2P1;
    wire c3NandP2P1G0;
    wire c3NandP2P1P0;
    wire c3NandP2P1P0C0;
    wire c3OrFirstGroup;
    wire c3OrSecondGroup;
    wire c3OrFinal;
    wire c3NorFirstGroup;
    wire c3NorSecondGroup;
    wire c3NorFinal;

    // c4
    wire c4TermP3G2;
    wire c4TermP3P2;
    wire c4TermP3P2G1;
    wire c4TermP3P2P1;
    wire c4TermP3P2P1G0;
    wire c4TermP3P2P1P0;
    wire c4TermP3P2P1P0C0;
    wire c4NandP3G2;
    wire c4NandP3P2;
    wire c4NandP3P2G1;
    wire c4NandP3P2P1;
    wire c4NandP3P2P1G0;
    wire c4NandP3P2P1P0;
    wire c4NandP3P2P1P0C0;
    wire c4OrGroup1;
    wire c4OrGroup2;
    wire c4OrGroup3;
    wire c4OrGroup4;
    wire c4NorGroup1;
    wire c4NorGroup2;
    wire c4NorGroup3;
    wire c4NorGroup4;




    // xor gate 0
    xor2 ourXorGate0(
        .out(p0),
        .in1(a[0]),
        .in2(b[0])
    );


    // xor gate 1
    xor2 ourXorGate1(
        .out(p1),
        .in1(a[1]),
        .in2(b[1])
    );


    // xor gate 2
    xor2 ourXorGate2(
        .out(p2),
        .in1(a[2]),
        .in2(b[2])
    );

    // xor gate 3
    xor2 ourXorGate3(
        .out(p3),
        .in1(a[3]),
        .in2(b[3])
    );



    // we use a combo of nand gate and a not gate
    // this makes an and gate
    
    // we will create 4 nand gates and 4 not gates


    //  nand gate 0
    nand2 ourNandGate0(
        .out(ourNandSignal1),
        .in1(a[0]),
        .in2(b[0])
    );

    // not gate 0
    not1 ourNotGate0(
        .out(g0),
        .in1(ourNandSignal1)
    );


    // nand gate 1
    nand2 ourNandGate1(
        .out(ourNandSignal2),
        .in1(a[1]),
        .in2(b[1])
    );


    // not gate 1
    not1 ourNotGate1(
        .out(g1),
        .in1(ourNandSignal2)
    );


    // nand gate 2
    nand2 ourNandGate2(
        .out(ourNandSignal3),
        .in1(a[2]),
        .in2(b[2])
    );


    // not gate 2
    not1 ourNotGate2(
        .out(g2),
        .in1(ourNandSignal3)
    );

    // nand gate 3
    nand2 ourNandGate3(
        .out(ourNandSignal4),
        .in1(a[3]),
        .in2(b[3])
    );


    // not gate 3
    not1 ourNotGate3(
        .out(g3),
        .in1(ourNandSignal4)
    );



    // we will now calculate the carry
    // we have to find p0 and c0

    nand2 ourCarryNandGate1(
        .out(ourCarryNandSignal1),
        .in1(p0),
        .in2(c0)
    );



    // we use a not gate to reverse the results we got from the nand gate


    not1 ourCarryNotGate1(
        .out(ourCarryTerm1),
        .in1(ourCarryNandSignal1)
    );

    // now we calculate for c1
    // we do this by doing g0 or ourCarryTerm1

    nor2 ourCarryNorGate1(
        .out(ourCarryNorSignal1),
        .in1(g0),
        .in2(ourCarryTerm1)
    );


    not1 ourCarryNotGate2(
        .out(c1),
        .in1(ourCarryNorSignal1)
    );





    // c2 logic

    // now we will calculate for c2
    // we will do this by having c2 = g1 or (p1 and g0) or (p1 and p0 and c0)


    nand2 ourC2NandGate1(
        .out(ourC2NandSignal1),
        .in1(p1),
        .in2(g0)
    );



    not1 ourC2NotGate1(
        .out(ourC2Term1),
        .in1(ourC2NandSignal1)
    );


    // we find p1 and p0
    nand2 ourC2NandGate2(
        .out(ourC2NandSignal2),
        .in1(p1),
        .in2(p0)
    );

    not1 ourC2NotGate2(
        .out(ourC2PairSignal),
        .in1(ourC2NandSignal2)
    );

    nand2 ourC2NandGate4(
        .out(ourC2Term3),
        .in1(ourC2PairSignal),
        .in2(c0)
    );



    not1 ourC2NotGate5(
        .out(ourC2Term4),
        .in1(ourC2Term3)
    );




    nor3 ourC2NorGate2(
        .out(ourC2NorSignal2),
        .in1(g1),
        .in2(ourC2Term1),
        .in3(ourC2Term4)
    );



    not1 ourC2NotGate6(
        .out(c2),
        .in1(ourC2NorSignal2)
    );



    // c3 now
   
    // for c3 we will caclulate by doing 
    // g2 or (p2 and g1) or (p2 and p1 and g0) or (p2 AND p1 and p0 and c0)
    // we will be using a nand and a not to create the and gate

    nand2 c3NandGate1(
        .out(c3NandP2G1),
        .in1(p2),
        .in2(g1)
    );



    not1 c3NotGate1(
        .out(c3TermP2G1),
        .in1(c3NandP2G1)
    );



    // p1 p2
    nand2 c3NandGate2(
        .out(c3NandP2P1),
        .in1(p2),
        .in2(p1)
    );

    not1 c3NotGate2(
        .out(c3TermP2P1),
        .in1(c3NandP2P1)
    );


    // Cp2 and p1 and g0.
    nand2 c3NandGate3(
        .out(c3NandP2P1G0),
        .in1(c3TermP2P1),
        .in2(g0)
    );

    not1 c3NotGate3(
        .out(c3TermP2P1G0),
        .in1(c3NandP2P1G0)
    );




    // p2 and p1 and p0.
    nand2 c3NandGate4(
        .out(c3NandP2P1P0),
        .in1(c3TermP2P1),
        .in2(p0)
    );

    not1 c3NotGate4(
        .out(c3TermP2P1P0),
        .in1(c3NandP2P1P0)
    );


    // p2 and p1 and p0 and c0.
    nand2 c3NandGate5(
        .out(c3NandP2P1P0C0),
        .in1(c3TermP2P1P0),
        .in2(c0)
    );

    not1 c3NotGate5(
        .out(c3TermP2P1P0C0),
        .in1(c3NandP2P1P0C0)
    );


   // g2 or (p2 and g1)

    nor2 c3NorGate1(
        .out(c3NorFirstGroup),
        .in1(g2),
        .in2(c3TermP2G1)
    );

    not1 c3OrNotGate1(
        .out(c3OrFirstGroup),
        .in1(c3NorFirstGroup)
    );


    // (p2 and p1 and g0) or (p2 and p1 and p0 and c0)

    nor2 c3NorGate2(
        .out(c3NorSecondGroup),
        .in1(c3TermP2P1G0),
        .in2(c3TermP2P1P0C0)
    );

    not1 c3OrNotGate2(
        .out(c3OrSecondGroup),
        .in1(c3NorSecondGroup)
    );


    // now we combine both using c3OrFirstGroup or c3OrSecondGroup
    nor2 c3NorGate3(
        .out(c3NorFinal),
        .in1(c3OrFirstGroup),
        .in2(c3OrSecondGroup)
    );

    not1 c3OrNotGate3(
        .out(c3OrFinal),
        .in1(c3NorFinal)
    );

    assign c3 = c3OrFinal;



    // c4 = g3 or (p3 and g2) or (p3 and p2 and g1) or (p3 and p2 and p1 and g0) or (p3 and p2 and p1 and p0 and c0)

    // p3 and g2
    nand2 c4NandGate1(
        .out(c4NandP3G2),
        .in1(p3),
        .in2(g2)
    );



    not1 c4NotGate1(
        .out(c4TermP3G2),
        .in1(c4NandP3G2)
    );


    // p3 and p2.
    nand2 c4NandGate2(
        .out(c4NandP3P2),
        .in1(p3),
        .in2(p2)
    );

    not1 c4NotGate2(
        .out(c4TermP3P2),
        .in1(c4NandP3P2)
    );




    // p3 and p2 and g1.
    nand2 c4NandGate3(
        .out(c4NandP3P2G1),
        .in1(c4TermP3P2),
        .in2(g1)
    );

    not1 c4NotGate3(
        .out(c4TermP3P2G1),
        .in1(c4NandP3P2G1)
    );


    // p3 and p2 and p1.
    nand2 c4NandGate4(
        .out(c4NandP3P2P1),
        .in1(c4TermP3P2),
        .in2(p1)
    );

    not1 c4NotGate4(
        .out(c4TermP3P2P1),
        .in1(c4NandP3P2P1)
    );


    // p3 and p2 and p1 and g0.
    nand2 c4NandGate5(
        .out(c4NandP3P2P1G0),
        .in1(c4TermP3P2P1),
        .in2(g0)
    );

    not1 c4NotGate5(
        .out(c4TermP3P2P1G0),
        .in1(c4NandP3P2P1G0)
    );


    // p3 and p2 and p1 and p0.
    nand2 c4NandGate6(
        .out(c4NandP3P2P1P0),
        .in1(c4TermP3P2P1),
        .in2(p0)
    );

    not1 c4NotGate6(
        .out(c4TermP3P2P1P0),
        .in1(c4NandP3P2P1P0)
    );


    // p3 and p2 and p1 and p0 and c0.
    nand2 c4NandGate7(
        .out(c4NandP3P2P1P0C0),
        .in1(c4TermP3P2P1P0),
        .in2(c0)
    );

    not1 c4NotGate7(
        .out(c4TermP3P2P1P0C0),
        .in1(c4NandP3P2P1P0C0)
    );


    // g3 or (p3 and g2)
  
    nor2 c4NorGate1(
        .out(c4NorGroup1),
        .in1(g3),
        .in2(c4TermP3G2)
    );

    not1 c4OrNotGate1(
        .out(c4OrGroup1),
        .in1(c4NorGroup1)
    );


    // (p3 and p2 and g1) or (p3 and p2 and p1 and g0)

    nor2 c4NorGate2(
        .out(c4NorGroup2),
        .in1(c4TermP3P2G1),
        .in2(c4TermP3P2P1G0)
    );

    not1 c4OrNotGate2(
        .out(c4OrGroup2),
        .in1(c4NorGroup2)
    );



    // nor gate to combine 
    nor2 c4NorGate3(
        .out(c4NorGroup3),
        .in1(c4OrGroup1),
        .in2(c4OrGroup2)
    );

    not1 c4OrNotGate3(
        .out(c4OrGroup3),
        .in1(c4NorGroup3)
    );


    // p3 AND p2 AND p1 AND p0 AND c0


    nor2 c4NorGate4(
        .out(c4NorGroup4),
        .in1(c4OrGroup3),
        .in2(c4TermP3P2P1P0C0)
    );

    not1 c4OrNotGate4(
        .out(c4OrGroup4),
        .in1(c4NorGroup4)
    );


    assign c4 = c4OrGroup4;


    assign c_out = c4;




    // find the sum

    fullAdder_1b ourFullAdder0(
        .s(sum[0]),
        .c_out(unusedFullAdderCarry0),
        .a(a[0]),
        .b(b[0]),
        .c_in(c0)
    );

    fullAdder_1b ourFullAdder1(
        .s(sum[1]),
        .c_out(unusedFullAdderCarry1),
        .a(a[1]),
        .b(b[1]),
        .c_in(c1)
    );

    fullAdder_1b ourFullAdder2(
        .s(sum[2]),
        .c_out(unusedFullAdderCarry2),
        .a(a[2]),
        .b(b[2]),
        .c_in(c2)
    );

    fullAdder_1b ourFullAdder3(
        .s(sum[3]),
        .c_out(unusedFullAdderCarry3),
        .a(a[3]),
        .b(b[3]),
        .c_in(c3)
    );

endmodule
