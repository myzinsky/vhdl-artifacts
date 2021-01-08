module clock(output clk_48);

    SB_HFOSC #(.CLKHF_DIV("0b10")) osc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk_48)
	);

endmodule
