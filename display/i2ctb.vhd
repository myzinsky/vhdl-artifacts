library ieee;
use ieee.std_logic_1164.all;

entity i2ctb is
end i2ctb;

architecture tb of i2ctb is
    signal clk        : std_logic := '0'; 
    signal reset_n    : std_logic := '0'; 
    signal clk_enable : std_logic := '0'; 
    signal start      : std_logic; 
    signal ready      : std_logic; 
    signal data       : std_logic_vector(7 downto 0); 
    signal command    : std_logic_vector(7 downto 0); 
    signal scl        : std_logic; 
    signal sda        : std_logic; 
    signal finished   : std_logic := '0';

begin
    clock : entity work.i2c_clock port map (
        clk        => clk,
        clk_enable => clk_enable
    );

    UUT : entity work.i2c port map (
        clk        => clk,
        reset_n    => reset_n,
        clk_enable => clk_enable,
        --start      => start,
        --addr       => "Z1-1-1Z",
        ----addr       => "0111100",
        --command    => command,
        --rw         => '0',
        --data       => data, 
        --ready      => ready,
        i2c_scl    => scl,
        i2c_sda    => sda
    );
    
   --UUT2: entity work.init_1306 port map (
   --     clk     => clk,
   --     reset_n => reset_n,
   --     start   => start,
   --     ready   => ready,
   --     data    => data,
   --     command => command
   --);

    clk <= not clk after 10.4166667 ns when finished /= '1' else '0';

    STIMULUS: process
    begin
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 1 ms;
        finished <= '1';
        wait;
    end process STIMULUS;

end tb ;
