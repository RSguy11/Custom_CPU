module select_and_encode #(parameter init = 0)(
	output reg [31:0] Const_sign_extend_out,
	//Enables for different registers
	output reg [15:0] R_enable,
	//Outputs from different registers
	output reg [15:0] R_out, 
	
	//Inputs to Select+Encode logic
	input wire Gra, Grb, Grc, Rin, Rout, BAout
	input [31:0] IR);
	
	reg [3:0] input_to_decoder = 4'b0000;
	reg [3:0] output_from_decoder;
	
	//Initilize enables and outputs
	initial
	begin
		R_enable = 16'h0000;
		R_outs = 16'h0000;
	end
	
	//Will be logical or of BAout or Rout per the logic circuit
	reg BAout_or_Rout;
	
	//Used to store the 4bit AND Operation per the circuit
	reg [3:0] RA_Gra, RB_Grb, RC_Grc;
	
	always@(*)
	begin
		BAout_or_Rout = (Rout | BAout);
	end
	
	
	//Three and gates + an or gate to determine the input to the decoder
	always @(*)
	begin
		RA_Gra = (IR[26:23] & (Gra? 4b'1111 : 4b'0000));
		RB_Grb = (IR[22:19] & (Gra? 4b'1111 : 4b'0000));
		RC_Grc = (IR[18:15] & (Gra? 4b'1111 : 4b'0000));
		input_to_decoder = (RA_Gra | RB_Grb | RC_Grc);
	end
	
	//16-4 DECODER LOGIC!!!
	always @(*)
	begin
		case(input_to_decoder)
			4'b0000: output_from_decoder <= 16'b0000000000000001;
			4'b0001: output_from_decoder <= 16'b0000000000000010;
			4'b0010: output_from_decoder <= 16'b0000000000000100;
			4'b0011: output_from_decoder <= 16'b0000000000001000;
			4'b0100: output_from_decoder <= 16'b0000000000010000;
			4'b0101: output_from_decoder <= 16'b0000000000100000;
			4'b0110: output_from_decoder <= 16'b0000000001000000;
			4'b0111: output_from_decoder <= 16'b0000000010000000;
			4'b1000: output_from_decoder <= 16'b0000000100000000;
			4'b1001: output_from_decoder <= 16'b0000001000000000;
			4'b1010: output_from_decoder <= 16'b0000010000000000;
			4'b1011: output_from_decoder <= 16'b0000100000000000;
			4'b1100: output_from_decoder <= 16'b0001000000000000;
			4'b1101: output_from_decoder <= 16'b0010000000000000;
			4'b1110: output_from_decoder <= 16'b0100000000000000;
			4'b1111: output_from_decoder <= 16'b1000000000000000;
			default: output_from_decoder <= 16'b0000000000000000;
	  endcase
	end
  
  
  //Get the R15in-R0in signals, by anding R15...R0 with Rin.
  //Rin needs to be 16 1's
	always @(*)
	begin
		case(output_from_decoder) //based on what the decoder selected
			16'b0000000000000001: R_enable <= 16'b0000000000000001 & (Rin ? 16'hFFFF: 16'h0000); //R0
			16'b0000000000000010: R_enable <= 16'b0000000000000010 & (Rin ? 16'hFFFF: 16'h0000); //R1
			16'b0000000000000100: R_enable <= 16'b0000000000000100 & (Rin ? 16'hFFFF: 16'h0000); //R2
			16'b0000000000001000: R_enable <= 16'b0000000000001000 & (Rin ? 16'hFFFF: 16'h0000); //R3
			16'b0000000000010000: R_enable <= 16'b0000000000010000 & (Rin ? 16'hFFFF: 16'h0000); //R4
			16'b0000000000100000: R_enable <= 16'b0000000000100000 & (Rin ? 16'hFFFF: 16'h0000); //R4
			16'b0000000001000000: R_enable <= 16'b0000000001000000 & (Rin ? 16'hFFFF: 16'h0000); //R6
			16'b0000000010000000: R_enable <= 16'b0000000010000000 & (Rin ? 16'hFFFF: 16'h0000); //R7
			16'b0000000100000000: R_enable <= 16'b0000000100000000 & (Rin ? 16'hFFFF: 16'h0000); //R8
			16'b0000001000000000: R_enable <= 16'b0000001000000000 & (Rin ? 16'hFFFF: 16'h0000); //R9
			16'b0000010000000000: R_enable <= 16'b0000010000000000 & (Rin ? 16'hFFFF: 16'h0000); //R10
			16'b0000100000000000: R_enable <= 16'b0000100000000000 & (Rin ? 16'hFFFF: 16'h0000); //R11
			16'b0001000000000000: R_enable <= 16'b0001000000000000 & (Rin ? 16'hFFFF: 16'h0000); //R12
			16'b0010000000000000: R_enable <= 16'b0010000000000000 & (Rin ? 16'hFFFF: 16'h0000); //R13
			16'b0100000000000000: R_enable <= 16'b0100000000000000 & (Rin ? 16'hFFFF: 16'h0000); //R14
			16'b1000000000000000: R_enable <= 16'b1000000000000000 & (Rin ? 16'hFFFF: 16'h0000); //R15
			default:R_enable <=  16'b0000000000000000;
	  endcase
	end
	
	always @(*)
	begin
		case(output_from_decoder) //based on what the decoder selected
			16'b0000000000000001: R_out <= 16'b0000000000000001 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R0
			16'b0000000000000010: R_out <= 16'b0000000000000010 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R1
			16'b0000000000000100: R_out <= 16'b0000000000000100 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R2
			16'b0000000000001000: R_out <= 16'b0000000000001000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R3
			16'b0000000000010000: R_out <= 16'b0000000000010000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R4
			16'b0000000000100000: R_out <= 16'b0000000000100000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R4
			16'b0000000001000000: R_out <= 16'b0000000001000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R6
			16'b0000000010000000: R_out <= 16'b0000000010000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R7
			16'b0000000100000000: R_out <= 16'b0000000100000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R8
			16'b0000001000000000: R_out <= 16'b0000001000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R9
			16'b0000010000000000: R_out <= 16'b0000010000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R10
			16'b0000100000000000: R_out <= 16'b0000100000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R11
			16'b0001000000000000: R_out <= 16'b0001000000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R12
			16'b0010000000000000: R_out <= 16'b0010000000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R13
			16'b0100000000000000: R_out <= 16'b0100000000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R14
			16'b1000000000000000: R_out <= 16'b1000000000000000 & (BAout_or_Rout ? 16'hFFFF: 16'h0000); //R15
			default:R_enable <=  16'b0000000000000000;
	  endcase
	end
	
	//C sign extend
	always @(IR)
	begin
		Const_sign_extend_out = $signed(IR[18:0]);
	end
endmodule

