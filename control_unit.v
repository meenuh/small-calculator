`timescale 1ns/1ps
//control unit for small calculator

module control_unit(
            input clk,
			input wire go,		//to break from being idle
			input wire [1:0] op,	//operation to do
			input wire rst,		//reset

			output reg [1:0] s1, 	//control for MUX1
			output reg [1:0] WA, 	//write address
			output reg WE,	      	//write enable
			output reg [1:0] RAA, 	//read address A
			output reg [1:0] RAB, 	//read address B
			output reg REA,		//read enable A
			output reg REB, 	//read enable B
			output reg [1:0] C, 	//control for ALU
			output reg s2,		//control for MUX2
			
			output wire [3:0] CS, 	//output to 7seg display
			output reg done);	//output to LED bar 
   
	/*
	* We need register to hold the cs
	* function that describes where to go for ns
	* output function
	* 
	*/
	reg [3:0]cs, ns;

	assign CS = cs; //assign for output CS

	//for states
	localparam s0_IDLE = 4'b0000;
	localparam s1_WRITE1 = 4'b0001;
	localparam	s2_WRITE2 = 4'b0010; 
	localparam	s3_READ = 4'b0011;
	localparam	s4_ADD = 4'b0100;
	localparam	s5_SUB = 4'b0101;
	localparam	s6_AND = 4'b0110;
	localparam	s7_XOR = 4'b0111;
	localparam	s8_OUTPUT = 4'b1000;

	//for opcodes
	localparam ADD = 2'b11;
	localparam SUB = 2'b10;
	localparam	AND = 2'b01;
	localparam	XOR = 0;
	
	//start at state 0	
    initial begin
        cs = s0_IDLE;
    end
	
	always @(posedge clk) begin
	   if(rst == 1)
	       cs <= s0_IDLE;
	    else cs <= ns;
	//st == 0 ? cs <= s0_IDLE : cs <= ns;
	end

	//determines how the fsm should act
	always @(go, op, cs) begin
		case(cs) 
			s0_IDLE: begin 
			             if(go) ns = s1_WRITE1;
			             else ns = s0_IDLE;
			             //go ? ns = s1_WRITE1 : ns = s0_IDLE; 
			         end
		    s1_WRITE1: ns = s2_WRITE2;
			s2_WRITE2: ns = s3_READ;
			s3_READ: 
				case(op)
					ADD: ns = s4_ADD;
					SUB: ns = s5_SUB;
					AND: ns = s6_AND;
					XOR: ns = s7_XOR;
					default: ns = s7_XOR; //if it doesn't match any operator, it should XOR automatically
				endcase
				
			s4_ADD: ns = s8_OUTPUT; 
			s5_SUB: ns = s8_OUTPUT;
			s6_AND: ns = s8_OUTPUT;
			s7_XOR:	ns = s8_OUTPUT;
			s8_OUTPUT: ns = s0_IDLE;
			default: ns = cs;	
		endcase
	end

	//set outputs
	always @(cs) begin
		case(cs) 
			s0_IDLE: begin s1 = 0; WA = 0; WE = 0; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 0; s2 = 0; done = 0; end
			s1_WRITE1: begin s1 = 3; WA = 1; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 0; s2 = 0; done = 0; end
			s2_WRITE2:  begin s1 = 2; WA = 2; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 0; s2 = 0; done = 0; end
			s3_READ:  begin s1 = 0; WA = 0; WE = 0; RAA = 1; REA = 1; RAB = 2; REB = 1; C = 0; s2 = 0; done = 0; end
			s4_ADD:  begin s1 = 0; WA = 3; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 3; s2 = 0; done = 0; end
			s5_SUB:  begin s1 = 0; WA = 3; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 2; s2 = 0; done = 0; end
			s6_AND:  begin s1 = 0; WA = 3; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 1; s2 = 0; done = 0; end
			s7_XOR:  begin s1 = 0; WA = 3; WE = 1; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 1; s2 = 0; done = 0; end
			s8_OUTPUT:  begin s1 = 0; WA = 0; WE = 0; RAA = 0; REA = 0; RAB = 0; REB = 0; C = 0; s2 = 1; done = 1; end
		endcase
	end
	
endmodule
