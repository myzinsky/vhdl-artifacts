module reset(
    input clk,
    output reset_n
);

    reg [7:0] reset_n_counter = 0;
    assign reset_n = &reset_n_counter;

    always @(posedge clk) begin
        if (!reset_n)
            reset_n_counter <= reset_n_counter + 1;
    end

endmodule
