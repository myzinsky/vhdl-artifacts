library ieee;
use ieee.std_logic_1164.all;

entity rslatch is
    PORT(
        R, S : in std_logic;
        Q, N : inout std_logic
    );
end rslatch;

Architecture behavior of rslatch is
begin
    PROCESS(R,S,Q,N) -- Sensitivity List
    begin
        Q <= not (R or N);
        N <= not (S or Q);
    end PROCESS;
end behavior;
