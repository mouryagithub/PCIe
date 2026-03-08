`timescale 1ns/1ps

module dl_lcrc_gen(

    input  logic clk,
    input  logic rst_n,

    input  logic [171:0] packet_in,
    input  logic         packet_valid,

    output logic [203:0] packet_out,
    output logic         packet_out_valid
);

function automatic [31:0] crc32;
    input [171:0] data;
    integer i;
    reg [31:0] crc;
begin
    crc = 32'hFFFFFFFF;

    for(i=0;i<172;i=i+1)
        crc = {crc[30:0],1'b0} ^
              (32'h04C11DB7 & {32{crc[31] ^ data[i]}});

    crc32 = ~crc;
end
endfunction

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        packet_out <= 0;
        packet_out_valid <= 0;
    end
    else
    begin
        packet_out_valid <= packet_valid;

        if(packet_valid)
        begin
            packet_out[203:32] <= packet_in;
            packet_out[31:0] <= crc32(packet_in);
        end
    end
end

endmodule