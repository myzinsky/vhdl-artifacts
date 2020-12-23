library ieee;
use ieee.std_logic_1164.all;

entity ifelse is
    PORT(
        a, b, c, d, e, f : in std_logic;
        y                : out std_logic
    );
end ifelse;

Architecture behavior of ifelse is
begin
    PROCESS(a,b,c,d,e,f) -- Sensitivity List
    begin
        IF a = '1' THEN
            y <= d;
        ELSIF b = '0' THEN
            y <= e;
        ELSIF c = '1' THEN
            y <= f;
        ELSE
            y <= '0';
        END IF;
    end PROCESS;
end behavior;
