library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
    PORT(
        led_r   : out std_logic;
        led_g   : out std_logic;
        led_b   : out std_logic;
        i2c_scl : out std_logic;
        i2c_sda : out std_logic
    );
end display;

Architecture behavior of display is

    component clock port (
        clk_48: out std_logic
    );
    end component;

    component reset port (
        clk:     in  std_logic;
        reset_n: out std_logic
    );
    end component;

    signal reset_n      : std_logic;
    signal clk          : std_logic;
    signal clk_enable   : std_logic;
    signal i2c_scl_int  : std_logic:= '1';
    signal i2c_sda_int  : std_logic:= '1';
    signal start        : std_logic;
    signal ready        : std_logic;
    signal data         : std_logic_vector(7 downto 0);
    signal command      : std_logic_vector(7 downto 0);

begin
    -- Instatiation:
    clk_gen: clock port map (
        clk_48 => clk
    );

    rst_gen: reset port map (
        clk     => clk,
        reset_n => reset_n
    );

    i2c_clock_generator: entity work.i2c_clock port map (
        clk        => clk,
        clk_enable => clk_enable
    );

    i2c_controller : entity work.i2c port map (
        clk        => clk,
        reset_n    => reset_n,
        clk_enable => clk_enable,
        i2c_scl    => i2c_scl_int,
        i2c_sda    => i2c_sda_int
    );

    i2c_scl <= i2c_scl_int;
    i2c_sda <= i2c_sda_int;

    led_b   <= i2c_scl_int;
    led_g   <= '1';
    led_r   <= '1';

    process(clk)
    begin
        if rising_edge(clk) then
        end if;
    end process;
end behavior;
