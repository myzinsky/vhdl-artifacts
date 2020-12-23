FILE=ifelse

.DEFAULT_GOAL := all

synthesis: $(FILE).v
	yosys -p 'read_verilog $(FILE).v; synth; write_json $(FILE).json'

visualize:
	sed -i -e 's/inout/output/g' $(FILE).json
	netlistsvg $(FILE).json -o $(FILE).svg
	svgo $(FILE).svg
	rsvg-convert -f pdf -o $(FILE).pdf $(FILE).svg

all: synthesis visualize

clean:
	rm -f $(FILE).json* $(FILE).pdf $(FILE).svg
