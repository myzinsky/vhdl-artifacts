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

    signal rst          : std_logic;
    signal clk          : std_logic;
    signal i2c_scl_int  : std_logic;
    signal i2c_sda_int  : std_logic;
    signal start        : std_logic;
    signal ready        : std_logic;
    signal data         : std_logic_vector(7 downto 0);
    signal command      : std_logic_vector(7 downto 0);

begin
    -- Instatiation:
    clk_gen: clock port map (
        clk_48 => clk
    );

    i2c_controller : entity work.i2c port map (
        clk     => clk,
        rst     => rst,
        start   => start,
        data    => data,
        command => command,
        addr    => "0111100", -- 0x3C
        rw      => '0',
        i2c_scl => i2c_scl_int,
        i2c_sda => i2c_sda_int
    );

    i2c_1306_init : entity work.init_1306 port map (
        clk     => clk,
        rst     => rst,
        start   => start,
        ready   => ready,
        data    => data,
        command => command
    );

    --i2c_scl <= not i2c_scl_int;
    --i2c_sda <= not i2c_sda_int;
    i2c_scl <= i2c_scl_int;
    i2c_sda <= i2c_sda_int;

    process(clk)
    begin
        if rising_edge(clk) then
            led_r <= i2c_sda_int;
            led_g <= '1';
            led_b <= '1';
        end if;
    end process;
end behavior;
