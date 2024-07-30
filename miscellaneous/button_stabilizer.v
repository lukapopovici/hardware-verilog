module bt_filter(input clk, input btn, output reg bt_out);

reg [31:0] cnt = 32'b0;
reg bt_lag = 0;

always @(posedge clk) begin
    cnt = cnt+1;
end

always @(posedge cnt[16]) begin
    if (bt ==1 & bt_lag==0) begin
        bt_out=1;
        bt_lag=1;
    end

    if (bt ==0 & bt_lag==1) begin
        bt_out=0;
        bt_lag=0;
    end
end

endmodule