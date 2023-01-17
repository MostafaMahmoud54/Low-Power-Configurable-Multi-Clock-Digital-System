module CLK_GATING(
	input  wire    CLK,
	input  wire    CLK_EN,
	output reg     GATED_CLK
);
	
reg Enable;

always@(! CLK)	
begin
    Enable <= CLK_EN;
end

always@(*)
begin
    GATED_CLK = Enable & CLK;    
end

endmodule