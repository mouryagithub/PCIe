`timescale 1ns/1ps

module dl_ack_nak_gen(

    input  logic clk,
    input  logic rst_n,

    input  logic rx_valid,
    input  logic crc_ok,

    output logic ack_req,
    output logic nak_req

);

always_comb begin
    ack_req = 0;
    nak_req = 0;

    if(rx_valid) begin
        if(crc_ok)
            ack_req = 1;
        else
            nak_req = 1;
    end
end

endmodule