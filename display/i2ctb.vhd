library ieee;
use ieee.std_logic_1164.all;

entity i2ctb is
end i2ctb;

architecture tb of i2ctb is
    signal rst      : std_logic;
    signal clk      : std_logic := '0'; 
    signal start    : std_logic; 
    signal ready    : std_logic; 
    signal data     : std_logic_vector(7 downto 0); 
    signal command  : std_logic_vector(7 downto 0); 
    signal scl      : std_logic; 
    signal sda      : std_logic; 
    signal finished : std_logic := '0';

begin

    UUT : entity work.i2c port map (
        clk       => clk,
        rst       => rst,
        start     => start,
        addr      => "0111100",
        command   => command,
        rw        => '0',
        data      => data, 
        ready     => ready,
        i2c_scl   => scl,
        i2c_sda   => sda
    );
    
   UUT2: entity work.init_1306 port map (
        clk     => clk,
        rst     => rst,
        start   => start,
        ready   => ready,
        data    => data,
        command => command
   );

    clk <= not clk after 10.4166667 ns when finished /= '1' else '0';

    STIMULUS: process
    begin
        wait for 100 ms;
        finished <= '1';
        wait;
    end process STIMULUS;

end tb ;
