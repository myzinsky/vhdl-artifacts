library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        up    : in  STD_LOGIC;
        down  : in  STD_LOGIC;
        value : out STD_LOGIC_VECTOR(2 downto 0)
    );
end fsm;

architecture behavior of fsm is
type state_t is (S0, S1, S2, S3, S4, S5);
signal state : state_t := S0;

begin

    THREAD : process (clk)
    begin
        if (rst = '1') then
            state <= S0;
            value <= "000";
        elsif (rising_edge(clk)) then
            case state is
                when S0 => 
                    if (up = '1') then
                        value <= "001";
                        state <= S1;
                    end if;
                    if (down = '1') then
                        value <= "101";
                        state <= S5;
                    end if;
                when S1 => 
                    if (up = '1') then
                        value <= "010";
                        state <= S2;
                    end if;
                    if (down = '1') then
                        value <= "000";
                        state <= S0;
                    end if;
                when S2 => 
                    if (up = '1') then
                        value <= "011";
                        state <= S3;
                    end if;
                    if (down = '1') then
                        value <= "001";
                        state <= S1;
                    end if;
                when S3 => 
                    if (up = '1') then
                        value <= "100";
                        state <= S4;
                    end if;
                    if (down = '1') then
                        value <= "010";
                        state <= S2;
                    end if;
                when S4 => 
                    if (up = '1') then
                        value <= "101";
                        state <= S5;
                    end if;
                    if (down = '1') then
                        value <= "011";
                        state <= S3;
                    end if;
                when S5 => 
                    if (up = '1') then
                        value <= "000";
                        state <= S0;
                    end if;
                    if (down = '1') then
                        value <= "100";
                        state <= S4;
                    end if;
            end case;
        end if;
   end process;
end behavior;
