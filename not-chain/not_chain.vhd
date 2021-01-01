library ieee;
use ieee.std_logic_1164.all;

entity not_chain is
    Port (
        input   : in  std_logic;
        output  : out std_logic
    );
end not_chain;

architecture behavior of not_chain is
    signal a : std_logic;
    signal b : std_logic;
begin
    not1 : entity work.not_gate port map (
        input  => input,
        output => a
    );

    not2 : entity work.not_gate port map (a, b);

    not3 : entity work.not_gate port map (b, output);

end behavior;
