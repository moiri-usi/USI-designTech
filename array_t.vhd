library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

PACKAGE array_t IS
	TYPE array32_t IS array (natural range <>) of std_logic_vector(31 downto 0);
	TYPE array_int_t IS array (natural range <>) of integer;
	constant fir_const: array32_t(0 to 9) := (
		x"00000003",
		x"00000019",
		x"00000060",
		x"00000180",
		x"00000C01",
		x"00000C01",
		x"00000180",
		x"00000060",
		x"00000019",
		x"00000003"
	);
END array_t;
