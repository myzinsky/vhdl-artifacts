library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c is
    PORT(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        clk_enable : in  std_logic;
        i2c_scl    : out std_logic;
        i2c_sda    : out std_logic
    );
end i2c;

Architecture behavior of i2c is

    signal scl_trigger  : std_logic := '0';
    signal scl_int      : std_logic := '1';
    signal sda_int      : std_logic := '1';
    signal counter      : unsigned(5 downto 0) := (others => '0');

    signal command      : unsigned(7 downto 0) := (others => '0');
    --signal addr         : std_logic_vector(6 downto 0) := "0111100";
    signal addr         : std_logic_vector(6 downto 0) := "0111100";
    signal pic_command  : std_logic_vector(7 downto 0) := x"40";
    signal rw           : std_logic := '0';

    signal init_counter : unsigned(4 downto 0)  := (others => '0');
    signal pix_counter  : unsigned(10 downto 0) := (others => '0');

    type pixel is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal picture : pixel := (
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00100000",
        "00100000",
        "00100000",
        "00100000",
        "00100000",
        "00100010",
        "00000010",
        "01000010",
        "01000010",
        "01000010",
        "01000000",
        "01000000",
        "00000000",
        "10000000",
        "10000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "01100000",
        "00100000",
        "00110000",
        "00010000",
        "00010000",
        "00011000",
        "00001000",
        "10001000",
        "10001000",
        "10001100",
        "10000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "11000100",
        "10000100",
        "10000100",
        "10001100",
        "10001000",
        "10001000",
        "00001000",
        "00001000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "11000000",
        "01100000",
        "00110000",
        "00011000",
        "00001100",
        "10000100",
        "11000010",
        "11000010",
        "01100000",
        "00110000",
        "00011000",
        "00011000",
        "00001100",
        "10000100",
        "11000110",
        "11000010",
        "01100011",
        "00100011",
        "00110001",
        "00110001",
        "00010001",
        "00010000",
        "00011000",
        "10011000",
        "10011000",
        "10001000",
        "10001000",
        "10001000",
        "10001000",
        "10001000",
        "10001000",
        "10011000",
        "00011000",
        "00011000",
        "00010001",
        "00010001",
        "00110001",
        "00100001",
        "01100001",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000110",
        "00000011",
        "11000000",
        "01110000",
        "00111000",
        "00001100",
        "00000110",
        "10000011",
        "11100001",
        "00110000",
        "00011000",
        "00001100",
        "10000110",
        "11000011",
        "11100001",
        "01110001",
        "00111000",
        "00011000",
        "10011100",
        "10001100",
        "11000110",
        "11100110",
        "11100011",
        "01100011",
        "01110011",
        "00110011",
        "00110001",
        "00110001",
        "00110001",
        "00110001",
        "00110001",
        "00110001",
        "00110001",
        "00110001",
        "01110011",
        "01110011",
        "01100011",
        "11100010",
        "11000000",
        "11000000",
        "10000000",
        "00011000",
        "00011000",
        "00110000",
        "01110000",
        "11100000",
        "11000000",
        "10000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00001100",
        "00000111",
        "00000001",
        "11000000",
        "11110000",
        "00111100",
        "00001111",
        "00000011",
        "11100001",
        "11110000",
        "01111100",
        "00011110",
        "10001111",
        "11000111",
        "11110011",
        "01110001",
        "00111000",
        "00011100",
        "10001110",
        "11001110",
        "11100110",
        "11100111",
        "11100111",
        "01110111",
        "01110111",
        "01110111",
        "01100111",
        "11100111",
        "11100111",
        "11001110",
        "11001110",
        "10011100",
        "00011100",
        "01111000",
        "11110001",
        "11100011",
        "11000111",
        "00001110",
        "00011100",
        "01111000",
        "11110000",
        "11000011",
        "00000111",
        "00011110",
        "00111100",
        "00110000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00011110",
        "00011111",
        "00000001",
        "00000000",
        "00010000",
        "00111111",
        "00011111",
        "00000001",
        "00000000",
        "00000100",
        "00000111",
        "00000111",
        "00000001",
        "00000000",
        "00001110",
        "00001111",
        "00001111",
        "00000011",
        "11111001",
        "11111100",
        "11111110",
        "00001110",
        "00001110",
        "00001110",
        "00011110",
        "11111100",
        "11111100",
        "11110001",
        "00000011",
        "00001111",
        "11111111",
        "11111100",
        "01000000",
        "00000011",
        "11111111",
        "11111111",
        "11111000",
        "00000000",
        "00000011",
        "11111111",
        "11111110",
        "00000000",
        "00000000",
        "00000000",
        "01111111",
        "00000100",
        "00000100",
        "00000100",
        "01111111",
        "00000000",
        "00111000",
        "01000100",
        "01000100",
        "01000100",
        "00111000",
        "00000000",
        "00111000",
        "01000100",
        "01000100",
        "01000100",
        "00101000",
        "00000000",
        "01111111",
        "00001000",
        "00000100",
        "00000100",
        "01111000",
        "00000000",
        "01001000",
        "01010100",
        "01010100",
        "01010100",
        "00100100",
        "00000000",
        "00111000",
        "01000100",
        "01000100",
        "01000100",
        "00101000",
        "00000000",
        "01111111",
        "00001000",
        "00000100",
        "00000100",
        "01111000",
        "00000000",
        "00111100",
        "01000000",
        "01000000",
        "01000000",
        "01111100",
        "00000000",
        "00111111",
        "01000000",
        "00000000",
        "00111000",
        "01010100",
        "01010100",
        "01010100",
        "01011000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00110000",
        "01110001",
        "01110011",
        "11100111",
        "11100111",
        "11100111",
        "11100111",
        "11100111",
        "11110111",
        "01110011",
        "01111001",
        "00111100",
        "00011111",
        "10001111",
        "11000011",
        "11110000",
        "01111100",
        "00111111",
        "00001111",
        "10000001",
        "11100000",
        "11111100",
        "00111111",
        "00001111",
        "00000000",
        "00000000",
        "00000000",
        "11000000",
        "00000000",
        "00000000",
        "10000000",
        "01000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "01000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "11000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "10000000",
        "11000000",
        "10000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00001110",
        "00001110",
        "00001110",
        "00000111",
        "00000111",
        "00000011",
        "00000001",
        "00011000",
        "00011100",
        "00011110",
        "00001111",
        "11000111",
        "11100001",
        "01110000",
        "00111000",
        "00011110",
        "00000110",
        "00000000",
        "00000000",
        "00011111",
        "00000001",
        "00000001",
        "00000010",
        "00011100",
        "00000000",
        "00001000",
        "00010101",
        "00010101",
        "00010101",
        "00011110",
        "00000000",
        "00011111",
        "00000000",
        "00010010",
        "00010101",
        "00010101",
        "00010101",
        "00001001",
        "00000000",
        "00001110",
        "00010101",
        "00010101",
        "00010101",
        "00010110",
        "00000000",
        "00011111",
        "00000010",
        "00000001",
        "00000001",
        "00000010",
        "00000000",
        "00010010",
        "00010101",
        "00010101",
        "00010101",
        "00001001",
        "00000000",
        "00001111",
        "00010000",
        "00000000",
        "00001000",
        "00010101",
        "00010101",
        "00010101",
        "00011110",
        "00000000",
        "00001111",
        "00010000",
        "00010000",
        "00010000",
        "00011111",
        "00000000",
        "00000000",
        "00001111",
        "00010000",
        "00000000",
        "00001110",
        "00010101",
        "00010101",
        "00010101",
        "00010110",
        "00000000",
        "00011111",
        "00000010",
        "00000001",
        "00000001",
        "00000010",
        "00000000",
        "00011111",
        "00000001",
        "00000001",
        "00000001",
        "00011110",
        "00000000",
        "00000000"
    );  

    type element is array (0 to 24) of std_logic_vector(7 downto 0);
    signal init_sequence : element := (
       x"AE", -- DISPLAYOFF
       x"D5", -- SETDISPLAYCLOCKDIV
       x"80", -- 
       x"A8", -- SETMULTIPLEX
       x"3F", --
       x"D3", -- SETDISPLAYOFFSET
       x"00", --
       x"40", -- SETSTARTLINE
       x"8D", -- CHARGEPUMP
       x"14", --
       x"20", -- MEMORYMODE
       x"00", -- 
       x"A1", -- SEGREMAP (or A0?)
       x"C8", -- COMSCANDEC
       x"DA", -- SETCOMPINS
       x"12", --
       x"81", -- SETCONTRAST
       x"CF", -- 
       x"D9", -- SETPRECHARGE 
       x"F1", -- 
       x"DB", -- SETVCOMDETECT 
       x"40", -- 
       x"A4", -- DISPLAYALLON_RESUME
       x"A6", -- NORMALDISPLAY
       x"AF"  -- DISPLAYON
       --x"AE", -- Display Off
       --x"A8", -- Set Multiplex Ratio
       --x"3F", --
       --x"D3", --
       --x"00", --
       --x"40", --
       --x"A1", --
       --x"8C", --
       --x"DA", --
       --x"12", --
       --x"81", --
       --x"CF", --
       --x"A4", --
       --x"A6", --
       --x"D5", --
       --x"80", --
       --x"8D", --
       --x"14", --
       --x"AF", --
       --x"20", --
       --x"00"  -- YYY
    );

    type state_t is (
        S_START,
        S_ADDR,
        S_COMMAND,
        S_INIT,
        S_PIC_COMMAND,
        S_PIC,
        S_STOP,
        S_IDLE
    );

    type phase_t is (
        P_INIT,
        P_PIC,
        P_END
    );

    signal state : state_t := S_START;
    signal phase : phase_t := P_INIT;
