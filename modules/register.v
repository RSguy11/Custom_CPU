module register(
	input clear, clock, enable, BAout,
	input [31:0]BusMuxOut,
	
	output wire [31:0]BusMuxIn
);
reg [31:0]q;
initial q = 32'b0;
always @ (posedge clock)
		begin 
			if (clear) begin
				q <= {32{1'b0}};
			end
			else if (enable) begin
				q <= BusMuxOut;
			end
			
			
			if(BAout) begin
				q<= 32'b0;
			end
		
		
		end

	
	assign BusMuxIn = q[31:0];
endmodule

**************EDITED*****************

