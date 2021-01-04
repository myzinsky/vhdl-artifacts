FILE=display
FILE2=i2c
FILE3=init_1306
TARGET=synth_ice40

.DEFAULT_GOAL := all

simulation: $(FILE2).vhd $(FILE2)tb.vhd
	ghdl -a $(FILE2).vhd
	ghdl -e $(FILE2)
	ghdl -a $(FILE3).vhd
	ghdl -e $(FILE3)
	ghdl -a $(FILE2)tb.vhd
	ghdl -e $(FILE2)tb
	ghdl -r $(FILE2)tb --wave=$(FILE2).ghw
	ghdl -a $(FILE).vhd
	ghdl -e $(FILE)

synthesis: $(FILE).vhd simulation
	#yosys '-mghdl' -p 'ghdl $(FILE2).vhd $(FILE).vhd -e $(FILE2) $(FILE); read_verilog clock.v; $(OPT); $(TARGET); flatten; write_json $(FILE).json; show'
	yosys '-mghdl' -p 'ghdl $(FILE); read_verilog clock.v; $(OPT); $(TARGET); flatten; write_json $(FILE).json; show'

visualize:
	sed -i -e 's/inout/output/g' $(FILE).json
	netlistsvg $(FILE).json -o $(FILE).svg
	svgo $(FILE).svg
	rsvg-convert -f pdf -o $(FILE).pdf $(FILE).svg

pr: 
	DYLD_FRAMEWORK_PATH=/Users/myzinsky/Zeugs/Qt/5.14.2/clang_64/lib nextpnr-ice40 \
						--up5k \
					   	--package sg48 \
						--asc $(FILE).asc \
						--pcf upduino_v1.pcf \
						--json $(FILE).json 
	#					--routed-svg $(FILE)-routed.svg
	#rsvg-convert -f pdf -o $(FILE)-routed.pdf $(FILE)-routed.svg &
	#rsvg-convert -f png -o $(FILE)-routed.png $(FILE)-routed.svg &
	icepack $(FILE).asc $(FILE).bin

flash:
	iceprog -e 128 # Force a reset
	iceprog $(FILE).bin


all: synthesis pr

clean:
	rm -f $(FILE2).ghw work-obj93.cf \
	   	$(FILE).json* \
		$(FILE).pdf \
		$(FILE).svg \
		$(FILE).asc \
		$(FILE).bin \
		$(FILE)-routed.svg \
		$(FILE)-routed.pdf \
		$(FILE)-routed.png
