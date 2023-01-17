module UART(
	input  wire            TX_CLK,
	input  wire            RX_CLK,
	input  wire            RST,
	input  wire            RX_IN,
	input  wire    [7:0]   UART_CONFIG,
	input  wire            TX_DATA_VALID,
	input  wire    [7:0]   TX_P_DATA,
	output wire            TX_OUT,
	output wire    [7:0]   RX_P_Data,
	output wire            RX_DATA_VALID,
	output wire            BUSY    
);

UART_RX UART_RX_instance (
    .CLK(RX_CLK),
    .RST(RST),
    .PAR_EN(UART_CONFIG[0]),
    .PAR_TYP(UART_CONFIG[1]),
    .RX_IN(RX_IN),
    .Prescale(UART_CONFIG[5:2]),
    .data_valid(RX_DATA_VALID),
    .P_Data(RX_P_Data)
);


UART_TX UART_TX_instance (
    .CLK(TX_CLK),
    .RST(RST),
    .DATA_VALID(TX_DATA_VALID),
    .PAR_EN(UART_CONFIG[0]),
    .PAR_TYP(UART_CONFIG[1]),
    .P_DATA(TX_P_DATA),
    .TX_OUT(TX_OUT),
    .BUSY(BUSY)
);
endmodule
