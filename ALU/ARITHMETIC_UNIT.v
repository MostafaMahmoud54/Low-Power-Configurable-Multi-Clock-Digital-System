module ARITHMETIC_UNIT #(parameter width=8)
(
    input       [width-1:0]   A,
    input       [width-1:0]   B,
    input       [1:0]         ALU_FUN,
    input                     CLK,
    input                     RST_n,
    input                     Arith_Enable,
    output reg  [width-1:0]   Arith_OUT,
    output reg                Arith_FLag
);

//internal signals
reg [width-1:0] Arith_OUT_reg;
reg             Arith_FLag_reg;

always @(*)
begin
    Arith_FLag_reg=1'b0;
    if(Arith_Enable)
        begin
            Arith_FLag_reg=1'b1;
            case (ALU_FUN)
                2'b00:
                    Arith_OUT_reg = A + B;
                2'b01:
                    Arith_OUT_reg = A-B;
                2'b10:
                    Arith_OUT_reg = A*B;
                2'b11:
                    Arith_OUT_reg = A/B;
                default: 
                    Arith_OUT_reg = 'b0;
            endcase
        end
    else 
        begin
            Arith_OUT_reg='b0;
            Arith_FLag_reg=1'b0;
        end
end

always @(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
        begin
            Arith_OUT  <= 'b0;
            Arith_FLag <= 1'b0;
        end
    else if(Arith_Enable)
        begin
            Arith_OUT  <= Arith_OUT_reg;
            Arith_FLag <= Arith_FLag_reg;
        end
    else
        begin
            Arith_OUT  <= 'b0;
            Arith_FLag <= 1'b0;
        end
end
endmodule