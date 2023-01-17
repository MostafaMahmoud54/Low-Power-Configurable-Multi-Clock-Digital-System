module ClkDiv(
	input                  i_ref_clk,
	input                  i_clk_en,
	input                  i_rst_n,
	input          [4:0]   i_div_ratio,
	output  reg            o_div_clk
);

integer counter;
reg [4:0] ratio;
reg odd_flag;
reg flag;
reg o_div_clk_reg;


always @(*)
begin
    ratio = i_div_ratio>>1;
    flag <= 1;
    odd_flag = i_div_ratio;
end

always@(*)
begin
    if(i_div_ratio!=0 && i_div_ratio!=1 && i_clk_en)
        begin
            o_div_clk = o_div_clk_reg;
        end
    else
        begin
            o_div_clk = i_ref_clk;
        end
end

always @(posedge i_ref_clk, negedge i_rst_n)
begin
    counter <= counter+1;
            if(!i_rst_n)
                begin
                    o_div_clk_reg <= 1'b0;
                    counter <= 1;
                end
            else if ((counter == ratio && flag) || (counter == ratio+1 && odd_flag))
                begin
                    o_div_clk_reg <= ~o_div_clk_reg;
                    if(counter == ratio+1 && odd_flag)
                        begin
                            counter <= 1;
                            flag<=1;
                        end
                    else if(odd_flag)
                        begin
                            flag<=0;
                            counter <= 1;
                        end
                    else
                        begin
                            flag<=1;
                            counter <= 1;
                        end
                end
     
    
end
endmodule
