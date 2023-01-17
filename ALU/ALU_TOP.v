module ALU_TOP #(parameter width=8)
(
    input   wire        [width-1:0]   A,
    input   wire        [width-1:0]   B,
    input   wire        [3:0]         ALU_FUN,
    input   wire                      CLK,
    input   wire                      RST,
    input   wire                      EN,
    output  reg         [2*width-1:0] ALU_OUT,
    output  reg                       OUT_VALID
);

//internal signals 
wire Arith_Enable_internal;
wire Logic_Enable_internal;
wire CMP_Enable_internal;
wire Shift_Enable_internal;
wire [width-1:0] SHIFT_OUT , CMP_OUT , Logic_OUT , Arith_OUT;
wire Arith_FLag , CMP_FLag , SHIFT_FLag , Logic_FLag;

ARITHMETIC_UNIT U_ARITHMETIC_UNIT(
    .A(A),
    .B(B),
    .CLK(CLK),
    .RST_n(RST),
    .ALU_FUN(ALU_FUN[1:0]),
    .Arith_Enable(Arith_Enable_internal),
    .Arith_OUT(Arith_OUT),
    .Arith_FLag(Arith_FLag)
);

LOGIC_UNIT U_LOGIC_UNIT (
    .A(A),
    .B(B),
    .CLK(CLK),
    .RST_n(RST),
    .ALU_FUN(ALU_FUN[1:0]),
    .Logic_Enable(Logic_Enable_internal),
    .Logic_OUT(Logic_OUT),
    .Logic_FLag(Logic_FLag)
);

CMP_UNIT U_CMP_UNIT (
    .A(A),
    .B(B),
    .CLK(CLK),
    .RST_n(RST),
    .ALU_FUN(ALU_FUN[1:0]),
    .CMP_Enable(CMP_Enable_internal),
    .CMP_OUT(CMP_OUT),
    .CMP_FLag(CMP_FLag)
);

SHIFT_UNIT U_SHIFT_OUT (
    .A(A),
    .B(B),
    .CLK(CLK),
    .RST_n(RST),
    .ALU_FUN(ALU_FUN[1:0]),
    .Shift_Enable(Shift_Enable_internal),
    .SHIFT_OUT(SHIFT_OUT),
    .SHIFT_FLag(SHIFT_FLag)
);

Decoder_2x4 U_Decoder_2x4(
    .Dec_ENABLE(EN),
    .ALU_FUN(ALU_FUN[3:2]),
    .Arith_Enable(Arith_Enable_internal),
    .Logic_Enable(Logic_Enable_internal),
    .CMP_Enable(CMP_Enable_internal),
    .Shift_Enable(Shift_Enable_internal)
);

always@(*)
begin
        ALU_OUT   = SHIFT_OUT  | CMP_OUT  | Logic_OUT  | Arith_OUT;
        OUT_VALID = EN;
end
endmodule