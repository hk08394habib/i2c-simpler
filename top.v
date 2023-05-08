module top(
	input clk,
	input [15:0]sw,
	output reg [15:0]led,
	inout [7:0]JA);

wire slowerclk;
clk_div slowclk(.clock_in(clk), .clock_out(slowerclk));
defparam slowclk.DIVISOR=250;

wire [7:0]data_out;
reg [7:0]data_in;

assign JA[1] = (o_scl) ? 1'bz : 1'b0;
assign JA[0] = (o_sda) ? 1'bz : 1'b0;
assign i_scl = JA[1];
assign i_sda = JA[0];

wire busy,valid,nack_slave,nack_addr,nack_data,counter;
wire i_scl, i_sda, o_scl, o_sda;

    i2c_master 
//    #(
//    .T_CLK (T_CLK)
//    ) 
    DUT
    (
    .i_clk         (clk          ), 
    .i_rstn        (1'b1         ), // async active low rst
 
    // read/write control  
    .i_wr          (1'b0           ), // write enable
    .i_rd          (1'b0           ), // read enable
    .i_slave_addr  (7'h3b          ), // 7-bit slave device addr
    .i_reg_addr    (8'b1101000     ), // 8-bit register addr
    .i_wdata       (8'b0        ), // 8-bit write data
 
    // read data out 
    .o_rdata       (data_out        ), // 8-bit read data out

    // status signals
    .o_busy        (busy         ), // asserted when r/w in progress
    .o_rdata_valid (valid  ), // indicates o_rdata is valid
    .o_nack_slave  (nack_slave ), // NACK on slave address frame
    .o_nack_addr   (nack_addr ), // NACK on register address frame
    .o_nack_data   (nack_data ), // NACK on data frame

    // bidirectional i2c pins
    .i_scl         (i_scl          ),
    .i_sda         (i_sda          ),
    .o_scl         (o_scl          ),
    .o_sda         (o_sda          ) 
    );



always @(posedge clk) begin
	if (sw[0]) begin
		led <= {clk,data_out,busy,valid,nack_slave,nack_addr,nack_data,JA[1],JA[0]};
	end
	else if (sw[1]) begin
		led <= data_out;
	end
	else begin
		led <= 0;
	end
end
endmodule









