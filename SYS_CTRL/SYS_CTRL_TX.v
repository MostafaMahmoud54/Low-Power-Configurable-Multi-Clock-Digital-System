module SYS_CTRL_TX(
	input  wire            CLK,
	input  wire            RST,
	input  wire    [15:0]  ALU_OUT,
	input  wire            OUT_Valid,
	input  wire    [7:0]   RdData,
	input  wire            RdData_Valid,
	input  wire            Busy,
	output reg     [7:0]   TX_P_DATA,
	output reg             TX_D_VLD,
	output reg             clk_div_en
);
	
	localparam Idle         =3'b000,
	           RF_sending   =3'b001,
	           ALU_sending_1=3'b010,
	           ALU_BUSY     =3'b011,
	           ALU_sending_2=3'b100,
	           ALU_BUSY2    =3'b101,
	           RF_BUSY      =3'b110;
	           
reg [2:0] Next_state,Curr_state;

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

always@(*)
begin
    clk_div_en = 1'b1;
    TX_D_VLD   = 1'b0;
    case(Curr_state)
        Idle:
            begin
            clk_div_en = 1'b0;    
            if(RdData_Valid == 1'b1 && !Busy)
                begin
                    Next_state = RF_sending;
                end
            else if(OUT_Valid == 1'b1 && !Busy)
                begin
                    Next_state = ALU_sending_1;
                end
            else
                begin
                    Next_state = Idle;
                end
            end

        RF_sending:
            begin
                TX_P_DATA  = RdData;
                TX_D_VLD   = 1'b1;
                if(Busy)
                    begin
                        Next_state = RF_BUSY;
                    end
                else
                    begin
                        Next_state = RF_sending;
                    end
            end
            
        RF_BUSY:
            begin
                if(Busy)
                    begin
                        Next_state = RF_BUSY;
                    end
                else
                    begin
                        Next_state = Idle;
                    end
            end
        
        ALU_sending_1:
            begin
                TX_P_DATA  = ALU_OUT[7:0];
                TX_D_VLD   = 1'b1 ;
                if(Busy)
                    begin
                        Next_state = ALU_BUSY;
                    end
                else
                    begin
                        Next_state = ALU_sending_1;
                    end
            end
            
        ALU_BUSY:
            begin
                TX_P_DATA  = ALU_OUT[7:0];
                if(Busy)
                    begin
                        Next_state = ALU_BUSY;
                    end
                else
                    begin
                        Next_state = ALU_sending_2;
                    end
            end
    
        ALU_sending_2:
            begin
                TX_P_DATA  = ALU_OUT[15:8];
                TX_D_VLD   = 1'b1;
                if(Busy)
                    begin
                       Next_state = ALU_BUSY2; 
                   end
               else
                   begin
                       Next_state = ALU_sending_2;
                    end
            end
        
        ALU_BUSY2:
            begin
                TX_P_DATA  = ALU_OUT[15:8];
                if(Busy)
                    begin
                        Next_state = ALU_BUSY2;
                    end
                else
                    begin
                        Next_state = Idle;
                    end
            end
            
        default:
            begin
                clk_div_en = 1'b1;
                TX_D_VLD   = 1'b0;
                TX_P_DATA  = 8'b0;
            end
    endcase
    
end

endmodule
