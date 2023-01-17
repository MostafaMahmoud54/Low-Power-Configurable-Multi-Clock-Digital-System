module parity_check(
	input  wire    [7:0]   P_DATA_pc,
	input  wire            PAR_TYP,
	input  wire            par_chk_en,
	input  wire            sampled_bit_pc,
	output reg             par_err
);
reg par_bit_reg;

always@(*)
begin
    if(PAR_TYP)
        begin
            par_bit_reg = ^P_DATA_pc;
        end
    else
        begin
            par_bit_reg = ~^P_DATA_pc;
        end
end

always@(*)
begin
    if(par_chk_en && par_bit_reg==sampled_bit_pc)
        begin
            par_err = 1'b1;
        end
    else
        begin
            par_err = 1'b0;
        end
end

endmodule : parity_check
