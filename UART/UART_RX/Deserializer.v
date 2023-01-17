module Deserializer(
	input  wire            CLK,
	input  wire            RST,
	input  wire            deser_en,
	input  wire            sampled_bit,
	input  wire    [2:0]   edge_cnt,     
	input  wire    [3:0]   bit_cnt,
	output reg     [7:0]   P_DATA
	
);

reg [7:0] P_DATA_reg;
/*
always@(*)
begin
    if(deser_en)
        begin
            if(edge_cnt==3'd7)
                begin
                    P_DATA_reg = {sampled_bit,P_DATA_reg[7:1]};
                end
            else
                begin
                    P_DATA_reg = P_DATA_reg;
                end
        end
    else
        begin
            P_DATA_reg = 8'b0;
        end
end
*/
always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
            P_DATA <= 8'b0;
        end
    else if(deser_en && edge_cnt==3'd7)
        begin
            P_DATA <= {sampled_bit,P_DATA[7:1]};
        end
    else if(bit_cnt == 4'b0001)
        begin
            P_DATA <= 8'b0;
        end
end

endmodule : Deserializer
