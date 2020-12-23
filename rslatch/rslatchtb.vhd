library ieee;
use ieee.std_logic_1164.all;

entity rslatchtb is
end rslatchtb;

architecture tb of rslatchtb is
    signal R, S : std_logic;  -- inputs 
    signal Q, N : std_logic;  -- outputs
begin
    UUT : entity work.rslatch port map (
        R => R,
        S => S,
        Q => Q,
        N => N
    );

    STIMULUS: process
        begin
        S   <= '0';
        R   <= '1';
        wait for 10 ns;
        S   <= '1';
        R   <= '0';
        wait for 20 ns;
        S <= '0';
        R <= '1';
        wait for 10 ns;
        wait;
    end process STIMULUS;

end tb ;
