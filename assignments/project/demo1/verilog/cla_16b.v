/*
    CS 147 Spring 26
    Homework #1, problem 2

    16-bit carry-lookahead adder.
*/
module cla_16b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;



    // we will divide and conquor
    // we split up into four 4-bit 
    // bits 0 - 3
    // bits 4 - 7
    // bits 8 - 11
    // bits 12 - 15

    wire carryFromBits0To3;
    wire carryFromBits4To7;
    wire carryFromBits8To11;


 

    // a[3:0] + b[3:0] + c_in

    cla_4b ourCLA0(
        .sum(sum[3:0]),
        .c_out(carryFromBits0To3),
        .a(a[3:0]),
        .b(b[3:0]),
        .c_in(c_in)
    );


    // a[7:4] + b[7:4]


    cla_4b ourCLA1(
        .sum(sum[7:4]),
        .c_out(carryFromBits4To7),
        .a(a[7:4]),
        .b(b[7:4]),
        .c_in(carryFromBits0To3)
    );


    //a[11:8] + b[11:8]


    cla_4b ourCLA2(
        .sum(sum[11:8]),
        .c_out(carryFromBits8To11),
        .a(a[11:8]),
        .b(b[11:8]),
        .c_in(carryFromBits4To7)
    );


    // a[15:12] + b[15:12]


    cla_4b ourCLA3(
        .sum(sum[15:12]),
        .c_out(c_out),
        .a(a[15:12]),
        .b(b[15:12]),
        .c_in(carryFromBits8To11)
    );

endmodule
