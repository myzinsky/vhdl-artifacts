FILE=display
FILE2=i2c
FILE4=i2c_clock
TARGET=synth_ice40

.DEFAULT_GOAL := all

init:
	ghdl -a $(FILE4).vhd
	ghdl -e $(FILE4)
	ghdl -a $(FILE2).vhd
	ghdl -e $(FILE2)
	ghdl -a $(FILE2)tb.vhd
	ghdl -e $(FILE2)tb
	ghdl -a $(FILE).vhd
	ghdl -e $(FILE)

simulation: init
	ghdl -r $(FILE2)tb --wave=$(FILE2).ghw

synthesis: $(FILE).vhd init
	yosys '-mghdl' -p 'ghdl $(FILE); read_verilog reset.v clock.v; $(OPT); $(TARGET); write_json $(FILE).json; show'

visualize:
	sed -i -e 's/inout/output/g' $(FILE).json
	netlistsvg $(FILE).json -o $(FILE).svg
	svgo $(FILE).svg
	rsvg-convert -f pdf -o $(FILE).pdf $(FILE).svg

pr: synthesis
	DYLD_FRAMEWORK_PATH=/Users/myzinsky/Zeugs/Qt/5.14.2/clang_64/lib nextpnr-ice40 \
						--up5k \
					   	--package sg48 \
						--asc $(FILE).asc \
						--pcf upduino_v1.pcf \
						--json $(FILE).json \
						--routed-svg $(FILE)-routed.svg
	rsvg-convert -f pdf -o $(FILE)-routed.pdf $(FILE)-routed.svg &
	rsvg-convert -f png -o $(FILE)-routed.png $(FILE)-routed.svg &
	icepack $(FILE).asc $(FILE).bin

flash:
	iceprog -e 128 # Force a reset
	iceprog $(FILE).bin

sram:
	iceprog -S $(FILE).bin

all: synthesis pr sram

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
