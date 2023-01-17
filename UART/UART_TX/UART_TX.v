module UART_TX(
	input  wire            CLK,
	input  wire            RST,
	input  wire            DATA_VALID,
	input  wire            PAR_EN,
	input  wire            PAR_TYP,
	input  wire    [7:0]   P_DATA,
	output wire            TX_OUT,
	output wire            BUSY
);

wire        Ser_en_int;
wire        Ser_done_int;
wire        Ser_data_int;
wire [1:0]  Mux_sel_int;
wire        par_bit_int;

Serializer Serializer_instance (
    .CLK(CLK),
    .RST(RST),
    .Data_Valid(DATA_VALID),
    .P_Data(P_DATA),
    .ser_en(Ser_en_int),
    .ser_data(Ser_data_int),
    .ser_done(Ser_done_int)
);	

FSM FSM_instance (
    .CLK(CLK),
    .RST(RST),
    .PAR_EN(PAR_EN),
    .Data_Valid(DATA_VALID),
    .ser_done(Ser_done_int),
    .ser_en(Ser_en_int),
    .mux_sel(Mux_sel_int),
    .busy(BUSY)
);

Parity_Calc Parity_Calc_instance (
    .CLK(CLK),
    .RST(RST),
    .P_Data(P_DATA),
    .Data_Valid(DATA_VALID),
    .PAR_TYP(PAR_TYP),
    .par_bit(par_bit_int)
);

MUX MUX_instance (
    .mux_sel(Mux_sel_int),
    .par_bit(par_bit_int),
    .ser_data(Ser_data_int),
    .CLK(CLK),
    .RST(RST),
    .TX_out(TX_OUT)
);
endmodule : UART_TX
