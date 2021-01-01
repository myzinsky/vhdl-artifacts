.DEFAULT_GOAL := all

FILE  = not_chain
FILE2 = not_gate
TARGET = synth
FLATTEN = flatten

synthesis: $(FILE).vhd
	yosys '-mghdl' -p 'ghdl $(FILE).vhd $(FILE2).vhd -e $(FILE); $(TARGET); $(FLATTEN); write_json $(FILE).json;'

visualize:
	sed -i -e 's/inout/output/g' $(FILE).json
	netlistsvg $(FILE).json -o $(FILE).svg
	svgo $(FILE).svg
	rsvg-convert -f pdf -o $(FILE).pdf $(FILE).svg

all: synthesis visualize

clean:
	rm -f $(FILE).ghw work-obj93.cf $(FILE).json* $(FILE).pdf $(FILE).svg
