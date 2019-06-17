library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

-- zakomentowana mo�liwo�� odbierania danych przez UART przez procesor

entity UART_new is

port (
	data_in: in std_logic_vector(7 downto 0); -- wejscie danych do peryferium z procesora
	r_irq :out std_logic; -- odebrany bajt
	t_irq :out std_logic;	-- wys�any bajt
	clk :in std_logic;
	reset :in std_logic;
	TX : out std_logic;
	RX : in std_logic
);

end UART_new;

architecture UART_a of UART_new is


--type r_STANY is (r_start_bit, r_wait , recv); -- deklaracja typu wyliczeniowego
type t_STANY is (t_start_bit, t_wait, trans, t_stop_bit); -- deklaracja typu wyliczeniowego

--signal r_stan, r_stan_nast : r_STANY; -- sygna�y: stan i r_stan_nast typu STANY;
--signal slope : std_logic; --sygna� gdy pojawia sie bit start
--signal r_bit_cnt : std_logic_vector(3 downto 0); --licznik bit�w
--signal r_op_cnt : std_logic_vector(3 downto 0); --licznik impuls�w taktuj�cych odbiornik -> 16clk/bit
--signal bit_line : std_logic; -- linia wewn�trzna do wpisu bit�w do rejestru przesuwnego 
--signal r_op_reg : std_logic_vector(7 downto 0); -- rejestr przesuwny
--signal r_out_reg : std_logic_vector(7 downto 0); --rejestr wyj�ciowy do kt�rgo ma dost�p procesor
--signal b8, b9, b10: std_logic; -- rejestry przechowuj�ce dane z 8,9,10 taktu zegara w bicie
--signal slope_a, slope_b: std_logic; -- rejestry s�u�ace wykrywaniu zbocza opadaj�cego dla bitu start

signal t_stan, t_stan_nast : t_STANY; 				-- sygna�y: stan i stan_nast typu STANY;
signal t_bit_cnt : std_logic_vector(3 downto 0); --licznik bit�w
signal t_op_cnt : std_logic_vector(3 downto 0); --licznik impuls�w taktuj�cych odbiornik -> 16clk/bit
signal t_in_reg : std_logic_vector(7 downto 0); --rejestr wej�ciowy do kt�rego wpisywane s� dane do wys�ania
signal new_data : std_logic; 							--linia, kt�ra informuje czy dane na wejsciu s� nowymi danymi
signal new_reg_a : std_logic_vector(7 downto 0); --rejestr - stwierdzenie zmiany danych
signal new_reg_b : std_logic_vector(7 downto 0); --rejestr - stwierdzenie zmiany danych 
signal n_data_bit : std_logic_vector(3 downto 0); --rejestr - liczba bit�w odbieranych / wysy�anych danych  




begin
--przepisanie na data_out gdy procesor mo�e czyta� i gdy wystawi� odpowiedni adres
--data_out <= r_out_reg when (address = r_out_reg_addr and nr_w='0') 
--		else ("0000" & r_op_cnt) when (address = r_op_cnt_addr and nr_w='0') 
--		else ("0000" & r_bit_cnt) when (address = r_bit_cnt_addr and nr_w='0') 
--		else t_in_reg when (address = t_in_reg_addr and nr_w='0') 
--		else ("0000" & t_op_cnt) when (address = t_op_cnt_addr and nr_w='0') 
--		else ("0000" & t_bit_cnt) when (address = t_bit_cnt_addr and nr_w='0') 
--		else ("0000" & n_data_bit) when (address = n_data_bit_addr and nr_w='0') 
--		else  "00000000";



		
--programowanie rejestr�w 
		
reg_prog : process(clk,reset)
begin
	if reset = '1' then
		n_data_bit <= "1000"; --domy�lnie 8 bit�w
	--elsif clk'event and clk='1' then
		--if (address = n_data_bit_addr and nr_w ='1' ) then 
			--n_data_bit <= data_in(3 downto 0);
		--end if;			
	end if;
end process reg_prog;		
		
--odbiornik

