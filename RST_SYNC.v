module RST_SYNC #(parameter NUM_STAGES=3)
(
	input      CLK,
	input      RST_n,
	output reg SYNC_RST
);
integer counter;
reg RST_REG[0:NUM_STAGES-1];

always@(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
    begin
        for(counter=0; counter<NUM_STAGES; counter=counter+1)
        begin
            RST_REG[counter] <= 0;
        end
    end
    else
    begin
        for(counter=0; counter<NUM_STAGES; counter=counter+1)
        begin
            if(counter==0)
            begin
                RST_REG[counter] <= 1'b1;
            end
            else
            begin
                RST_REG[counter] <= RST_REG[counter-1];
            end
        end
    end
end
always @(*)
begin
    SYNC_RST = RST_REG[NUM_STAGES-1];
end
endmodule
