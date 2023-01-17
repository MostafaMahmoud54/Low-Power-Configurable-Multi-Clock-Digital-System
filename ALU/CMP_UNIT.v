module CMP_UNIT #(parameter width=8,CMP_width=3)
(
    input       [width-1:0]   A,
    input       [width-1:0]   B,
    input       [1:0]         ALU_FUN,
    input                     CLK,
    input                     RST_n,
    input                     CMP_Enable,
    output reg  [width-1:0] CMP_OUT,
    output reg                CMP_FLag
);

//internal signals
reg [width-1:0] CMP_OUT_reg;
reg             CMP_FLag_reg;

always@(*)
begin
    CMP_FLag_reg=1'b0;
    if(CMP_Enable)
        begin
            CMP_FLag_reg=1'b1;
            case(ALU_FUN)
                2'b00:
                   CMP_OUT_reg='b0;
                2'b01:
                    if(A == B)
                        begin
                            CMP_OUT_reg='b1;
                        end
                    else 
                        begin
                            CMP_OUT_reg='b0;
                        end
                2'b10:
                    if(A > B)
                        begin
                            CMP_OUT_reg='b10;
                        end
                    else 
                        begin
                            CMP_OUT_reg='b0;
                        end
                2'b11:
                    if(A < B)
                        begin
                            CMP_OUT_reg='b11;
                        end
                    else 
                        begin
                            CMP_OUT_reg='b0;
                        end
                default:
                    CMP_OUT_reg='b0;

        endcase
    end
    else 
        begin
            CMP_FLag_reg=1'b0;
            CMP_OUT_reg='b0;
        end
end

always @(posedge CLK,negedge RST_n)
begin
    if(!RST_n)
        begin
            CMP_OUT  <=  'b0;
            CMP_FLag <= 1'b0;
        end
    else 
        begin
            CMP_OUT  <= CMP_OUT_reg;
            CMP_FLag <= CMP_FLag_reg;

        end

end

endmodule