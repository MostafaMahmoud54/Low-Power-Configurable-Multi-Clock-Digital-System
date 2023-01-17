module SYS_CTRL_RX(
	input  wire            CLK,
	input  wire            RST,
	input  wire    [7:0]   RX_P_DATA,
	input  wire            RX_D_VLD,
	input  wire            ALU_OUT_VALID,
	output reg     [3:0]   ALU_FUN,
	output reg             EN,
	output reg             CLK_EN,
	output reg             WrEn,
	output reg             RdEn,
	output reg     [3:0]   Address,
	output reg     [7:0]   WrData
);
	localparam Idle              = 4'b0000, 
	           RF_Wr_CMD         = 4'b0001, //Register File Write command
	           RF_Wr_Addr        = 4'b0010,
	           RF_Wr_Data        = 4'b0011,
	           RF_Rd_CMD         = 4'b0100, //Register File read command
	           RF_Rd_Addr        = 4'b0101,
	           ALU_OPER_W_OP_CMD = 4'b0110,
	           Operand_A         = 4'b0111,
	           Operand_B         = 4'b1000,
	           ALU_FUN_state     = 4'b1001,
	           ALU_OPER_W_NOP_CMD= 4'b1010,
	           INT_STATE         = 4'b1011,
	           MID_State_ALU_OP4 = 4'b1100; 
	           
reg [3:0] Curr_state,Next_state,Prev_state;
reg [7:0] Address_reg;

always@(posedge CLK, negedge RST)
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
    ALU_FUN = 4'b0;
    EN      = 1'b0;
    CLK_EN  = 1'b0;
    WrEn    = 1'b0;
    RdEn    = 1'b0;
    Address = 4'b0;
    WrData  = 8'b0;
    case(Curr_state)
        Idle:
            begin
            if(RX_D_VLD == 1'b1 && RX_P_DATA == 0'hAA)
                begin
                    Next_state = RF_Wr_CMD;
                end
            else if(RX_D_VLD == 1'b1 && RX_P_DATA == 0'hBB)
                begin
                    Next_state = RF_Rd_CMD;
                end
            else if(RX_D_VLD == 1'b1 && RX_P_DATA == 0'hCC)
                begin
                    Next_state = ALU_OPER_W_OP_CMD;
                end
            else if(RX_D_VLD == 1'b1 && RX_P_DATA == 0'hDD)
                begin
                    Next_state = ALU_OPER_W_NOP_CMD;
                end
            else
                begin
                    Next_state = Idle; 
                end
            end
            
        RF_Wr_CMD:
            begin
            Prev_state = RF_Wr_CMD;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = RF_Wr_CMD;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        RF_Wr_Addr:
            begin
            Prev_state = RF_Wr_Addr;
            Address_reg=RX_P_DATA;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = RF_Wr_Addr;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        RF_Wr_Data:
            begin
                WrEn = 1'b1;
                Address = Address_reg;
                WrData  = RX_P_DATA;
                Next_state = Idle;
            end
            
        RF_Rd_CMD:
            begin
            Prev_state = RF_Rd_CMD;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = RF_Rd_CMD;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        RF_Rd_Addr:
            begin
                Address = RX_P_DATA;
                RdEn = 1'b1;
                Next_state = Idle;
            end
            
        //ALU Operation command with operand 
        ALU_OPER_W_OP_CMD:
            begin
            Prev_state = ALU_OPER_W_OP_CMD;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = ALU_OPER_W_OP_CMD;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        Operand_A:
            begin
                Prev_state = Operand_A;
                WrEn    = 1;
                Address = 0'h00;
                WrData  = RX_P_DATA;
            Prev_state  = Operand_A;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = Operand_A;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        Operand_B:
            begin
                Prev_state = Operand_B;
                WrEn    = 1;
                Address = 0'h01;
                WrData  = RX_P_DATA;
                CLK_EN  = 1'b1;
            if(RX_D_VLD == 1'b1)
                begin
                    Next_state = Operand_B;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
            end
            
        ALU_FUN_state:
            begin
                Next_state = Idle;
                ALU_FUN    = RX_P_DATA[3:0];
                CLK_EN     = 1'b1;
                EN         = 1'b1;
            end
            
        //ALU Operation command with No operand
        ALU_OPER_W_NOP_CMD:
            begin
                Prev_state = ALU_OPER_W_NOP_CMD;
                CLK_EN = 1;
                if(RX_D_VLD == 1'b1)
                begin
                    Next_state = ALU_OPER_W_NOP_CMD;
                end
            else
                begin
                    Next_state = INT_STATE;
                end   
            end
            
        INT_STATE:
            begin
            if(RX_D_VLD == 1'b1 && Prev_state == RF_Wr_CMD)
                begin
                    Next_state = RF_Wr_Addr;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == RF_Wr_Addr)
                begin
                    Next_state = RF_Wr_Data;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == RF_Rd_CMD)
                begin
                    Next_state = RF_Rd_Addr;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == ALU_OPER_W_OP_CMD)
                begin
                    Next_state = Operand_A;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == Operand_A)
                begin
                    Next_state = Operand_B;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == Operand_B)
                begin
                    Next_state = ALU_FUN_state;
                end
            else if (RX_D_VLD == 1'b1 && Prev_state == ALU_OPER_W_NOP_CMD)
                begin
                    Next_state = ALU_FUN_state;
                end
            else
                begin
                    Next_state = INT_STATE;
                end
                  
            end
            
        default:    
            begin
               ALU_FUN = 4'b0;
               EN      = 1'b0;
               CLK_EN  = 1'b0;
               WrEn    = 1'b0;
               RdEn    = 1'b0;
               Address = 4'b0;
               WrData  = 8'b0;
            end
    endcase
end

endmodule
