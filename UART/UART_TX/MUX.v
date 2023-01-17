module MUX(
	input  wire [1:0] mux_sel,
	input  wire       par_bit,
	input  wire       ser_data,
	input  wire       CLK,
	input  wire       RST,
	output reg        TX_out
);

localparam Start_bit=2'b00,
           Stop_bit=2'b01,
           serdata=2'b10,
           parbit=2'b11;
           
reg MUX_out;

always@(*)
begin
    case(mux_sel)
        Start_bit:begin
            MUX_out = 1'b0;
        end
        Stop_bit:begin
            MUX_out = 1'b1;
        end
        serdata:begin
            MUX_out = ser_data;
        end
        parbit:begin
            MUX_out = par_bit;
        end
        default:begin
            MUX_out = 1'b1;
        end
    endcase
end

always@(posedge CLK)
begin
    if(!RST)
    begin
        TX_out <= 1'b0;
    end
    else
    begin
        TX_out <= MUX_out;
    end
end

endmodule : MUX
