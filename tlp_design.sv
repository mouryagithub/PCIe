`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 07:26:31 PM
// Design Name: 
// Module Name: tlp_design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tlp(
input wire clk,
input wire rst_n,
input wire req_valid,

input wire [2:0] req_fmt,
input wire [4:0] req_type,
input wire t9,
input wire [2:0] traffic_class,
input wire t8,
input wire [2:0] attr,
input wire R,
input wire th,
input wire td,
input wire ep,
input wire [1:0] at,
input wire [9:0] data_length,

input wire [15:0] request_id,
input wire [7:0] Tag,
input wire [3:0] last_DW,
input wire [3:0] first_DW,

input wire [7:0] Busnum,
input wire [63:0] Address,
input wire ph,

output reg [127:0] header_out,
output reg header_done
);

wire [31:0] DW0,DW1,DW2,DW3;

assign DW0[31:29] = req_fmt;
assign DW0[28:24] = req_type;
assign DW0[23]= t9;
assign DW0[22:20] = traffic_class;
assign DW0[19]= t8;
assign DW0[18]= attr[1];
assign DW0[17]= R;
assign DW0[16]= th;
assign DW0[15]= td;
assign DW0[14]= ep;
assign DW0[13:12] = attr[1:0];
assign DW0[11:10]= at;
assign DW0[9:0] = data_length;

assign DW1[31:16] = request_id;
assign DW1[15:8]= Tag;
assign DW1[7:4]= last_DW;
assign DW1[3:0]= first_DW;

assign DW2 = (req_fmt) ? Address[63:32] : {Address[31:2],ph};
assign DW3 = (req_fmt) ? {Address[31:2],ph} : 32'h0;

always@(posedge clk or negedge rst_n) begin
 if(!rst_n)
   begin
    header_out<=0;
    header_done<=0;
   end

else if(req_valid) begin
     header_out<={DW0,DW1,DW2,DW3};
     header_done<=1;
end

else
 begin
    header_done<=0;
 end
end
endmodule