begin

    i2c_scl <= scl_int;
    i2c_sda <= sda_int;

    state_machine : process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then 
                counter <= (others => '0');
                state <= S_START;
                phase <= P_INIT;
            elsif clk_enable = '1' then
                case state is
                    -------------------
                    when S_START =>
                        scl_int <= '1';
                        sda_int <= '1';

                        if counter >= 2 then
                           sda_int <= '0';
                        end if;
                        if counter >= 4 then
                           scl_int <= '0';
                        end if;
                        if counter = 6 then
                            state <= S_ADDR;
                            counter <= (others => '0') ;
                        else
                            counter <= counter + 1;
                        end if;
                    when S_STOP =>
                        scl_int <= '0';
                        sda_int <= '0';

                        if counter >= 2 then
                           scl_int <= '1';
                        end if;
                        if counter >= 4 then
                           sda_int <= '1';
                        end if;
                        if counter = 6 then
                            counter <= (others => '0') ;
                            if phase = P_END then 
                                state <= S_IDLE;
                            else
                                state <= S_START;
                            end if;
                        else
                            counter <= counter + 1;
                        end if;
                    -------------------
                    --          _______  ______
                    --  SDA ___/       \/      \_
                    --            ___       ___
                    --  SCL _____|   |_____|   |____
                    --        0    1    2    3    0
                    --
                    when S_ADDR =>
                        scl_int <= '0';
                        sda_int <= '1';
                        counter <= counter + 1;
                        
                        if    counter =  0 then sda_int <= addr(6); -- Bit 0
                        elsif counter =  1 then sda_int <= addr(6); scl_int <= '1';
                        elsif counter =  2 then sda_int <= addr(6); scl_int <= '1';
                        elsif counter =  3 then sda_int <= addr(6); 
                        elsif counter =  4 then sda_int <= addr(5); -- Bit 1
                        elsif counter =  5 then sda_int <= addr(5); scl_int <= '1';
                        elsif counter =  6 then sda_int <= addr(5); scl_int <= '1';
                        elsif counter =  7 then sda_int <= addr(5); 
                        elsif counter =  8 then sda_int <= addr(4); -- Bit 2
                        elsif counter =  9 then sda_int <= addr(4); scl_int <= '1';
                        elsif counter = 10 then sda_int <= addr(4); scl_int <= '1';
                        elsif counter = 11 then sda_int <= addr(4); 
                        elsif counter = 12 then sda_int <= addr(3); -- Bit 4
                        elsif counter = 13 then sda_int <= addr(3); scl_int <= '1';
                        elsif counter = 14 then sda_int <= addr(3); scl_int <= '1';
                        elsif counter = 15 then sda_int <= addr(3); 
                        elsif counter = 16 then sda_int <= addr(2); -- Bit 5
                        elsif counter = 17 then sda_int <= addr(2); scl_int <= '1';
                        elsif counter = 18 then sda_int <= addr(2); scl_int <= '1';
                        elsif counter = 19 then sda_int <= addr(2); 
                        elsif counter = 20 then sda_int <= addr(1); -- Bit 6
                        elsif counter = 21 then sda_int <= addr(1); scl_int <= '1';
                        elsif counter = 22 then sda_int <= addr(1); scl_int <= '1';
                        elsif counter = 23 then sda_int <= addr(1); 
                        elsif counter = 24 then sda_int <= addr(0); -- Bit 6
                        elsif counter = 25 then sda_int <= addr(0); scl_int <= '1';
                        elsif counter = 26 then sda_int <= addr(0); scl_int <= '1';
                        elsif counter = 27 then sda_int <= addr(0); 
                        elsif counter = 28 then sda_int <= '0';     -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= '0';     scl_int <= '1';
                        elsif counter = 30 then sda_int <= '0';     scl_int <= '1';
                        elsif counter = 31 then sda_int <= '0';     
                        elsif counter = 32 then sda_int <= 'Z';     -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z';     scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z';     scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z';     
                        elsif counter = 36 then sda_int <= '0';     -- PAUSE
                        elsif counter = 37 then sda_int <= '0';     
                            if phase = P_INIT then                        
                                state <= S_COMMAND;
                            else -- P_PIC
                                state <= S_PIC_COMMAND; 
                            end if;
                              counter <= (others => '0');
                        end if;
                            
                    -------------------
                    when S_COMMAND =>
                        scl_int <= '0';
                        sda_int <= '1';
                        counter <= counter + 1;

                        --if    counter =  0 then sda_int <= '1'; -- Bit 0
                        --elsif counter =  1 then sda_int <= '1'; scl_int <= '1';
                        --elsif counter =  2 then sda_int <= '1'; scl_int <= '1';
                        --elsif counter =  3 then sda_int <= '1'; 
                        if    counter =  0 then sda_int <= '0'; -- Bit 0
                        elsif counter =  1 then sda_int <= '0'; scl_int <= '1';
                        elsif counter =  2 then sda_int <= '0'; scl_int <= '1';
                        elsif counter =  3 then sda_int <= '0'; 
                        elsif counter =  4 then sda_int <= '0'; -- Bit 1
                        elsif counter =  5 then sda_int <= '0'; scl_int <= '1';
                        elsif counter =  6 then sda_int <= '0'; scl_int <= '1';
                        elsif counter =  7 then sda_int <= '0'; 
                        elsif counter =  8 then sda_int <= '0'; -- Bit 2
                        elsif counter =  9 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 10 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 11 then sda_int <= '0'; 
                        elsif counter = 12 then sda_int <= '0'; -- Bit 4
                        elsif counter = 13 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 14 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 15 then sda_int <= '0'; 
                        elsif counter = 16 then sda_int <= '0'; -- Bit 5
                        elsif counter = 17 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 18 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 19 then sda_int <= '0'; 
                        elsif counter = 20 then sda_int <= '0'; -- Bit 6
                        elsif counter = 21 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 22 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 23 then sda_int <= '0'; 
                        elsif counter = 24 then sda_int <= '0'; -- Bit 6
                        elsif counter = 25 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 26 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 27 then sda_int <= '0'; 
                        elsif counter = 28 then sda_int <= '0'; -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 30 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 31 then sda_int <= '0'; 
                        elsif counter = 32 then sda_int <= 'Z'; -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z'; scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z'; scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z'; 
                        elsif counter = 36 then sda_int <= '0'; -- PAUSE
                        elsif counter = 37 then sda_int <= '0'; 
                              state   <= S_INIT;
                              counter <= (others => '0');
                        end if;
                    -------------------
                    when S_INIT => 
                        scl_int      <= '0';
                        sda_int      <= '1';
                        counter      <= counter + 1;

                        if    counter =  0 then sda_int <= init_sequence(to_integer(init_counter))(7); -- Bit 0
                        elsif counter =  1 then sda_int <= init_sequence(to_integer(init_counter))(7); scl_int <= '1';
                        elsif counter =  2 then sda_int <= init_sequence(to_integer(init_counter))(7); scl_int <= '1';
                        elsif counter =  3 then sda_int <= init_sequence(to_integer(init_counter))(7); 
                        elsif counter =  4 then sda_int <= init_sequence(to_integer(init_counter))(6); -- Bit 1
                        elsif counter =  5 then sda_int <= init_sequence(to_integer(init_counter))(6); scl_int <= '1';
                        elsif counter =  6 then sda_int <= init_sequence(to_integer(init_counter))(6); scl_int <= '1';
                        elsif counter =  7 then sda_int <= init_sequence(to_integer(init_counter))(6); 
                        elsif counter =  8 then sda_int <= init_sequence(to_integer(init_counter))(5); -- Bit 2
                        elsif counter =  9 then sda_int <= init_sequence(to_integer(init_counter))(5); scl_int <= '1';
                        elsif counter = 10 then sda_int <= init_sequence(to_integer(init_counter))(5); scl_int <= '1';
                        elsif counter = 11 then sda_int <= init_sequence(to_integer(init_counter))(5); 
                        elsif counter = 12 then sda_int <= init_sequence(to_integer(init_counter))(4); -- Bit 4
                        elsif counter = 13 then sda_int <= init_sequence(to_integer(init_counter))(4); scl_int <= '1';
                        elsif counter = 14 then sda_int <= init_sequence(to_integer(init_counter))(4); scl_int <= '1';
                        elsif counter = 15 then sda_int <= init_sequence(to_integer(init_counter))(4); 
                        elsif counter = 16 then sda_int <= init_sequence(to_integer(init_counter))(3); -- Bit 5
                        elsif counter = 17 then sda_int <= init_sequence(to_integer(init_counter))(3); scl_int <= '1';
                        elsif counter = 18 then sda_int <= init_sequence(to_integer(init_counter))(3); scl_int <= '1';
                        elsif counter = 19 then sda_int <= init_sequence(to_integer(init_counter))(3); 
                        elsif counter = 20 then sda_int <= init_sequence(to_integer(init_counter))(2); -- Bit 6
                        elsif counter = 21 then sda_int <= init_sequence(to_integer(init_counter))(2); scl_int <= '1';
                        elsif counter = 22 then sda_int <= init_sequence(to_integer(init_counter))(2); scl_int <= '1';
                        elsif counter = 23 then sda_int <= init_sequence(to_integer(init_counter))(2); 
                        elsif counter = 24 then sda_int <= init_sequence(to_integer(init_counter))(1); -- Bit 6
                        elsif counter = 25 then sda_int <= init_sequence(to_integer(init_counter))(1); scl_int <= '1';
                        elsif counter = 26 then sda_int <= init_sequence(to_integer(init_counter))(1); scl_int <= '1';
                        elsif counter = 27 then sda_int <= init_sequence(to_integer(init_counter))(1); 
                        elsif counter = 28 then sda_int <= init_sequence(to_integer(init_counter))(0); -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= init_sequence(to_integer(init_counter))(0); scl_int <= '1';
                        elsif counter = 30 then sda_int <= init_sequence(to_integer(init_counter))(0); scl_int <= '1';
                        elsif counter = 31 then sda_int <= init_sequence(to_integer(init_counter))(0); 
                        elsif counter = 32 then sda_int <= 'Z';                                        -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z';                                        scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z';                                        scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z';                                        
                        elsif counter = 36 then sda_int <= '0';                                        -- PAUSE
                        elsif counter = 37 then sda_int <= '0';                                        
                            counter <= (others => '0');
                            if init_counter < 24 then
                                state   <= S_STOP;
                                state   <= S_INIT;
                                init_counter <= init_counter + 1;
                            else
                                phase <= P_PIC; 
                                state <= S_STOP;
                                init_counter <= (others => '0');
                            end if;
                        end if;
                    -------------------
                    when S_PIC_COMMAND =>
                        scl_int <= '0';
                        sda_int <= '1';
                        counter <= counter + 1;
                        if    counter =  0 then sda_int <= '1'; -- Bit 0
                        elsif counter =  1 then sda_int <= '1'; scl_int <= '1';
                        elsif counter =  2 then sda_int <= '1'; scl_int <= '1';
                        elsif counter =  3 then sda_int <= '1'; 
                        elsif counter =  4 then sda_int <= '1'; -- Bit 1
                        elsif counter =  5 then sda_int <= '1'; scl_int <= '1';
                        elsif counter =  6 then sda_int <= '1'; scl_int <= '1';
                        elsif counter =  7 then sda_int <= '1'; 
                        elsif counter =  8 then sda_int <= '0'; -- Bit 2
                        elsif counter =  9 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 10 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 11 then sda_int <= '0'; 
                        elsif counter = 12 then sda_int <= '0'; -- Bit 4
                        elsif counter = 13 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 14 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 15 then sda_int <= '0'; 
                        elsif counter = 16 then sda_int <= '0'; -- Bit 5
                        elsif counter = 17 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 18 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 19 then sda_int <= '0'; 
                        elsif counter = 20 then sda_int <= '0'; -- Bit 6
                        elsif counter = 21 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 22 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 23 then sda_int <= '0'; 
                        elsif counter = 24 then sda_int <= '0'; -- Bit 6
                        elsif counter = 25 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 26 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 27 then sda_int <= '0'; 
                        elsif counter = 28 then sda_int <= '0'; -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 30 then sda_int <= '0'; scl_int <= '1';
                        elsif counter = 31 then sda_int <= '0'; 
                        elsif counter = 32 then sda_int <= 'Z'; -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z'; scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z'; scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z'; 
                        elsif counter = 36 then sda_int <= '0'; -- PAUSE
                        elsif counter = 37 then sda_int <= '0'; 
                              state   <= S_PIC;
                              counter <= (others => '0');
                        end if;
                    -------------------
                    when S_PIC => 
                        scl_int      <= '0';
                        sda_int      <= '1';
                        counter      <= counter + 1;

                        if    counter =  0 then sda_int <= picture(to_integer(pix_counter))(7); -- Bit 0
                        elsif counter =  1 then sda_int <= picture(to_integer(pix_counter))(7); scl_int <= '1';
                        elsif counter =  2 then sda_int <= picture(to_integer(pix_counter))(7); scl_int <= '1';
                        elsif counter =  3 then sda_int <= picture(to_integer(pix_counter))(7); 
                        elsif counter =  4 then sda_int <= picture(to_integer(pix_counter))(6); -- Bit 1
                        elsif counter =  5 then sda_int <= picture(to_integer(pix_counter))(6); scl_int <= '1';
                        elsif counter =  6 then sda_int <= picture(to_integer(pix_counter))(6); scl_int <= '1';
                        elsif counter =  7 then sda_int <= picture(to_integer(pix_counter))(6); 
                        elsif counter =  8 then sda_int <= picture(to_integer(pix_counter))(5); -- Bit 2
                        elsif counter =  9 then sda_int <= picture(to_integer(pix_counter))(5); scl_int <= '1';
                        elsif counter = 10 then sda_int <= picture(to_integer(pix_counter))(5); scl_int <= '1';
                        elsif counter = 11 then sda_int <= picture(to_integer(pix_counter))(5); 
                        elsif counter = 12 then sda_int <= picture(to_integer(pix_counter))(4); -- Bit 4
                        elsif counter = 13 then sda_int <= picture(to_integer(pix_counter))(4); scl_int <= '1';
                        elsif counter = 14 then sda_int <= picture(to_integer(pix_counter))(4); scl_int <= '1';
                        elsif counter = 15 then sda_int <= picture(to_integer(pix_counter))(4); 
                        elsif counter = 16 then sda_int <= picture(to_integer(pix_counter))(3); -- Bit 5
                        elsif counter = 17 then sda_int <= picture(to_integer(pix_counter))(3); scl_int <= '1';
                        elsif counter = 18 then sda_int <= picture(to_integer(pix_counter))(3); scl_int <= '1';
                        elsif counter = 19 then sda_int <= picture(to_integer(pix_counter))(3); 
                        elsif counter = 20 then sda_int <= picture(to_integer(pix_counter))(2); -- Bit 6
                        elsif counter = 21 then sda_int <= picture(to_integer(pix_counter))(2); scl_int <= '1';
                        elsif counter = 22 then sda_int <= picture(to_integer(pix_counter))(2); scl_int <= '1';
                        elsif counter = 23 then sda_int <= picture(to_integer(pix_counter))(2); 
                        elsif counter = 24 then sda_int <= picture(to_integer(pix_counter))(1); -- Bit 6
                        elsif counter = 25 then sda_int <= picture(to_integer(pix_counter))(1); scl_int <= '1';
                        elsif counter = 26 then sda_int <= picture(to_integer(pix_counter))(1); scl_int <= '1';
                        elsif counter = 27 then sda_int <= picture(to_integer(pix_counter))(1); 
                        elsif counter = 28 then sda_int <= picture(to_integer(pix_counter))(0); -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= picture(to_integer(pix_counter))(0); scl_int <= '1';
                        elsif counter = 30 then sda_int <= picture(to_integer(pix_counter))(0); scl_int <= '1';
                        elsif counter = 31 then sda_int <= picture(to_integer(pix_counter))(0); 
                        elsif counter = 32 then sda_int <= 'Z';                                  -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z';                                  scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z';                                  scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z';                                  
                        elsif counter = 36 then sda_int <= '0';                                  -- PAUSE
                        elsif counter = 37 then sda_int <= '0';                                  
                            counter <= (others => '0');
                            if pix_counter < 1025 then
                                phase       <= P_PIC;
                                state       <= S_STOP;
                                pix_counter <= pix_counter + 1;
                            else
                                phase       <= P_END;
                                state       <= S_STOP;
                                pix_counter <= (others => '0');
                            end if;
                        end if;
                    when others =>
                        state <= S_IDLE;
               end case;
            end if;
        end if;
    end process;
end behavior;

