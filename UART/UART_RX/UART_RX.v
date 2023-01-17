module UART_RX(
	input  wire            CLK,
	input  wire            RST,
	input  wire            PAR_EN,
	input  wire            PAR_TYP,
	input  wire            RX_IN,
	input  wire    [3:0]   Prescale,
	output wire            data_valid,
	output wire    [7:0]   P_Data
);

wire        dat_samp_en;
wire        enable;
wire        deser_en;
wire        sampled_bit;
wire        par_chk_en,par_err;
wire        strt_chk_en,strt_glitch;
wire        stp_chk_en,stp_err;
wire [2:0]  edge_cnt;
wire [3:0]  bit_cnt;
	
	
FSM_rx FSM_rx_instance (
    .CLK(CLK),
    .RST(RST),
    .RX_IN_fsm(RX_IN),
    .PAR_EN_fsm(PAR_EN),
    .edge_cnt_fsm(edge_cnt),
    .bit_cnt_fsm(bit_cnt),
    .par_err_fsm(par_err),
    .strt_glitch_fsm(strt_glitch),
    .stp_err_fsm(stp_err),
    .dat_sampl_en_fsm(dat_samp_en),
    .enable_fsm(enable),
    .deser_en_fsm(deser_en),
    .data_valid_fsm(data_valid),
    .stp_chk_en_fsm(stp_chk_en),
    .str_chk_en_fsm(strt_chk_en),
    .par_chk_en_fsm(par_chk_en)
);

edge_bit_counter edge_bit_counter_instance (
    .CLK(CLK),
    .RST(RST),
    .enable(enable),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt)
);

data_sampling data_sampling_instance (
    .CLK(CLK),
    .RST(RST),
    .RX_IN(RX_IN),
    .Prescale(Prescale),
    .dat_samp_en(dat_samp_en),
    .edge_cnt(edge_cnt),
    .sampled_bit(sampled_bit)
);

parity_check parity_check_instance (
    .P_DATA_pc(P_Data),
    .PAR_TYP(PAR_TYP),
    .par_chk_en(par_chk_en),
    .sampled_bit_pc(sampled_bit),
    .par_err(par_err)
);

Start_Checker Start_Checker_instance (
    .strt_chk_en(strt_chk_en),
    .sampled_bit_sc(sampled_bit),
    .strt_glitch_sc(strt_glitch)
);

Stop_Checker Stop_Checker_instance (
    .stp_chk_en(stp_chk_en),
    .sampled_bit_sc(sampled_bit),
    .stp_err(stp_err)
);

Deserializer Deserializer_instance (
    .CLK(CLK),
    .RST(RST),
    .deser_en(deser_en),
    .sampled_bit(sampled_bit),
    .edge_cnt(edge_cnt),
    .bit_cnt(bit_cnt),
    .P_DATA(P_Data)
);
endmodule : UART_RX
