`timescale 1ns/1ps

module dl_seq_insert(

    input  logic clk,
    input  logic rst_n,

    input  logic [171:0] tlp_in,
    input  logic tlp_valid,

    output logic [171:0] seq_tlp,
    output logic seq_valid
);

logic [11:0] seq_num;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        seq_num   <= 12'd1;
        seq_valid <= 0;
        seq_tlp   <= 0;
    end
    else begin
        seq_valid <= tlp_valid;

        if(tlp_valid) begin
            seq_tlp <= tlp_in;
            seq_tlp[171:160] <= seq_num;
            seq_num <= seq_num + 1;
        end
    end
end

endmodule