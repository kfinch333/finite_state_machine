//FSM physical validation
module FSM_pv(input KEY0, SW0, SW1, SW2, SW3, SW4, output logic [6:0] HEX0, HEX1, HEX2, HEX3, output logic [6:0] LED_SW);
	wire [2:0] state;
	logic [1:0] Z;
	fsm fsm1 (KEY0, SW0, SW1, SW2, SW3, SW4, state, LED_SW [6:5]);
	ASCIICodes disp (state, HEX3, HEX2, HEX1, HEX0);
	always begin
		LED_SW [4] = SW4;
		LED_SW [3] = SW3;
		LED_SW [2] = SW2;
		LED_SW [1] = SW1;
		LED_SW [0] = SW0;
	end
endmodule

//Ascii Test
module testdisp();
	reg clk = 0;
	reg [2:0] state;
	wire [6:0] Hex3, Hex2, Hex1, Hex0;
	ASCIICodes test (state, Hex3, Hex2, Hex1, Hex0);
	initial begin
		state = 3'b000; #10;
		state = 3'b001; #10;
		state = 3'b010; #10;
		state = 3'b011; #10;
		state = 3'b100; #10;
	end
endmodule

//Ascii Codes
module ASCIICodes (input [2:0] state, output [6:0] HexSeg3, HexSeg2, HexSeg1, HexSeg0);
	reg [7:0] Message [3:0];
	always @ (*) begin
		Message[3] = "F";
		Message[2] = "i";
		Message[1] = "n";
		Message[0] = "c";
		
		case (state)
			3'b000 : begin
				Message[3] = "F";
				Message[2] = "i";
				Message[1] = "n";
				Message[0] = "c";
			end
			3'b001 : begin
				Message[3] = "S";
				Message[2] = 5;
				Message[1] = 0;
				Message[0] = 1;
			end
			3'b010 : begin
				Message[3] = "S";
				Message[2] = 5;
				Message[1] = 0;
				Message[0] = 2;
			end
			3'b011 : begin
				Message[3] = "S";
				Message[2] = 5;
				Message[1] = 0;
				Message[0] = 3;
			end
			3'b100 : begin
				Message[3] = "S";
				Message[2] = 5;
				Message[1] = 0;
				Message[0] = 4;
			end
			default : begin
				Message[3] = "F";
				Message[2] = "i";
				Message[1] = "n";
				Message[0] = "c";
			end
		endcase
	end

	ASCII27Seg SevH3 (Message[3], HexSeg3);
	ASCII27Seg SevH2 (Message[2], HexSeg2);
	ASCII27Seg SevH1 (Message[1], HexSeg1);
	ASCII27Seg SevH0 (Message[0], HexSeg0);
endmodule

//ASCII Converter
module ASCII27Seg (input [7:0] AsciiCode, output reg [6:0] HexSeg);
	always @ (*) begin
		HexSeg = 8'd0;
		$display ("AsciiCode %b", AsciiCode);
		case (AsciiCode)
//			0
			8'h0 : HexSeg[6] = 1;
//			1
			8'h1 : begin
				HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1; HexSeg[6] = 1;
			end
//			2
			8'h2 : begin
				HexSeg[2] = 1; HexSeg[5] = 1;
			end
//			3
			8'h3 : begin
				HexSeg[4] = 1; HexSeg[5] = 1;
			end
//			4
			8'h4 : begin
				HexSeg[0] = 1; HexSeg[3] = 1; HexSeg[4] = 1;
			end
//			C
			8'h43 : begin
				HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
			end
//			c
			8'h63 : begin
				HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
			end
//			F
			8'h46 : begin
				HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
			end
//			f
			8'h66 : begin
				HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
			end
//			H
			8'h48 : begin
				HexSeg[0] = 1; HexSeg[3] = 1;
			end
//			h
			8'h68 : begin
				HexSeg[0] = 1; HexSeg[3] = 1;
			end
