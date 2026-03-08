`timescale 1ns/1ps

module dl_tx_engine(

    input  logic clk,
    input  logic rst_n,

    input  logic [171:0] tlp_in,
    input  logic         tlp_valid,

    output logic [203:0] phy_tx_data,
    output logic         phy_tx_valid
);

logic [171:0] seq_tlp;
logic seq_valid;

logic [171:0] replay_tlp;
logic replay_valid;

logic [203:0] lcrc_packet;
logic lcrc_valid;


dl_seq_insert seq_insert(
    .clk(clk),
    .rst_n(rst_n),
    .tlp_in(tlp_in),
    .tlp_valid(tlp_valid),
    .seq_tlp(seq_tlp),
    .seq_valid(seq_valid)
);


dl_replay_buffer replay(
    .clk(clk),
    .rst_n(rst_n),
    .tlp_in(seq_tlp),
    .tlp_valid(seq_valid),
    .tlp_out(replay_tlp),
    .tlp_out_valid(replay_valid)
);


dl_lcrc_gen lcrc_gen(
    .clk(clk),
    .rst_n(rst_n),
    .packet_in(replay_tlp),
    .packet_valid(replay_valid),
    .packet_out(lcrc_packet),
    .packet_out_valid(lcrc_valid)
);


assign phy_tx_data  = lcrc_packet;
assign phy_tx_valid = lcrc_valid;

endmodule