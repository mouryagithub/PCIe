`timescale 1ns/1ps

module dl_top(

    input  logic clk,
    input  logic rst_n,

    input  logic [171:0] tlp_packet,
    input  logic         tlp_valid,

    output logic [203:0] phy_tx_data,
    output logic         phy_tx_valid,

    input  logic [203:0] phy_rx_data,
    input  logic         phy_rx_valid,

    output logic crc_ok,
    output logic ack_req,
    output logic nak_req
);

dl_tx_engine tx_engine(
    .clk(clk),
    .rst_n(rst_n),

    .tlp_in(tlp_packet),
    .tlp_valid(tlp_valid),

    .phy_tx_data(phy_tx_data),
    .phy_tx_valid(phy_tx_valid)
);

dl_rx_engine rx_engine(
    .clk(clk),
    .rst_n(rst_n),

    .phy_rx_data(phy_rx_data),
    .phy_rx_valid(phy_rx_valid),

    .crc_ok(crc_ok),
    .ack_req(ack_req),
    .nak_req(nak_req)
);

endmodule