module CON_FF(
	input clear, clock,CONin,
	input [31:0]BusMuxOut,
	input [22:0]IRinput,
	
	output wire [31:0]BusMuxIn
);


//breakdown of bus input

reg [3:0]Ra; //decoder logic
reg [3:0]IR; //C2





reg [31:0]CON;
initial CON = 32'b0;
reg out1;
reg out2;
reg out3;
reg out4;
reg out5;


always @ (posedge clock)
begin

	Ra = BusMuxOut[26:23];
	IR = BusMuxOut[20:19];
	
	if(CONIN == 1) begin
		case(IR)
			2'b00: RA <= 4'b0001;
			2'b01: RA <= 4'b0010;
			2'b10: RA <= 4'b0100;
			2'b11: RA <= 4'b0000;
		endcase
		
	
	 out1 <= ~|BusMuxOut; 
	 
    out2 <= out1 & ~RA[0]; //Branch if 0 (00)
	
	 out3 <= ~out1 & RA[1]; //Branch if  non Zero (01)
			
	 out4 <= ~BusMuxout[31] & RA[2]; //Branch if positive (10)
		
	 out5 <=  BusMuxout[31] & RA[3]; //Branch if negative (11)

    CON = ( out2|out3|out4|out5);// Final OR gate logic to determine the CONin
   end
end
	

endmodule


