/*
    CS 147 Spring 26
    Homework #1, problem 2

    1-bit full adder.
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
    input   a, b;
    input  c_in;

    // creating our wires to connect
    // the gates together

    wire ourXorSignal1;
    wire ourNandSignal1;
    wire ourNandSignal2;


    // we use xor for the first gate
    // this gate will take in the first wire and will
    // calculate a XOR b
    // later we will add the c_in

    xor2 ourXorGate1(
        .out(ourXorSignal1),
        .in1(a),
        .in2(b)
    );


    // we create the 2nd xor gate
    // this gate is made so that we can 
    // xor a and b and xor c_in
    xor2 ourXorGate2(
        .out(s),
        .in1(ourXorSignal1),
        .in2(c_in)
    );


    // we create a nand gate 
    // we will use this nand gate for not a and b

    nand2 ourNandGate1(
        .out(ourNandSignal1),
        .in1(a),
        .in2(b)
    );


    // we make our 2nd nand gate 
    // this one will be used for 
    // not a xor b and c_in

    nand2 ourNandGate2(
        .out(ourNandSignal2),
        .in1(ourXorSignal1),
        .in2(c_in)
    );


    // 3rd nand gate
    //
    // This combines the two possible carry sources.
    // this one is used to combine both of the carries from 
    // the other nand gates

    nand2 ourNandGate3(
        .out(c_out),
        .in1(ourNandSignal1),
        .in2(ourNandSignal2)
    );

endmodule
