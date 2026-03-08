`timescale 1ns/1ps

module dl_rx_engine(

    input  logic clk,
    input  logic rst_n,

    input  logic [203:0] phy_rx_data,
    input  logic         phy_rx_valid,

    output logic crc_ok,
    output logic ack_req,
    output logic nak_req
);

dl_lcrc_check crc_check(
    .clk(clk),
    .rst_n(rst_n),

    .packet(phy_rx_data),
    .packet_valid(phy_rx_valid),

    .crc_ok(crc_ok)
);

dl_ack_nak_gen ack_nak(
    .clk(clk),
    .rst_n(rst_n),

    .rx_valid(phy_rx_valid),
    .crc_ok(crc_ok),

    .ack_req(ack_req),
    .nak_req(nak_req)
);

endmodule