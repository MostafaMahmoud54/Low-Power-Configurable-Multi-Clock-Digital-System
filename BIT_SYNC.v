module BIT_SYNC #(parameter BUS_WIDTH = 1, NUM_STAGES = 2)
(
	input  wire                  CLK,
	input  wire                  RST_n,
	input  wire [BUS_WIDTH-1:0]  ASYNC,
	output reg  [BUS_WIDTH-1:0]  SYNC
);

reg [BUS_WIDTH-1:0] Q [0:NUM_STAGES-1];

integer counter,counter2;
always@(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
    begin
        for(counter=0; counter<NUM_STAGES; counter=counter+1)
        begin
            Q[counter] <= 0;
        end
    end
    else
    begin
        for(counter=0; counter<NUM_STAGES; counter=counter+1)
        begin
            if(counter==0)
            begin
                Q[counter] <= ASYNC;
            end
            else
            begin
                Q[counter] <= Q[counter-1];
            end
        end
    end
end
always @(*)
begin
    SYNC = Q[NUM_STAGES-1];
end
endmodule : BIT_SYNC
