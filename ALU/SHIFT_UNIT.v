module SHIFT_UNIT #(parameter width=8)
(
    input       [width-1:0]   A,
    input       [width-1:0]   B,
    input       [1:0]         ALU_FUN,
    input                     CLK,
    input                     RST_n,
    input                     Shift_Enable,
    output reg  [width-1:0]   SHIFT_OUT,
    output reg                SHIFT_FLag
);

//internal signals
reg [width-1:0] SHIFT_OUT_reg;
reg             SHIFT_FLag_reg;

always @(*)
begin
    SHIFT_FLag_reg=1'b0;
    if(Shift_Enable)
        begin
            SHIFT_FLag_reg=1'b1;
            case(ALU_FUN)
                2'b00:
                    SHIFT_OUT_reg = A>>1;
                2'b01:
                    SHIFT_OUT_reg = A<<1;
                2'b10:
                    SHIFT_OUT_reg = B>>1;
                2'b11:
                    SHIFT_OUT_reg = B<<1;
                default: 
                    SHIFT_OUT_reg ='b0;
            endcase

        end
    else 
        begin
            SHIFT_FLag=1'b0;
            SHIFT_OUT_reg='b0;
        end
end

always @(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
        begin
            SHIFT_OUT  <= 'b0;
            SHIFT_FLag <= 1'b0;
        end
    else 
        begin
            SHIFT_OUT  <= SHIFT_OUT_reg;
            SHIFT_FLag <= SHIFT_FLag_reg;
        end
end
endmodule