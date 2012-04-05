-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name	: sad_n.vhd
-- Purpose	: Calcolo SAD 
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

entity sad_c is

	generic (
		npix 	: integer := 32 * 32;	-- numero di pixel dell'immagine
		n 	: integer := 8;		-- dimensione in bit dei pixel in ingresso
		m 	: integer := 18		-- dimensione in bit dell'uscita SAD
	);
	port(
		PA		: in std_logic_vector(n-1 downto 0);	-- pixel immagine A
		PB		: in std_logic_vector(n-1 downto 0);	-- pixel immagine B
		clk		: in std_logic;				-- segnale di clock
		reset		: in std_logic;				-- segnale di reset
		enable		: in std_logic;				-- segnale di enable
		SAD		: out std_logic_vector(m-1 downto 0);	-- uscita del circuito
		data_valid	: out std_logic				-- segnale data_valid
	);

end sad_c;

architecture behavioural of sad_c is

begin

	sad_proc : process(clk, reset)
	variable pap 		: std_logic_vector(m-1 downto 0);	-- variabile di appoggio per l'ingresso A
	variable pbp 		: std_logic_vector(m-1 downto 0);	-- variabile di appoggio per l'ingresso B
	variable cont		: integer;				-- contatore di operazioni
	variable app1		: std_logic_vector(m-1 downto 0);	-- variabile di appoggio
	variable app2 		: std_logic_vector(m-1 downto 0);	-- variabile di appoggio
	variable app3 		: std_logic_vector(m-1 downto 0);	-- variabile di appoggio
	variable padding 	: std_logic_vector(m-n-1 downto 0);	-- variabile per il padding

	begin

		for i in 0 to m-n-1 loop
			padding(i) := '0';
		end loop;

		pap := padding & PA;
		pbp := padding & PB;		
		
		--  se il segnale di reset e' attivo, azzera le variabili interne e le uscite 
		if (reset = '1') then

			for i in 0 to m-1 loop
				app1(i) := '0';
				app2(i) := '0';
				app3(i) := '0';
				SAD(i) <= '0';
			end loop;
			
			data_valid <= '0';
			cont := 0;
		
		-- se sono state effettuate 256 operazioni (16x16 pixel), il calcolo della SAD risulta concluso 
		-- l'uscita data_valid viene settata ad 1
		elsif (cont = npix) then
			data_valid <= '1';

		-- per ogni fronte in salita del clock 
		elsif (clk'event and clk = '1') then

			-- se il segnale di enable e' attivo, effettua la somma delle differenze in valore assoluto
			-- pixel per pixel, altrimenti mantiene lo stato attuale delle variabili e delle uscite
			if(enable = '1') then		
	
				app1 := std_logic_vector( unsigned (pap) - unsigned (pbp) );

				-- se la differenza assume un valore negativo, si effettua un cambio si segno...
				if (app1(n) = '1') then

					app2 := std_logic_vector( -signed (app1) );
				else 
		
					-- ... altrimenti si memorizza il valore della differenza
					app2 := app1;

				end if;

				-- somma del valore assoluto del passo attuale con il valore assoluto dei passi 
				app3 := std_logic_vector( unsigned (app2) + unsigned (app3) );
				SAD <= app3;
				-- si incrementa il contatore di operazioni effettuate
				cont := cont + 1;

			end if;

		end if;

	end process sad_proc;
		
end behavioural;

