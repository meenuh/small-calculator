//top level for calculator
//
`timescale 1ns/1ps

module calculator_fpga(
                        input wire go,
                        input wire [1:0] op,
                        input wire [2:0] in1,
                        input wire [2:0] in2,
                        input wire clk,
                        input wire rst,
                        
                        output wire [3:0] CS,
                        output wire done,
                        output wire [2:0] out
                         );
     
    /*
    s1[1:0]
    WA[3:2]
    WE[4]
    RAA[6:5]
    RAB[8:7]
    REA[9]
    REB[10]
    C[12:11]
    s2[13]
    */                     
    wire [13:0] bus;                     
      
    /*
                input clk,
    input wire go,        //to break from being idle
    input wire [1:0] op,    //operation to do
    input wire rst,        //reset

    output reg [1:0] s1,     //control for MUX1
    output reg [1:0] WA,     //write address
    output reg WE,              //write enable
    output reg [1:0] RAA,     //read address A
    output reg [1:0] RAB,     //read address B
    output reg REA,        //read enable A
    output reg REB,     //read enable B
    output reg [1:0] C,     //control for ALU
    output reg s2,        //control for MUX2
    
    output wire [3:0] CS,     //output to 7seg display
    output reg done);    //output to LED bar 
    */  
               
    control_unit U1(
                    .go(go),
                    .op(op),
                    .rst(rst),
                    .s1(bus[1:0]),
                    .WA(bus[3:2]),
                    .WE(bus[4]),
                    .RAA(bus[6:5]),
                    .RAB(bus[8:7]),
                    .REA(bus[9]),
                    .REB(bus[10]),
                    .C(bus[12:11]),
                    .s2(bus[13]),
                    .cs(CS),
                    .done(done)
                    );
                    
//module DP(in1, in2, s1, clk, wa, we, raa, rea, rab, reb, c, s2, out);
    DP U2(
        .in1(in1),
        .in2(in2),
        .s1(bus[1:0]),
        .clk(clk),
        .wa(bus[3:2]),
        .we(bus[4]),
        .raa(bus[6:5]),
        .rea(bus[9]),
        .rab(bus[8:7]),
        .reb(bus[10]),
        .c(bus[12:11]),
        .s2(bus[13]),
        .out(out));
    

endmodule 