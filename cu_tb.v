`timescale 1ns/1ps

module cu_tb;
	reg go;		//to break from being idle
	reg [1:0] op;	//operation to do
	reg rst;	//reset
	reg clk;

	wire [1:0] s1;		//control for MUX1
	wire [1:0] WA; 		//write address
	wire WE;           	//write enable
	wire [1:0] RAA; 	//read address A
	wire [1:0] RAB; 	//read address B
	wire REA;      		//read enable A
	wire REB;   		//read enable B
	wire [1:0] C; 		//control for ALU
	wire s2;       		//control for MUX2
			
	wire [3:0] cs; 	//output to 7seg display
	wire done;	    //output to LED bar
	
	//instantiate cu module 
	control_unit uut(.go(go), 
			.op(op),
			.rst(rst),
			.clk(clk),
			.s1(s1),
			.WA(WA),
			.WE(WE),
			.RAA(RAA),
			.RAB(RAB),
			.REA(REA),
			.REB(REB),
			.C(C),
			.s2(s2),
			.CS(cs),
			.done(done)); 
	
	integer i;

	initial begin
	
		go = 0; rst = 0; op = 0; clk = 0; #10;
		//checking state 0 outside of loop
        //$display("cs: %d states: %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
        //if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b000000000000000) $display("error");
        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b000000000000000)begin
           $display("State %d is incorrect. Should be: 000000000000000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
           $stop;
        end
        clk = 1; #5;
        clk = 0; #5;
        
        go = 1; #5;
        //$display("cs: %d states: %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b000000000000000)begin
            $display("State %d is incorrect. Should be: 000000000000000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
            $stop;
        end
        clk = 1; #5;
        clk = 0; #5;
		
		for(i = 0; i < 4; i = i+1)begin
		    op = i; #5;
            go = 1; #5;
		
		    clk = 1; #5;
            clk = 0; #5;   
            go = 0; #5;
            
             while(cs != 0) begin
                case(cs) 
                    1: 
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b110110000000000) begin
                            $display("State %d is incorrect. Should be: 110110000000000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end
                    2: 
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b101010000000000) begin
                            $display("State %d is incorrect. Should be: 101010000000000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end 
                    3:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b000000111010000) begin
                            $display("State %d is incorrect. Should be: 000000111010000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end
                    4:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b001110000001100) begin
                             $display("State %d is incorrect. Should be: 001110000001100 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                             $stop;
                        end
                    5:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b001110000001000) begin
                            $display("State %d is incorrect. Should be: 001110000001000 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end
                    6:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b001110000000100) begin
                            $display("State %d is incorrect. Should be: 001110000000100 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end                    
                    7:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b001110000000100) begin
                            $display("State %d is incorrect. Should be: 001110000000100 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end                    
                    8:
                        if({s1, WA, WE, RAA, REA, RAB, REB, C, s2, done} != 15'b000000000000011) begin
                            $display("State %d is incorrect. Should be: 000000000000011 but got %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                            $stop;
                        end                    
                    default: begin
                        $display("Invalid");
                        $stop;
                    end
                endcase
               // $display("cs: %d states: %b", cs, {s1, WA, WE, RAA, REA, RAB, REB, C, s2, done});
                clk = 1; #5;
                clk = 0; #5; 
             end  
		end
	$display("All tests passed");
		//testing opcodesi and states
	$finish;	
	end	

endmodule
