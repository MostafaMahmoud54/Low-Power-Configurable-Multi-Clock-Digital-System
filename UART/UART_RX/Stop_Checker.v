module Stop_Checker(
	input  wire    stp_chk_en,
    input  wire    sampled_bit_sc,
    output reg     stp_err    
);
	
always@(*)
begin
    if(stp_chk_en)
        begin
            if(sampled_bit_sc == 1'b1)
                begin
                    stp_err = 1'b0;
                end
            else
                begin
                    stp_err = 1'b1;
                end
        end
    else
        begin
            stp_err = 1'b0;
        end
end
endmodule : Stop_Checker
