module sphere_renderer(
    input wire clk,
    input wire reset,
    input wire [9:0] h_readwire,
    input wire [9:0] v_readwire,
    output wire [3:0] colorv,
    input wire startv,
    input wire starth,
    input wire [20:0] top
);

    reg [9:0] current_h;
    reg [9:0] current_v;

    wire [20:0] mulwire1;
    assign mulwire1 = (h_readwire - current_h) * (h_readwire - current_h);
    wire [20:0] mulwire2;
    assign mulwire2 = (v_readwire - current_v) * (v_readwire - current_v);
    
    wire [20:0] ballsize = 20'd512;
    reg deltav;
    reg deltah;

    reg [20:0] spdcnt;
    

    always @(posedge clk) begin
        if (!reset) begin
            current_h <= 10'd128;
            current_v <= 10'd128;
            deltav <= startv;
            deltah <= starth;
            spdcnt <= 21'b0;
        end else begin
            colorv <= ballsize + 128 > (mulwire1 + mulwire2) ? 4'b1111 : (mulwire1 + mulwire2) < ballsize + 20'd2048 ? 16 - (((mulwire1 + mulwire2) - ballsize)) / 128 : 4'b0000;
            if (spdcnt == top) begin
                spdcnt <= spdcnt + 1'b1;
                if (current_v < 32) begin
                    deltav <= 1'b1;
                end
                if (current_h < 32) begin
                    deltah <= 1'b1;
                end
                if (current_v > (480 - 32)) begin
                    deltav <= 1'b0;
                end
                if (current_h > (640 - 32)) begin
                    deltah <= 1'b0;
                end
            end else if (spdcnt > top) begin
                if (deltav) begin
                    current_v <= current_v + 1'b1;
                end else begin
                    current_v <= current_v - 1'b1;
                end

                if (deltah) begin
                    current_h <= current_h + 1'b1;
                end else begin
                    current_h <= current_h - 1'b1;
                end

                spdcnt <= 0;
            end else begin
                spdcnt <= spdcnt + 1'b1;
            end
        end
    end

endmodule


