`timescale 1ns/1ps

module dl_dllp_tx(

input logic clk,
input logic rst_n,

input logic ack_req,
input logic nak_req,

input logic [11:0] seq_num,

output logic [39:0] dllp_out,
output logic dllp_valid

);

logic [7:0] dllp_type;

always_comb
begin
dllp_type = 0;

if(ack_req)
dllp_type = 8'h00;

else if(nak_req)
dllp_type = 8'h10;

end

always_ff @(posedge clk or negedge rst_n)
begin
if(!rst_n)
dllp_valid <= 0;

else if(ack_req || nak_req)
begin
dllp_out <= {dllp_type, seq_num, 20'h0};
dllp_valid <= 1;
end

else
dllp_valid <= 0;

end

endmodule