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
	
		go = 1; rst = 0; op = 0; clk = 0; #10;
		for(i = 0; i < 4; i = i+1)begin
		 clk = 1; #5;
                clk = 0; #5;   
		      op = i; #5;
		// clk = 0; #5;
		 clk = 1; #5;
		 clk = 0; #5;    
		      
		end
	
		//testing opcodesi and states
	$finish;	
	end	

endmodule
