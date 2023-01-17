module FSM
(
    input   wire        CLK,
    input   wire        RST,
    input   wire        PAR_EN,
    input   wire        Data_Valid,
    input   wire        ser_done,
    output  reg         ser_en,
    output  reg [1:0]   mux_sel,
    output  reg         busy      
);

localparam Idle=3'b000,
           Start=3'b001,
           Stop=3'b010,
           Data=3'b011,
           Parity=3'b100;
           
localparam Start_bit=2'b00,
           Stop_bit=2'b01,
           ser_data=2'b10,
           par_bit=2'b11;

reg [2:0] Curr_state,Next_state;
reg busy_reg;

always@(posedge CLK)
begin
    if(~RST)
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
    if(~RST)
        begin
            busy <= 1'b0;
        end
    else
        begin
            busy <= busy_reg;
        end 
end

always@(*)
begin
    busy_reg=1'b0;
    ser_en=1'b0;
    case (Curr_state)
        Idle:begin
                busy_reg=1'd0;
                mux_sel=Stop_bit;
                if(Data_Valid)
                    begin
                        Next_state = Start;
                    end
                else
                    begin
                        Next_state = Idle;
                    end
             end
        Start:begin
                mux_sel=Start_bit;
                busy_reg=1'b1;
                Next_state=Data;
                ser_en=1'b1;
              end
        Data:begin
                mux_sel=ser_data;
                ser_en=1'b1;
                busy_reg=1'b1;
                if(ser_done & PAR_EN)
                    begin
                        Next_state=Parity;
                        ser_en = 1'b0;
                    end
                else if(ser_done & ~PAR_EN)
                    begin
                        Next_state=Stop;
                        ser_en = 1'b0;
                    end
                else
                    begin
                        Next_state=Data;
                    end
             end
        Parity:begin
                mux_sel=par_bit;
                busy_reg=1'b1;
                Next_state=Stop;
               end
        Stop:begin
                mux_sel=Stop_bit;
                busy_reg=1'b1;
                if(Data_Valid)
                    begin
                        Next_state=Start;
                    end
                else
                    begin
                        Next_state=Idle;
                    end
               end
        default:begin
                    busy_reg=1'b0;
                    ser_en=1'b0;
                    mux_sel=Stop_bit;
                end
    endcase
    
end
endmodule