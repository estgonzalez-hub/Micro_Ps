//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26
`timescale 10ns/1ns

/////////////////////////////////////////////
//   sub_bytes
//   an invertible, non-linear transformation of the state in which a substitution table,
//   called an S-box, is applied independently to each byte in the state.
//   package the vector instead of transforming into an array
//   Note that each 32-bit word is a *column* of the state, not a row.
/////////////////////////////////////////////

module sub_bytes ( input logic clk, 
                  input logic [127:0] a,
                  output logic [127:0] y 
                );

    sbox s0(clk,  a[7:0],  y[7:0]);
    sbox s1(clk,  a[15:8],  y[15:8]);
    sbox s2(clk,  a[23:16],  y[23:16]);
    sbox s3(clk,  a[31:24],  y[31:24]);
    sbox s4(clk,  a[39:32],  y[39:32]);
    sbox s5(clk,  a[47:40],  y[47:40]);
    sbox s6(clk,  a[55:48],  y[55:48]);
    sbox s7(clk,  a[63:56],  y[63:56]);
    sbox s8(clk,  a[71:64],  y[71:64]);
    sbox s9(clk,  a[79:72],  y[79:72]);
    sbox s10(clk,  a[87:80],  y[87:80]);
    sbox s11(clk,  a[95:88],  y[95:88]);
    sbox s12(clk,  a[103:96],  y[103:96]);
    sbox s13(clk,  a[111:104],  y[111:104]);
    sbox s14(clk,  a[119:112],  y[119:112]);
    sbox s15(clk,  a[127:120],  y[127:120]);

endmodule