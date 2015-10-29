`timescale 1 ns/1 ps

module dp_tb();
	reg[3:0] in1, in2;
	reg[1:0] s1, wa, raa, rab, c;
	reg we, rea, reb, s2, clk;

	wire[3:0] out;

	DP DUT(.in1(in1), .in2(in2), .s1(s1), .clk(clk), .wa(wa), .we(we), .raa(raa), .rea(rea), .rab(rab), .reb(reb), .c(c), .s2(s2), .out(out));

	initial
	begin
		clk = 0;	#10

		for(in1 = 0; in1 < 8; in1 = in1 + 1) begin
			for(in2 = 0; in2 < 8; in2 = in2 + 1) begin
				$display("in1: %d, in2: %d", in1, in2);

				//set output of mux2 to 0
				s2 = 0;
				clk = 1; 	#10
				clk = 0;	#10

				if(out != 0)
					$display("S2 = 0 Error");
				//else
					//$display("S2 = 0 Successful");

				//input in1 to reg1
				s1 = 2'b11;
				wa = 2'b01;

				clk = 1;	#10
				clk = 0;	#10

				we = 1;

				clk = 1; 	#10
				clk = 0;	#10

				we = 0;

				//input in2 to reg2
				s1 = 2'b10;
				wa = 2'b10;

				clk = 1;	#10
				clk = 0;	#10

				we = 1;

				clk = 1; 	#10
				clk = 0;	#10

				we = 0;

				//read r1 and r2
				raa = 2'b01;
				rea = 1;

				rab = 2'b10;
				reb = 1;

				//set output of mux2
				s2 = 1;

				clk = 1; 	#10
				clk = 0;	#10

				//test addition
				c = 2'b00;
				clk = 1; 	#10
				clk = 0;	#10

				if(out != (in1 + in2)) begin
				    $display("Addition error. %d", out);
				    $stop;
				end
				//else
					//$display("Addition successful.");

				//test subtraction
				c = 2'b01;
				clk = 1; 	#10
				clk = 0;	#10

				if(out != (in1 - in2)) begin
					$display("Subtraction error. %d %d", out, (in1 - in2));
				    $stop;
				end
				//else
					//$display("Subtraction successful");

				//test and
				c = 2'b10;
				clk = 1; 	#10
				clk = 0;	#10

				if(out != (in1 & in2)) begin
					$display("AND error. %d", out);
					$stop;
				end
				//else
					//$display("AND successful.");

				//test xor
				c = 2'b11;
				clk = 1; 	#10
				clk = 0;	#10

				if(out != (in1 ^ in2)) begin
					$display("XOR error. %d", out);
					$stop;
				end
				//else
					//$display("XOR successful.");

				rea = 0;
				reb = 0;

			end
		end
		$display("Simulation Successful");

	end
	
endmodule