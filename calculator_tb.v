`timescale 1ns/1ps

module calculator_tb;   
    
    reg go, clk, rst;
    reg [1:0] op;
    reg [2:0] in1, in2;
    
    wire [3:0] CS;
    wire done;
    wire [2:0] out;
    
    //for the test
    reg [3:0] i, j;
    reg [2:0] k, expected;
        /*
          input wire go,
          input wire [1:0] op,
          input wire [2:0] in1,
          input wire [2:0] in2,
          input wire clk,
          input wire rst,
                      
          output wire [3:0] CS,
          output wire done,
          output wire [2:0] out
    */
    calculator_fpga uut(
                        .go(go),
                        .op(op),
                        .in1(in1),
                        .in2(in2),
                        .clk(clk),
                        .rst(rst),
                        .CS(CS),
                        .done(done),
                        .out(out));
    /*
              input wire go,
    input wire [1:0] op,
    input wire [2:0] in1,
    input wire [2:0] in2,
    input wire clk,
    input wire rst,
    */
    initial begin
        op = 0;
        in1 = 0;
        in2 = 0;
        clk = 0;
        rst = 0;
        expected = 0;
        
        #100; //global reset
        
        for(i = 0; i < 8; i = i+1) begin
            for(j = 0; j < 8; j = j+1) begin
                for(k = 0; k < 4; k = k+1)begin
                    go = 1; 
                    op = k;
                    in1 = i;
                    in2 = j;
                    #10;
                    
                    //run through states until done so we can check output
                    while(!done) begin
                        #10;
                        clk = 1;
                        #10;
                        clk = 0;
                        #10;
                    end
                    case(k)
                        3: expected = i + j;
                        2: expected = i - j; 
                        1: expected = i & j;
                        default: expected = i ^ j; 

                    endcase

                    if(expected != out) begin
                         $display("Expected %d but got %d: in1: %d in2: %d op: %d", expected, out, in1, in2, op);
                         $stop;
                    end
                
                    #10;
                    clk = 1; 
                    #10;
                    clk = 0; 
                    #10; 
                end
            end
        end
        $display("All tests passed");
        $finish;
    end

endmodule
