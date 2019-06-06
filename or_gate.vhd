--bramka or
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity or_gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : out  STD_LOGIC);
end or_gate;

architecture or_arch of or_gate is

begin

c<=a or b;


end or_arch;

