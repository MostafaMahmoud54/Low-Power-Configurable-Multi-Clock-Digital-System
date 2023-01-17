module Start_Checker(
	input  wire    strt_chk_en,
    input  wire    sampled_bit_sc,
    output reg     strt_glitch_sc       
);

always@(*)
begin
    if(strt_chk_en)
        begin
            if(sampled_bit_sc == 1'b0)
                begin
                    strt_glitch_sc = 1'b0;
                end
            else
                begin
                    strt_glitch_sc = 1'b1;
                end
        end
    else
        begin
            strt_glitch_sc = 1'b0;   
        end
end

endmodule : Start_Checker
