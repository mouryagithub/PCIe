`timescale 1ns/1ps

module dl_fc_manager(

input logic clk,
input logic rst_n,

input logic update_fc,

input logic [7:0] hdr_credit,
input logic [11:0] data_credit,

output logic [7:0] hdr_avail,
output logic [11:0] data_avail

);

always_ff @(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
hdr_avail <= 0;
data_avail <= 0;
end

else if(update_fc)
begin
hdr_avail <= hdr_credit;
data_avail <= data_credit;
end

end

endmodule