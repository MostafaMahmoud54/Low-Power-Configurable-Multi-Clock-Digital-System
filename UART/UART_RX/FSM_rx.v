module FSM_rx(
	input  wire             CLK,
	input  wire             RST,
	input  wire             RX_IN_fsm,
	input  wire             PAR_EN_fsm,
	input  wire    [2:0]    edge_cnt_fsm,
	input  wire    [3:0]    bit_cnt_fsm,
	input  wire             par_err_fsm,
	input  wire             strt_glitch_fsm,
	input  wire             stp_err_fsm,
	output reg              dat_sampl_en_fsm,
	output reg              enable_fsm,
	output reg              deser_en_fsm,
	output reg              data_valid_fsm,
	output reg              stp_chk_en_fsm,
	output reg              str_chk_en_fsm,
	output reg              par_chk_en_fsm
);

localparam Idle  =3'b000,
           Start =3'b001,
           Stop  =3'b011,
           Data  =3'b010,
           Parity=3'b110,
           Valid =3'b111;

reg [2:0]  Curr_state,Next_state;
reg data_valid_reg;

always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
            Curr_state <= Idle;
        end
    else
        begin
            Curr_state <= Next_state;
        end
end

always@(posedge CLK,negedge RST)
begin
    if(!RST)
        begin
            data_valid_fsm <= 0;
        end
    else
        begin
            data_valid_fsm <= data_valid_reg;
        end
end

always@(*)
begin
    dat_sampl_en_fsm = 1'b0;
    enable_fsm = 1'b0;
    deser_en_fsm = 1'b0;
    data_valid_reg = 1'b0;
    stp_chk_en_fsm = 1'b0;
    str_chk_en_fsm = 1'b0;
    par_chk_en_fsm = 1'b0;
    
    case (Curr_state)
        Idle:begin
            if(!RX_IN_fsm)
                begin
                    Next_state = Start;
                end
            else
                begin
                    Next_state = Idle;
                end
            end
            
        Start:begin
            str_chk_en_fsm = 1'b1;
            dat_sampl_en_fsm = 1'b1;
            enable_fsm = 1'b1;
            if(!strt_glitch_fsm && bit_cnt_fsm==4'b0001)
                begin
                    Next_state = Data;
                end
            else if(strt_glitch_fsm && bit_cnt_fsm==4'b0001)
                begin
                    Next_state = Idle;
                end
            else
                begin
                    Next_state = Start;
                end
            end
            
        Data:begin
            deser_en_fsm = 1'b1;
            dat_sampl_en_fsm = 1'b1;
            enable_fsm = 1'b1;
            if(bit_cnt_fsm == 4'b1001)
                begin
                    if(PAR_EN_fsm)
                        begin
                            Next_state = Parity;
                        end
                    else
                        begin
                            Next_state = Stop;
                        end
                end
            else
                begin
                   Next_state = Data; 
                end
            end
            
        Parity:begin
                par_chk_en_fsm =1'b1;
                dat_sampl_en_fsm = 1'b1;
                enable_fsm = 1'b1;
                if(bit_cnt_fsm == 4'b1010)
                    begin
                        if(par_err_fsm)
                            begin
                                Next_state = Idle;
                            end
                        else
                            begin
                                Next_state = Stop;
                            end
                    end
                else
                    begin
                        Next_state = Parity;
                    end
                end
            
        Stop:begin
            stp_chk_en_fsm = 1'b1;
            dat_sampl_en_fsm = 1'b1;
            enable_fsm = 1'b1;
            if( (PAR_EN_fsm && bit_cnt_fsm==4'b1011) || (!PAR_EN_fsm && bit_cnt_fsm==4'b1010 ))
                begin
                    if(!stp_err_fsm && !par_err_fsm)
                        begin
                            Next_state = Valid;
                        end
                    else
                        begin
                            Next_state = Idle;
                        end
                end
            else
                begin
                    Next_state = Stop;
                end     
        end
            
        Valid:begin
            Next_state = Idle;
            data_valid_reg = 1'b1;
            end
            
        default:begin
            Next_state = Idle;
            dat_sampl_en_fsm = 1'b0;
            enable_fsm = 1'b0;
            deser_en_fsm = 1'b0;
            data_valid_reg = 1'b0;
            stp_chk_en_fsm = 1'b0;
            str_chk_en_fsm = 1'b0;
            par_chk_en_fsm = 1'b0;
            end
    endcase
end
endmodule : FSM_rx
