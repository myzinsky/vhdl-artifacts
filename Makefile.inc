.DEFAULT_GOAL := all

simulation: $(FILE).vhd $(FILE)tb.vhd
	ghdl -a $(FILE).vhd
	ghdl -e $(FILE)
	ghdl -a $(FILE)tb.vhd
	ghdl -e $(FILE)tb
	ghdl -r $(FILE)tb --wave=$(FILE).ghw

synthesis: $(FILE).vhd
	yosys '-mghdl' -p 'ghdl $(FILE).vhd -e $(FILE); $(TARGET); write_json $(FILE).json'

visualize:
	sed -i -e 's/inout/output/g' $(FILE).json
	netlistsvg $(FILE).json -o $(FILE).svg
	svgo $(FILE).svg
	rsvg-convert -f pdf -o $(FILE).pdf $(FILE).svg

all: simulation synthesis visualize

clean:
	rm -f $(FILE).ghw work-obj93.cf $(FILE).json* $(FILE).pdf $(FILE).svg