--r_reg:process(clk,reset)
--begin
--	if (reset='1')then
--	r_stan <= r_wait;
--	elsif(clk'event and clk='1') then
--	r_stan <= r_stan_nast;
--	end if;
--end process r_reg;
--
--r_komb:process(slope, r_op_cnt, r_bit_cnt, RX)   --proces kombinacyjny opisuj�cy przej�cia mi�dzy stanami automatu
--begin
--	r_stan_nast<= r_stan; 
--	case r_stan is 		
--		when r_wait =>
--			if (slope='1') then
--			r_stan_nast<= r_start_bit;
--			end if;
--		
--		when r_start_bit =>
--			if bit_line = '0' and r_op_cnt = "1111" then --sprawdzaj czy jest dobra warto�� bitu z g�osowania dopiero na ko�cu licznika
--			r_stan_nast<= recv;
--			end if;
--			if bit_line = '1' and r_op_cnt = "1111" then   
--			r_stan_nast<= r_wait;
--			end if;
--		
--		when recv =>
--			if r_bit_cnt = n_data_bit then
--			r_stan_nast<= r_wait;
--			end if;
--	end case;
--end process r_komb;
--
--r_bit_counter : process(clk,reset)
--begin
--	if reset = '1' then
--		r_bit_cnt <= "0000";
--	elsif clk'event and clk='1' then
--		if (r_stan = recv AND r_op_cnt ="1111") then --liczy co 16 cykli zegara gdy jest w stanie odbioru
--			r_bit_cnt <= r_bit_cnt + 1;
--		end if;	
--		if r_stan = r_wait then
--		r_bit_cnt <= "0000";
--		end if;
--	end if;
--end process r_bit_counter;
--
--
--op_counter : process(clk,reset)
--begin
--	if reset ='1' then
--		r_op_cnt <= "0000";
--	elsif (clk'event and clk='1') then
--		if (r_stan = recv or r_stan = r_start_bit) then --liczy ci�gle gdy jest w stanie odbierania lub pojawienia sie bitu start
--			r_op_cnt <= r_op_cnt + 1;
--		end if;
--		if r_stan = r_wait or r_bit_cnt= n_data_bit then
--			r_op_cnt <= "0000";
--		end if;
--	end if;
--end process op_counter;
--
--
--main : process (clk, reset)
--begin
--	if reset = '1' then 
--		b8<='0';
--		b9<='0';
--		b10<='0';
--		r_op_reg<= (others =>'0');
--		r_out_reg<= (others =>'0');
--		r_irq <= '0';
--	elsif clk'event and clk='1' then
--	
--		--tu wykrywanie opdaj�cego zbocza gdy nie ma odbioru
--		if r_stan = r_wait then
--			slope_a <= RX;
--			slope_b <= slope_a;
--			  -- reszta za procesem... 
--		end if;
--		
--		-- tu przepisywanie do rejestr�w z wej�cia w odpowiednich chwilach: OK
--		if r_op_cnt = "1000" then
--			b8 <= RX;
--		end if; 
--		if r_op_cnt = "1001" then
--			b9 <= RX;
--		end if; 
--		if r_op_cnt = "1010" then
--			b10 <= RX;
--		end if; 
--		
--		-- przepisanie bitu z bloku decyzyjnego do rejestru przesuwnego
--		if r_op_cnt = "1111" then 
--		r_op_reg <= r_op_reg(6 downto 0) & bit_line;
--		end if;
--		
--		-- przepisanie do rejestru wyj�iowego i zg�oszenie przerwania
--		if r_bit_cnt = n_data_bit then
--			r_out_reg <= r_op_reg;
--			r_irq <= '1';
--		else 
--			r_irq<='0';
--		end if;
--	end if;
--
--end process main;
--
---- do zbocza opadaj�cego
--slope <=  (not slope_a) and slope_b; 
--
--
---- blok decyzyjny   ---OK
--bit_line <= '1' when  ( b8='1' and b9='1' and b10='1' ) or ( b8='0' and b9='1' and b10='1' ) or
--		( b8='1' and b9='1' and b10='0' ) or ( b8='1' and b9='0' and b10='1')	else '0';  
--


--nadajnik

t_reg:process(clk,reset)
begin
	if (reset='1')then
	t_stan <= t_wait;
	elsif(clk'event and clk='1') then
	t_stan <= t_stan_nast;
	end if;
end process t_reg;

t_komb:process(t_op_cnt, t_bit_cnt, new_data)   --proces kombinacyjny opisuj�cy przej�cia mi�dzy stanami automatu
begin
	t_stan_nast<= t_stan; 
	case t_stan is 		
		when t_wait =>
			if new_data = '1' then
			t_stan_nast<= t_start_bit;
			end if;
		
		when t_start_bit =>
			if t_op_cnt = "1111" then
			t_stan_nast<= trans;
			end if;
					
		when trans =>
			if t_bit_cnt = n_data_bit then
			t_stan_nast<= t_stop_bit;
			end if;
		when t_stop_bit =>
			if t_op_cnt = "1111" then
			t_stan_nast<= t_wait;
			end if;
	end case;
end process t_komb;



t_op_counter : process(clk,reset)
begin
	if reset ='1' then
		t_op_cnt <= "0000";
	elsif (clk'event and clk='1') then
		if (t_stan /= t_wait) then --liczy ci�gle, poza czasem oczekiwania
			t_op_cnt <= t_op_cnt + 1;
		end if;
		if t_stan = t_wait or t_bit_cnt= n_data_bit then
			t_op_cnt <= "0000";
		end if;
	end if;
end process t_op_counter;


t_bit_counter : process(clk,reset)
begin
	if reset = '1' then
		t_bit_cnt <= "0000";
	elsif clk'event and clk='1' then
		if (t_stan = trans AND t_op_cnt ="1111") then --liczy co 16 cykli zegara op_cnt
			t_bit_cnt <= t_bit_cnt + 1;
		end if;	
		if t_stan = t_wait or t_stan = t_stop_bit or t_stan = t_start_bit then
		t_bit_cnt <= "0000";
		end if;
	end if;
end process t_bit_counter;


t_main : process (clk, reset)
begin
	if reset = '1' then 
		new_reg_a <= (others =>'0');
		new_reg_b <= (others =>'0');
		t_in_reg <= (others =>'0');
		t_irq <= '0'; --UWAGA
		TX <= '0'; -- DODANE,ABY NIE BY�O X przy inicjalizacji uk�adu
	elsif clk'event and clk='1' then
	
		--przepisanie z we do wejsciowego rejestru gdy procesor mo�e zapisywa� i gdy wystawi� odpowiedni adres i nie trwa transmisja
		if (t_stan = t_wait) then --odj�te address = t_in_reg_addr and nr_w ='1' and 
			t_in_reg <= data_in;
			t_irq<='0'; --UWAGA - czas trwania jeden okres
		end if;
		
		--wpisanie do rejestr�w do por�wnania czy s� nowe dane
		new_reg_a <= t_in_reg;
		new_reg_b <=new_reg_a;
		
				
		--wysy�anie danych na wyjscie szeregowe w czasie trans
		if (t_stan=trans and t_op_cnt ="1111") then-- and t_in_reg/=x"00") then --UWAGA dodany trzeci warunek, �eby da�o si� testowa�. P�niejsze rozwi�zanie - implementacja przerwa�
			TX<= t_in_reg(7);
			t_in_reg<= t_in_reg(6 downto 0) & '0'; -- tutaj zmiana, niech wchodz� zera
		end if;
		
		if (t_stan = t_stop_bit and t_op_cnt ="1111") or t_stan = t_wait  then
			TX <='1'; --wyrzucenie bitu stop.
		--end if;

		elsif (t_stan = t_start_bit and t_op_cnt ="1111") then
			TX <='0'; --wyrzucenie bitu start - zb opadaj�ce i stan niski na czas 16 * clk_period
		end if;
		
		if t_stan = t_stop_bit and t_op_cnt ="1111" then
		t_irq <= '1'; -- zg�oszenie gotowo�ci do przesy�u dalszych danych
		else 
		t_irq <= '0';
		end if;
		
	end if;

end process t_main;

-- ustalenie czy s� nowe dane: OK
new_data <= ( new_reg_b(0) XOR new_reg_a(0)) or ( new_reg_b(1) XOR new_reg_a(1)) or
( new_reg_b(2) XOR new_reg_a(2)) or ( new_reg_b(3) XOR new_reg_a(3)) or
( new_reg_b(4) XOR new_reg_a(4)) or ( new_reg_b(5) XOR new_reg_a(5))or
( new_reg_b(6) XOR new_reg_a(6)) or ( new_reg_b(7) XOR new_reg_a(7));




end UART_a;