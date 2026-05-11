`include "src/sprite_buf_EX2.sv"

module store (
    input logic rx,
    input logic sck,
    input logic cs,
    input logic [7:0]  raddr,
    input  logic CLK,

    output logic tx,
    output logic [15:0] rdata
);

logic [7:0] waddr;
logic [15:0] wdata;
logic we;

dp_buffer sprite_from_pico (
    .clk(CLK),
    .waddr(waddr),
    .wdata(wdata),
    .we(we),
    .raddr(raddr),
    .rdata(rdata)
);

logic [3:0] bit_count = 0;
logic [7:0] addr = 0;

always @(posedge sck or posedge cs) begin //When recieving from spi, store read data until 16 bits are read then increment address
    if (!cs) begin
        wdata <= {wdata[14:0], rx};
        if (bit_count == 15) begin
            bit_count <= 0;
            we <= 1;
            waddr <= addr;
            if (addr == 255) begin addr <= 0; end 
            else begin addr <= addr + 1; end
        end
        else begin bit_count <= bit_count + 1; we <= 0; end
    end else begin we <= 0; bit_count <= 0; end
end

endmodule