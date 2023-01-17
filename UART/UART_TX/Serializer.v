module Serializer(
	input  wire            CLK,
	input  wire            RST,
	input  wire            Data_Valid,
	input  wire    [7:0]   P_Data,
	input  wire            ser_en,
	output reg             ser_data,
	output reg             ser_done
);
	
reg [7:0]  P_Data_reg;
integer Counter;

/*always@(*)
begin
    if(Data_Valid)
        begin
            P_Data_reg = P_Data;
        end
    else
        begin
            P_Data_reg = P_Data_reg;
        end
end*/

always@(posedge CLK)
begin
    if(~RST)
        begin
            ser_done <= 1'b0;
            Counter <= 0;
        end
    else if(Data_Valid && Counter==0)
        begin
            P_Data_reg <= P_Data;
        end
    if(ser_en)
        begin
            ser_data <= P_Data_reg[Counter];
            Counter <= Counter+1;
            if(Counter==7)
                begin
                    ser_data <= P_Data_reg[Counter];
                    ser_done <= 1'b1;
                    Counter <= 0;
                end
            else
                begin
                    ser_done <= 1'b0;
                end
        end
end
endmodule
