library ieee;
use ieee.std_logic_1164.all;

entity ifelsetb is
end ifelsetb;

architecture tb of ifelsetb is
    signal a, b, c, d, e, f : std_logic;  -- inputs 
    signal y                : std_logic;  -- outputs
begin
    UUT : entity work.ifelse port map (
        a => a,
        b => b,
        c => c,
        d => d,
        e => e,
        f => f,
        y => y
    );

    STIMULUS: process
        begin
        a   <= '0';
        b   <= '0';
        c   <= '0';
        d   <= '0';
        e   <= '0';
        f   <= '0';
        wait for 10 ns;
        a   <= '1';
        b   <= '0';
        c   <= '0';
        d   <= '1';
        e   <= '0';
        f   <= '0';
        wait for 20 ns;
        wait;
    end process STIMULUS;

end tb ;
