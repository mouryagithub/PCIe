`timescale 1ns/1ps

module dl_lcrc_check(

    input  logic clk,
    input  logic rst_n,

    input  logic [203:0] packet,
    input  logic packet_valid,

    output logic crc_ok
);

logic [31:0] calc_crc;

function automatic [31:0] crc32;
    input [171:0] data;
    integer i;
    reg [31:0] crc;
begin
    crc = 32'hFFFFFFFF;

    for(i=0;i<172;i=i+1)
        crc = {crc[30:0],1'b0} ^
              (32'h04C11DB7 & {32{crc[31]^data[i]}});

    crc32 = ~crc;
end
endfunction

always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        crc_ok <= 0;

    else if(packet_valid) begin
        calc_crc = crc32(packet[203:32]);

        if(calc_crc == packet[31:0])
            crc_ok <= 1;
        else
            crc_ok <= 0;
    end
end

endmodule