//			I
			8'h49 : begin
				HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1; HexSeg[6] = 1;
			end
//			i
			8'h69 : begin
				HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1; HexSeg[6] = 1;
			end
//			N
			8'h4E : begin
				HexSeg[1] = 1; HexSeg[3] = 1; HexSeg[5] = 1; HexSeg[0] = 1;
			end
//			n
			8'h6E : begin
				HexSeg[1] = 1; HexSeg[3] = 1; HexSeg[5] = 1; HexSeg[0] = 1;
			end
//			_
			8'h5 : begin
				HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[4] = 1; HexSeg[5] = 1; HexSeg[6] = 1;
			end
//			S
			8'h53 : begin
				HexSeg[1] = 1; HexSeg[4] = 1;
			end
//			s
			8'h73 : begin
				HexSeg[1] = 1; HexSeg[4] = 1;
			end
		default : HexSeg = 8'b10110110;
		endcase
	end
endmodule		

//FSM test
module FSM_tb();
	logic KEY0, SW0, SW1, SW2, SW3, SW4;
	logic [2:0] state;
	logic [1:0] Z;
	fsm fsm1 (KEY0, SW0, SW1, SW2, SW3, SW4, state, Z);
	initial
		begin
			KEY0=0; SW0=1; SW1=0; SW2=0; SW3=0; SW4=0; #10;
			SW0=0; SW2=1; #10;
			SW2=0; SW1=1; #10;
			SW1=1; #10;
			SW1=1; #10;
			SW1=0; SW4=1; #10;
			SW4=0; SW3=1; #10;
			SW3=0; SW1=1; #10;
		end

	always begin
		#5 KEY0 = ~KEY0;
	end
endmodule

//Finite State Machine
module fsm (input clk, reset, S1, S2, S3, S4, output logic [2:0] state, output logic [1:0] Z);
	reg [2:0] nextState;
	localparam Strt=3'b000, Seen1=3'b001, Seen2=3'b010, Seen3=3'b011, Seen4=3'b100;

	always @ (posedge clk or posedge reset)
		if (reset)
			state <= Strt;
		else
		state <= nextState;

	always @ (*)
		begin
			nextState = state;
			Z = 2'b01;
			case (state)
				Strt:
					begin
						Z = 2'b01;
						if (S2 & ~S1 & ~S3 & ~S4)
							nextState = Seen1;
						else if (S3 & ~S1 & ~S2 & ~S4)
							nextState = Seen3;
						else
							nextState = state;
					end
				Seen1: 
					begin
						Z = 2'b10;
						if (S1 & ~S2 & ~S3 & ~S4)
							nextState = Seen2;
						else
							nextState = state;
					end
				Seen2: 
					begin
						Z = 2'b00;
						if (S1 & ~S2 & ~S3 & ~S4)
							nextState = Seen1;
						else if (S4 & ~S1 & ~S2 & ~S3)
							nextState = Seen3;
						else
							nextState = state;
					end
				Seen3:
					begin
						Z = 2'b00;
						if (S1 & ~S2 & ~S3 & ~S4)
							nextState = Seen1;
						else if (S3 & ~S1 & ~S2 & ~S4)
							nextState = Seen4;
						else
							nextState = state;
					end
				Seen4:
					begin
						Z = 2'b11;
						if (S1 & ~S2 & ~S3 & ~S4)
							nextState = Seen1;
						else
							nextState = state;
					end
			endcase
		end
endmodule

//Debounce
module debounce3 #(parameter cntSize = 8)
(
	input reset,
	input Clk,
	input PB,
	output reg pulse
);

	reg [cntSize-1:0] cnt;

	always @ (posedge Clk)
		if (reset)
			cnt <= {cntSize{1'b0}};
		else 
			begin
				cnt <= {cnt[cntSize-2:0], PB};
				if ( &cnt )		 pulse <= 1'b1;
				else if (~|cnt) pulse <= 1'b0;
			end
endmodule
