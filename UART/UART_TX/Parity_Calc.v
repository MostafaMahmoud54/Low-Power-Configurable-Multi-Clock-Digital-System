module Parity_Calc(
    input  wire         CLK,
    input  wire         RST,
	input  wire  [7:0]  P_Data,
	input  wire         Data_Valid,
	input  wire         PAR_TYP,
	output reg          par_bit
);
	
reg par_bit_reg;

always@(*)
begin
    if(PAR_TYP)
        begin
            par_bit_reg=^P_Data?1'b0:1'b1;
        end
    else
        begin
            par_bit_reg=^P_Data?1'b1:1'b0;
        end
end

always@(posedge CLK)
begin
    if(~RST)
        begin
            par_bit <= 1'b0;
        end
    else if(Data_Valid)
        begin
            par_bit <= par_bit_reg;
        end
end
endmodule : Parity_Calc
