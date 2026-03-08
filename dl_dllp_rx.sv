`timescale 1ns/1ps

module dl_dllp_rx(

input logic [39:0] dllp_in,
input logic dllp_valid,

output logic ack_received,
output logic nak_received

);

logic [7:0] dllp_type;

assign dllp_type = dllp_in[39:32];

always_comb
begin

ack_received = 0;
nak_received = 0;

if(dllp_valid)
begin
if(dllp_type == 8'h00)
ack_received = 1;

else if(dllp_type == 8'h10)
nak_received = 1;
end

end

endmodule