module LOGIC_UNIT #(parameter width=8)
(
    input       [width-1:0]   A,
    input       [width-1:0]   B,
    input       [1:0]         ALU_FUN,
    input                     CLK,
    input                     RST_n,
    input                     Logic_Enable,
    output reg  [width-1:0]   Logic_OUT,
    output reg                Logic_FLag
);

//internal signals
reg [width-1:0] Logic_OUT_reg;
reg             Logic_FLag_reg;

always@(*)
begin
    Logic_FLag_reg=1'b0;
    if(Logic_Enable)
        begin
            Logic_FLag_reg=1'b1;
            case (ALU_FUN)
                2'b00:
                    Logic_OUT_reg =  A & B;
                2'b01:
                    Logic_OUT_reg =  A | B;
                2'b10:
                    Logic_OUT_reg = ~( A & B );
                2'b11:
                    Logic_OUT_reg = ~( A | B );
                default: 
                    Logic_OUT_reg='b0;
            endcase
    end
    else
        begin
            Logic_OUT_reg='b0;
            Logic_FLag_reg=1'b0;
        end

end

always @(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
        begin
            Logic_OUT  <=  'b0;
            Logic_FLag <= 1'b0;
        end
    else 
        begin
            Logic_OUT  <= Logic_OUT_reg;
            Logic_FLag <= Logic_FLag_reg;
        end
end

endmodule