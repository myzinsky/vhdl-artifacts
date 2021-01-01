library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity not_gate is
    Port (
        input   : in  std_logic;
        output  : out std_logic
    );
end not_gate;

architecture behavior of not_gate is
begin
    output <= not input; -- Concurrent Assigment i.e. implicit process
end behavior;
