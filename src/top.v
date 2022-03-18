`default_nettype none
`timescale 1ns/1ns

module top(
    input clk,
    input btn,
    output led1,
    output led2,
    output led3,
    input butt1,
    input butt2,
    input butt3,
    output vga_h_sync,
    output vga_v_sync,
    output reg[3:0] vga_r,
    output reg[3:0] vga_g,
    output reg[3:0] vga_b,
);

    wire core_busy;
    wire clk_25_175;
    wire [9:0] h_readwire, v_readwire;
    reg [11:0] pixstream;
    reg write;
    wire [4:0] gpu_block_selector_v;
    wire [4:0] gpu_block_selector_h;
    wire [2:0] gpu_blocktype;
	
    reg [3:0] resetn_gen = 0;
	reg reset;
    wire pll_locked;

    vga_pll pll(
        .clock_in(clk),
        .pll_locked(pll_locked),
        .clock_out(clk_25_175),
    );

	always @(posedge clk_25_175) begin
		reset <= &resetn_gen;
		resetn_gen <= {resetn_gen, pll_locked};
	end

    wire [3:0] rcol;
    wire [3:0] gcol;
    wire [3:0] bcol;
    
    sphere_renderer spb(
        .clk(clk_25_175),
        .reset(reset),
        .h_readwire(h_readwire),
        .v_readwire(v_readwire),
        .colorv(rcol),
        .startv(1'b1),
        .starth(1'b1),
        .top(349525)
    );

    sphere_renderer spg(
        .clk(clk_25_175),
        .reset(reset),
        .h_readwire(h_readwire),
        .v_readwire(v_readwire),
        .colorv(gcol),
        .startv(1'b1),
        .starth(1'b0),
        .top(209715)
    );

    sphere_renderer spr(
        .clk(clk_25_175),
        .reset(reset),
        .h_readwire(h_readwire),
        .v_readwire(v_readwire),
        .colorv(bcol),
        .startv(1'b0),
        .starth(1'b1),
        .top(262144)
    );

    VGAcore core(
        .clk_25_175(clk_25_175),
        .reset(reset),
        .drawing_pixels(core_busy),
        .h_sync(vga_h_sync),
        .v_sync(vga_v_sync),
        .pixstream({rcol, gcol, bcol}),
        .hreadwire(h_readwire),
        .vreadwire(v_readwire),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );
endmodule
