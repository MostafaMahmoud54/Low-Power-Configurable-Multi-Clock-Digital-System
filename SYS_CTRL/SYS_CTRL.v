module SYS_CTRL(
	input  wire             CLK,
    input  wire             RST,
    input  wire     [7:0]   RX_P_DATA,
    input  wire             RX_D_VLD,
    input  wire     [15:0]  ALU_OUT,
    input  wire             OUT_VALID,
    input  wire     [7:0]   RdData,
    input  wire             RdData_Valid,
    input  wire             Busy,
    output wire     [3:0]   ALU_FUN,
    output wire             EN,
    output wire             CLK_EN,
    output wire             WrEn,
    output wire             RdEn,
    output wire     [3:0]   Address,
    output wire     [7:0]   WrData,
    output wire     [7:0]   TX_DATA,
    output wire             TX_D_VLD,
    output wire             clk_div_en
);
	
	
SYS_CTRL_RX SYS_CTRL_RX_instance (
    .CLK(CLK),
    .RST(RST),
    .RX_P_DATA(RX_P_DATA),
    .RX_D_VLD(RX_D_VLD),
    .ALU_FUN(ALU_FUN),
    .EN(EN),
    .CLK_EN(CLK_EN),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .Address(Address),
    .WrData(WrData),
    .ALU_OUT_VALID(OUT_VALID)
);

SYS_CTRL_TX SYS_CTRL_TX_instance (
    .CLK(CLK),
    .RST(RST),
    .ALU_OUT(ALU_OUT),
    .OUT_Valid(OUT_VALID),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .Busy(Busy),
    .TX_P_DATA(TX_DATA),
    .TX_D_VLD(TX_D_VLD),
    .clk_div_en(clk_div_en)
);
endmodule
