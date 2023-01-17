module SYS_TOP #(parameter width=8,RegNo=16,Parity_Enable=1,Parity_Type=0,Prescale=8,Div_Ratio=8,NUM_STAGES=2)
(
	input  wire    REF_CLK,
	input  wire    UART_CLK,
	input  wire    RST,
	input  wire    RX_IN,
	output  wire    TX_OUT
);
	
wire     [7:0]   OP_A,OP_B;
wire     [7:0]   DIV_RATIO;	
wire             WrEn,RdEn;
wire     [3:0]   Address;
wire     [7:0]   WrData,RdData;
wire             RdData_Valid;
wire     [15:0]  ALU_OUT;
wire     [3:0]   ALU_FUN;
wire             OUT_VALID,EN;
wire             ALU_CLK;
wire     [7:0]   UART_CONFIG;
wire             SYNC_RST_1,SYNC_RST_2;
wire             TX_CLK,TX_DATA_VALID;
wire             clk_div_en;
wire     [7:0]   TX_DATA;
wire             TX_D_VLD;
wire     [7:0]   RX_P_Data,RX_DATA;
wire             RX_DATA_VALID;
wire             BUSY,BUSY_SYNC,RX_D_VLD;
wire             CLK_EN;
wire     [7:0]   TX_P_DATA;    

SYS_CTRL SYS_CTRL_instance (
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .RX_P_DATA(RX_DATA),
    .RX_D_VLD(RX_D_VLD),
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(OUT_VALID),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .Busy(BUSY_SYNC),
    .ALU_FUN(ALU_FUN),
    .EN(EN),
    .CLK_EN(CLK_EN),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .Address(Address),
    .WrData(WrData),
    .TX_DATA(TX_DATA),
    .TX_D_VLD(TX_D_VLD),
    .clk_div_en(clk_div_en)
);

ALU_TOP #(
    .width(width)
) ALU_TOP_instance (
    .A(OP_A),
    .B(OP_B),
    .ALU_FUN(ALU_FUN),
    .CLK(ALU_CLK),
    .RST(SYNC_RST_1),
    .EN(EN),
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(OUT_VALID)
);

RegFile #(
    .width(width),
    .RegNo(RegNo),
    .Parity_Enable(Parity_Enable),
    .Parity_Type(Parity_Type),
    .Prescale(Prescale),
    .Div_Ratio(Div_Ratio)
) RegFile_instance (
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .WrData(WrData),
    .Address(Address),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .RdData_Valid(RdData_Valid),
    .RdData(RdData),
    .REG0(OP_A),
    .REG1(OP_B),
    .REG2(UART_CONFIG),
    .REG3(DIV_RATIO)
);

UART UART_instance (
    .TX_CLK(TX_CLK),
    .RX_CLK(UART_CLK),
    .RST(SYNC_RST_2),
    .RX_IN(RX_IN),
    .UART_CONFIG(UART_CONFIG),
    .TX_DATA_VALID(TX_DATA_VALID),
    .TX_P_DATA(TX_P_DATA),
    .TX_OUT(TX_OUT),
    .RX_P_Data(RX_P_Data),
    .RX_DATA_VALID(RX_DATA_VALID),
    .BUSY(BUSY)
);
/*------------TX Data Sync-----------*/
DATA_SYNC #(
    .BUS_WIDTH(width),
    .NUM_STAGES(NUM_STAGES)
) DATA_SYNC_TX_instance (
    .CLK(UART_CLK),
    .RST(SYNC_RST_2),
    .bus_enable(TX_D_VLD),
    .unsync_bus(TX_DATA),
    .sync_bus(TX_P_DATA),
    .enable_pulse_d()
);

BIT_SYNC #(
    .BUS_WIDTH(1),
    .NUM_STAGES(NUM_STAGES)
) BIT_SYNC_TX_instance (
    .CLK(TX_CLK),
    .RST_n(SYNC_RST_2),
    .ASYNC(TX_D_VLD),
    .SYNC(TX_DATA_VALID)
);

/*------------RX Data Sync-----------*/
DATA_SYNC #(
    .BUS_WIDTH(width),
    .NUM_STAGES(NUM_STAGES)
) DATA_SYNC_RX_instance (
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .bus_enable(RX_DATA_VALID),
    .unsync_bus(RX_P_Data),
    .sync_bus(RX_DATA),
    .enable_pulse_d()
);

BIT_SYNC #(
    .BUS_WIDTH(1),
    .NUM_STAGES(NUM_STAGES)
) BIT_SYNC_RX_instance (
    .CLK(REF_CLK),
    .RST_n(SYNC_RST_1),
    .ASYNC(RX_DATA_VALID),
    .SYNC(RX_D_VLD)
);

ClkDiv ClkDiv_instance (
    .i_ref_clk(UART_CLK),
    .i_clk_en(clk_div_en),
    .i_rst_n(SYNC_RST_2),
    .i_div_ratio(DIV_RATIO[4:0]),
    .o_div_clk(TX_CLK)
);

CLK_GATING CLK_GATING_instance (
    .CLK(REF_CLK),
    .CLK_EN(CLK_EN),
    .GATED_CLK(ALU_CLK)
);

RST_SYNC #(
    .NUM_STAGES(2)
) RST_SYNC_1_instance (
    .CLK(REF_CLK),
    .RST_n(RST),
    .SYNC_RST(SYNC_RST_1)
);

RST_SYNC #(
    .NUM_STAGES(2)
) RST_SYNC_2_instance (
    .CLK(UART_CLK),
    .RST_n(RST),
    .SYNC_RST(SYNC_RST_2)
);

BIT_SYNC #(
    .BUS_WIDTH(1),
    .NUM_STAGES(NUM_STAGES)
) BIT_SYNC_instance (
    .CLK(REF_CLK),
    .RST_n(SYNC_RST_1),
    .ASYNC(BUSY),
    .SYNC(BUSY_SYNC)
);
endmodule
