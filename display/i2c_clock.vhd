library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_clock is
    PORT(
        clk        : in  std_logic;
        clk_enable : out std_logic
    );
end i2c_clock;

architecture behavior of i2c_clock is
    signal scl_trigger   : std_logic := '0';
    signal clk_counter   : unsigned(8 downto 0) := (others => '0');
begin
    clk_enable <= scl_trigger;

    i2c_clock_generation : process(clk)
    begin
        if rising_edge(clk) then
            scl_trigger <= '0';
            clk_counter <= clk_counter + 1;        
            if(clk_counter = 30) then
                scl_trigger <= '1';
                clk_counter <= (others => '0');
            end if;
        end if;
    end process;
end behavior;
