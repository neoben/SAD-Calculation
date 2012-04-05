-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name	: sad_test.vhd  
-- Purpose	: TEST Calcolo SAD  
--		: somma delle differenze in valore assoluto pixel a pixel
--		: tra due blocchi di immagini monocromatiche A e B
--
--
-- Library   	: IEEE
-- Author(s) 	: Carmine Benedetto, Silvio Bianchi
-- Copyrigth 	: Creative Commons Attribution-ShareAlike 3.0 Unported License
--           	: http://creativecommons.org/licenses/by-sa/3.0/
--
-- Simulator 	: GHDL 0.29 (20100109) [Sokcho edition]
--	     	: GTKWave Analyzer v3.3.10 (w)1999-2010 BSI	
-------------------------------------------------------------------------------
-- Revision List
-- Version	Author					Date		Changes
--
-- 1.0		Carmine Benedetto, Silvio Bianchi	21/09/2011	New version
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity sad_tb is 
end sad_tb;

architecture sad_test of sad_tb is

component sad_c

	port(
		PA		: in std_logic_vector(7 downto 0);
		PB		: in std_logic_vector(7 downto 0);
		clk		: in std_logic;
		reset		: in std_logic;
		enable		: in std_logic;
		SAD		: out std_logic_vector(15 downto 0);
		data_valid	: out std_logic
	);

end component;

-- segnali in ingresso
signal PA 	: std_logic_vector(7 downto 0)	:= "00000101";
signal PB 	: std_logic_vector(7 downto 0)	:= "00001010";
signal clk	: std_logic				:= '0';
signal reset	: std_logic				:= '0';
signal enable 	: std_logic				:= '1';

-- segnali di uscita
signal SAD		: std_logic_vector(15 downto 0);
signal data_valid	: std_logic;


-- elementi utili ad impostare il clock
constant mcp		: time 		:= 200 ns; 	-- master clock period
constant len 		: integer 	:= 1024;	-- lunghezza della simulazione -> numero di cicli
signal testing		: boolean	:= true; 	-- indica test in corso
signal clk_cycle 	: integer;			-- cicli di clock


begin

	-- mappaggio delle porte <sad_c>
	sad_port : sad_c port map (
			PA => PA,
			PB => PB,
			clk => clk,
			reset => reset,
			enable => enable,
			SAD => SAD,
			data_valid => data_valid
		);

	
	-- generazione del clock	
	clk <= not clk after mcp/2 when testing else '0';

	-- processo attivo per tutta la durata della simulazione
	run : process(clk)

	variable count : integer := 0; 	-- conta i cicli di clock

	begin

		clk_cycle <= (count+1)/2;
		
		case count is
			when 3 => reset <= '1';			-- segnale di reset attivo
			when 6 => reset <= '0';			-- segnale di reset disattivo
			when 20 => enable <= '0';		-- segnale di enable disattivo
			when 30 => enable <= '1';		-- segnale di enable attivo
			when (len -1) => testing <= false;
			when others => null;
		end case;
		count := count + 1;

	end process run;

end;

