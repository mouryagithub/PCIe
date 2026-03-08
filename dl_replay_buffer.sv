`timescale 1ns/1ps

module dl_replay_buffer(
    input  logic clk,
    input  logic rst_n,

    input  logic [171:0] tlp_in,
    input  logic tlp_valid,

    output logic [171:0] tlp_out,
    output logic tlp_out_valid
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tlp_out       <= 172'd0;
        tlp_out_valid <= 1'b0;
    end 
    else begin
        tlp_out       <= tlp_in;
        tlp_out_valid <= tlp_valid;
    end
end

endmodule