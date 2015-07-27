library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mytypes_pkg.all;
use work.extra_functions.all;

entity cic_TB is
end entity cic_TB;

architecture RTL of cic_TB is

	constant N : integer := 6;
	constant DELAY : integer := 1;
	constant R : integer := 512;
	constant B : my_array_t := (55,55,50,42,34,27,23,22,21,20,20,19,16); --bits en cada etapa
	--constant B : my_array_t := (55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55); --bits en cada etapa
	--constant CC : integer := N*R*DELAY ; --cant bits sin recortar
	--constant B : my_array_t := (CC,CC,CC,CC,CC,CC,CC); --bits en cada etapa

	signal input  : std_logic                         := '0';
	--signal output : std_logic_vector(17 - 1 downto 0) := (others => '0');
	signal output : std_logic_vector(B(2 * N) - 1 downto 0) := (others => '0');
	signal ce_in  : std_logic                         := '0';
	signal ce_out : std_logic                         := '0';
	signal clk    : std_logic                         := '0';
	signal rst    : std_logic                         := '0';

begin
	tb : entity work.cic
		generic map(
			N => N,--etapas
			DELAY => DELAY, -- delay restador
			R => R, --decimacion
			B => B --bits en cada etapa
		)
		port map(
			input  => input,
			output => output,
			clk    => clk,
			rst    => rst,
			ce_in  => ce_in,
			ce_out => ce_out
		);

	CLOCK : process is
	begin
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
	end process;

	RST_EN : process is
	begin
		input <= '0';
		ce_in <= '0';
		rst <= '1';
		wait for 30 ns;
		rst <= '0';
		wait for 20 ns;
		ce_in <= '1';
		wait for 20 ns;
		input <= '1';
--		loop
--			input <= '0';
--			wait for 20 ns;
--			input<= '1';
--			wait for 20 ns;
--		end loop;
--		loop
--			wait for 10000 us;
--			input <= '0';
--			wait for 10000 us;
--			input<= '1';
--		end loop;
	
		wait;
	end process;
end architecture RTL;
