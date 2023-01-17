module data_sampling(
	input  wire            CLK,
	input  wire            RST,
	input  wire            RX_IN,
	input  wire    [3:0]   Prescale,
	input  wire            dat_samp_en,
	input  wire    [2:0]   edge_cnt,
	output reg             sampled_bit
);

reg [2:0] sampling_edge; 
reg [2:0] sample;

always@(*)
begin
    sampling_edge = Prescale>>2;
end

always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
            sampled_bit <= 1'b0; 
        end
    else if(dat_samp_en &&  edge_cnt == sampling_edge-1)
        begin
            sample[0] <= RX_IN;
        end
    else if(dat_samp_en &&  edge_cnt == sampling_edge)
        begin
            sample[1] <= RX_IN;
        end
    else if(dat_samp_en &&  edge_cnt == sampling_edge+1)
        begin
            sample[2] <= RX_IN;
        end
end

always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
            sampled_bit = 1'b0;
        end
    else if(edge_cnt == 3'd6)
        begin
            sampled_bit = sample[2]&sample[1] | sample[2]&sample[0] | sample[1]&sample[0];
        end
end

endmodule : data_sampling
