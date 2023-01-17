module edge_bit_counter(
	input  wire            CLK,
	input  wire            RST,
	input  wire            enable,
	output reg     [3:0]   bit_cnt,
	output reg     [2:0]   edge_cnt
);

always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
           bit_cnt  <= 4'b0000; 
           edge_cnt <= 3'b000;
       end
   else if(enable)
       begin
            edge_cnt <= edge_cnt+3'b001;
            if(edge_cnt == 3'b111)
                begin
                    bit_cnt  <= bit_cnt+4'b0001;
                    if(bit_cnt == 4'd11)
                        begin
                            bit_cnt <= 4'b0000;
                        end
                end
        end
    else
        begin
            bit_cnt <= 4'b0000;
        end
    
end

endmodule : edge_bit_counter
