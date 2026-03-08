`timescale 1ns/1ps

module tb_dl_top;

logic clk;
logic rst_n;

logic [159:0] tlp_packet;
logic tlp_valid;

logic [203:0] phy_rx_data;
logic phy_rx_valid;

wire [203:0] phy_tx_data;
wire phy_tx_valid;

wire crc_ok;
wire ack_req;
wire nak_req;

integer pass_count = 0;
integer fail_count = 0;

integer expected_seq = 1;
integer received_seq;

////////////////////////////////////
// DUT
////////////////////////////////////

dl_top dut(
    .clk(clk),
    .rst_n(rst_n),

    .tlp_packet(tlp_packet),
    .tlp_valid(tlp_valid),

    .phy_rx_data(phy_rx_data),
    .phy_rx_valid(phy_rx_valid),

    .phy_tx_data(phy_tx_data),
    .phy_tx_valid(phy_tx_valid),

    .crc_ok(crc_ok),
    .ack_req(ack_req),
    .nak_req(nak_req)
);

////////////////////////////////////
// CLOCK
////////////////////////////////////

initial clk = 0;
always #5 clk = ~clk;

////////////////////////////////////
// RESET
////////////////////////////////////

initial begin
    rst_n = 0;
    tlp_valid = 0;
    phy_rx_valid = 0;
    tlp_packet = 0;
    phy_rx_data = 0;

    #30;
    rst_n = 1;
end

////////////////////////////////////
// MONITOR
////////////////////////////////////

initial
$monitor("TIME=%0t | TX_VALID=%0b | RX_VALID=%0b | CRC_OK=%0b | ACK=%0b | NAK=%0b",
         $time, phy_tx_valid, phy_rx_valid, crc_ok, ack_req, nak_req);

////////////////////////////////////
// SEND PACKET
////////////////////////////////////

task send_packet(input bit corrupt);

int bit_pos;

begin

tlp_packet = $random;

@(posedge clk);
tlp_valid = 1;

@(posedge clk);
tlp_valid = 0;

wait(phy_tx_valid);
@(posedge clk);

received_seq = dut.tx_engine.seq_tlp[171:160];

if(received_seq == expected_seq)
    pass_count++;
else begin
    $error("SEQ FAIL : expected %0d got %0d", expected_seq, received_seq);
    fail_count++;
end

expected_seq++;

phy_rx_data = phy_tx_data;

if(corrupt) begin
    bit_pos = $urandom_range(0,203);
    phy_rx_data[bit_pos] = ~phy_rx_data[bit_pos];
end

@(posedge clk);
phy_rx_valid = 1;

@(posedge clk);

if(corrupt) begin
    if(nak_req)
        pass_count++;
    else begin
        $error("NAK not generated");
        fail_count++;
    end
end
else begin
    if(ack_req)
        pass_count++;
    else begin
        $error("ACK not generated");
        fail_count++;
    end
end

phy_rx_valid = 0;

#20;

end
endtask

////////////////////////////////////
// REGRESSION
////////////////////////////////////

initial begin

wait(rst_n);

repeat(5)
send_packet(0);

repeat(5)
send_packet(1);

$display("PASS=%0d FAIL=%0d", pass_count, fail_count);

#100;
$finish;

end

endmodule