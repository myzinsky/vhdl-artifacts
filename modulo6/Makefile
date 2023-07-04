FILE=fsm
TARGET=synth;
#TARGET=synth_ice40 -json leds.json;

include ../Makefile.inc

extract_fsm: 
	yosys -p 'read_verilog fsm.v; proc; opt; fsm -nomap; fsm_export -o test.kiss2'
