module Decoder_2x4
(
    input        [1:0]        ALU_FUN,
    input  wire               Dec_ENABLE,
    output reg                Arith_Enable,
    output reg                Logic_Enable,
    output reg                CMP_Enable,
    output reg                Shift_Enable
);

always @(*)
begin
    Arith_Enable = 1'b0;
    Logic_Enable = 1'b0;
    CMP_Enable   = 1'b0;
    Shift_Enable = 1'b0;
    if(Dec_ENABLE)
        begin
        case (ALU_FUN)
            2'b00: 
                Arith_Enable = 1'b1;
            2'b01:
                Logic_Enable = 1'b1;
            2'b10:
                CMP_Enable   = 1'b1;
            2'b11:
                Shift_Enable = 1'b1;
            default:
                begin
                Arith_Enable = 1'b0;
                Logic_Enable = 1'b0;
                CMP_Enable   = 1'b0;
                Shift_Enable = 1'b0;
                end
    
        endcase
        end
    else
        begin
            Arith_Enable = 1'b0;
            Logic_Enable = 1'b0;
            CMP_Enable   = 1'b0;
            Shift_Enable = 1'b0;
        end
end
endmodule