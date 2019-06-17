--Wojciech Porêbiñski
--236246
--pod³¹czenie magistrali UART, która s³u¿y tylko do odbierania danych - brak nadawania z LCD
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity UART_periph is

port (
	data_out: out std_logic_vector(7 downto 0);
	r_irq :out std_logic; -- odebrany bajt
	clk :in std_logic;
	reset :in std_logic;
	TX : out std_logic;
	RX : in std_logic
);

end UART_periph;

architecture UART_arch of UART_periph is


type r_STANY is (r_start_bit, r_wait , recv); -- deklaracja typu wyliczeniowego

signal r_stan, r_stan_nast : r_STANY; -- sygna³y: stan i r_stan_nast typu STANY;
signal slope : std_logic; --sygna³ gdy pojawia sie bit start
signal r_bit_cnt : std_logic_vector(3 downto 0); --licznik bitów
signal r_op_cnt : std_logic_vector(3 downto 0); --licznik impulsów taktuj¹cych odbiornik -> 16clk/bit
signal bit_line : std_logic; -- linia wewnêtrzna do wpisu bitów do rejestru przesuwnego 
signal r_op_reg : std_logic_vector(7 downto 0); -- rejestr przesuwny
signal r_out_reg : std_logic_vector(7 downto 0); --rejestr wyjœciowy do którgo ma dostêp procesor
signal b8, b9, b10: std_logic; -- rejestry przechowuj¹ce dane z 8,9,10 taktu zegara w bicie
signal slope_a, slope_b: std_logic; -- rejestry s³u¿ace wykrywaniu zbocza opadaj¹cego dla bitu start

signal n_data_bit : std_logic_vector(3 downto 0); --rejestr - liczba bitów odbieranych / wysy³anych danych  




begin

		
reg_prog : process(clk,reset)
begin
	if reset = '1' then
		n_data_bit <= "1000"; --domyœlnie 8 bitów
	--elsif clk'event and clk='1' then
		--if (address = n_data_bit_addr and nr_w ='1' ) then 
			--n_data_bit <= data_in(3 downto 0);
		--end if;			
	end if;
end process reg_prog;		
		
--odbiornik

r_reg:process(clk,reset)
begin
	if (reset='1')then
	r_stan <= r_wait;
	elsif(clk'event and clk='1') then
	r_stan <= r_stan_nast;
	end if;
end process r_reg;

r_komb:process(slope, r_op_cnt, r_bit_cnt, RX)   --proces kombinacyjny opisuj¹cy przejœcia miêdzy stanami automatu
begin
	r_stan_nast<= r_stan; 
	case r_stan is 		
		when r_wait =>
			if (slope='1') then
			r_stan_nast<= r_start_bit;
			end if;
		
		when r_start_bit =>
			if bit_line = '0' and r_op_cnt = "1111" then --sprawdzaj czy jest dobra wartoœæ bitu z g³osowania dopiero na koñcu licznika
			r_stan_nast<= recv;
			end if;
			if bit_line = '1' and r_op_cnt = "1111" then   
			r_stan_nast<= r_wait;
			end if;
		
		when recv =>
			if r_bit_cnt = n_data_bit then
			r_stan_nast<= r_wait;
			end if;
	end case;
end process r_komb;

r_bit_counter : process(clk,reset)
begin
	if reset = '1' then
		r_bit_cnt <= "0000";
	elsif clk'event and clk='1' then
		if (r_stan = recv AND r_op_cnt ="1111") then --liczy co 16 cykli zegara gdy jest w stanie odbioru
			r_bit_cnt <= r_bit_cnt + 1;
		end if;	
		if r_stan = r_wait then
		r_bit_cnt <= "0000";
		end if;
	end if;
end process r_bit_counter;


op_counter : process(clk,reset)
begin
	if reset ='1' then
		r_op_cnt <= "0000";
	elsif (clk'event and clk='1') then
		if (r_stan = recv or r_stan = r_start_bit) then --liczy ci¹gle gdy jest w stanie odbierania lub pojawienia sie bitu start
			r_op_cnt <= r_op_cnt + 1;
		end if;
		if r_stan = r_wait or r_bit_cnt= n_data_bit then
			r_op_cnt <= "0000";
		end if;
		
	end if;
end process op_counter;


main : process (clk, reset)
begin
	if reset = '1' then 
		b8<='0';
		b9<='0';
		b10<='0';
		r_op_reg<= (others =>'0');
		r_out_reg<= (others =>'0');
		r_irq <= '0';
	elsif clk'event and clk='1' then
	
		--tu wykrywanie opdaj¹cego zbocza gdy nie ma odbioru
		if r_stan = r_wait then
			slope_a <= RX;
			slope_b <= slope_a;
			  -- reszta za procesem... 
		end if;
		
		-- tu przepisywanie do rejestrów z wejœcia w odpowiednich chwilach: OK
		if r_op_cnt = "1000" then
			b8 <= RX;
		end if; 
		if r_op_cnt = "1001" then
			b9 <= RX;
		end if; 
		if r_op_cnt = "1010" then
			b10 <= RX;
		end if; 
		
		-- przepisanie bitu z bloku decyzyjnego do rejestru przesuwnego
		if r_op_cnt = "1111" then 
		r_op_reg <= r_op_reg(6 downto 0) & bit_line;
		end if;
		
		-- przepisanie do rejestru wyjœiowego i zg³oszenie przerwania
		if r_bit_cnt = n_data_bit then
			r_out_reg <= r_op_reg;
			--r_irq <= '1'; --to by³o i dzia³a³o dwa przebiegi
		--else 
			--r_irq<='0';
		end if;
		
		-- dodane bloki generacji przerwañ
		
		
		if r_bit_cnt=n_data_bit and r_stan=recv then --UWAGA, r_stan jest kluczowy - obecnie wczeœnie, z R_wait mo¿e byæ póŸno
			r_irq<='1';
		else
			r_irq<='0';
		end if;
		
	end if;

end process main;

-- do zbocza opadaj¹cego
slope <=  (not slope_a) and slope_b; 


--co zapisaæ (8,9,10 bit decyduj¹)
bit_line <= '1' when  ( b8='1' and b9='1' and b10='1' ) or ( b8='0' and b9='1' and b10='1' ) or
		( b8='1' and b9='1' and b10='0' ) or ( b8='1' and b9='0' and b10='1')	else '0';  

data_out<=r_out_reg;

--brak modu³u nadajnika - LCD nie nadaje

end UART_arch;

