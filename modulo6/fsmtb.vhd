library ieee;
use ieee.std_logic_1164.all;

entity fsmtb is
end fsmtb;

architecture tb of fsmtb is
    signal rst      : std_logic;  -- inputs 
    signal clk      : std_logic := '0'; -- make sure you initialise!
    signal up       : std_logic := '0';
    signal down     : std_logic := '0';
    signal finished : std_logic := '0';
    signal value    : std_logic_vector(2 downto 0) := "000";
begin

    UUT : entity work.fsm port map (
        clk   => clk,
        rst   => rst,
        up    => up,
        down  => down,
        value => value
    );

    --CLOCK:
    clk <= not clk after 0.5 ns when finished /= '1' else '0';

    STIMULUS: process
    begin
        up   <= '1';
        down <= '1';
        rst  <= '1';
        wait for 2 ns;
        rst <= '0';
        wait for 16 ns;
        finished <= '1';
        wait;
    end process STIMULUS;

end tb ;
