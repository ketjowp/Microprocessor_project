--Wojciech Porębiński
--bramka or do zgłaszania działania urządzeń
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity or_gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
			  c : in STD_LOGIC;
           d : out  STD_LOGIC);
end or_gate;

architecture or_arch of or_gate is

begin

d<=a or b or c;


end or_arch;

