module RegFile #(parameter width=8,RegNo=16,Parity_Enable=0,Parity_Type=0,Prescale=8,Div_Ratio=8)
(
    input   wire                    CLK,
    input   wire                    RST,
    input   wire    [width-1:0]     WrData,
    input   wire    [3:0]           Address,
    input   wire                    WrEn,
    input   wire                    RdEn,
    output  reg                     RdData_Valid,
    output  reg     [width-1:0]     RdData,
    output  reg     [width-1:0]     REG0,
    output  reg     [width-1:0]     REG1,
    output  reg     [width-1:0]     REG2,
    output  reg     [width-1:0]     REG3

);

reg [width-1:0] mem [0:RegNo-1];
integer i;

always @(posedge CLK, negedge RST)
begin
    RdData_Valid <= 1'b0;
    if(!RST)
        begin
            for(i=0;i<RegNo;i=i+1)
                begin
                    mem[i] <= 'b0;
                end
            RdData_Valid <= 1'b0;
            mem[2][0]   <= Parity_Enable;
            mem[2][1]   <= Parity_Type;
            mem[2][5:2] <= Prescale;
            mem[3][3:0] <= Div_Ratio;
            RdData      <='b0;
        end
    else if (RdEn && !WrEn)
        begin
            RdData <= mem[Address];
            RdData_Valid <= 1'b1;
        end
    else if (WrEn && !RdEn)
        begin
            mem[Address] <=WrData;
        end
end
    
    
always@(*)
begin
    REG0 = mem[0];
    REG1 = mem[1];
    REG2 = mem[2];
    REG3 = mem[3];
end
    
endmodule
