library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.array_t.all;

entity fir_sol is
	Port ( 
		Reset : in  STD_LOGIC;
        Clk : in  STD_LOGIC;
        Input : in array32_t(0 to 9);
        Output : out  STD_LOGIC_VECTOR (31 downto 0)
	);
end fir_sol;

architecture Structural of fir_sol is

    component adder 
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;

	signal s1out : array32_t(0 to 9);
	signal s2out : array32_t(0 to 9);
	signal a1out : array32_t(0 to 9);
	signal a2out : array32_t(0 to 9);
	signal aout : array32_t(0 to 8);
	
begin
    s1out(0) <= to_stdLogicVector(to_bitVector(Input(0)) sll 1);
    s1out(9) <= to_stdLogicVector(to_bitVector(Input(9)) sll 1);
    s1out(1) <= to_stdLogicVector(to_bitVector(Input(1)) sll 4);
    s2out(1) <= to_stdLogicVector(to_bitVector(Input(1)) sll 3);
    s1out(8) <= to_stdLogicVector(to_bitVector(Input(8)) sll 4);
    s2out(8) <= to_stdLogicVector(to_bitVector(Input(8)) sll 3);
    s1out(2) <= to_stdLogicVector(to_bitVector(Input(2)) sll 6);
    s2out(2) <= to_stdLogicVector(to_bitVector(Input(2)) sll 5);
    s1out(7) <= to_stdLogicVector(to_bitVector(Input(7)) sll 6);
    s2out(7) <= to_stdLogicVector(to_bitVector(Input(7)) sll 5);
    s1out(3) <= to_stdLogicVector(to_bitVector(Input(3)) sll 8);
    s2out(3) <= to_stdLogicVector(to_bitVector(Input(3)) sll 7);
    s1out(6) <= to_stdLogicVector(to_bitVector(Input(6)) sll 8);
    s2out(6) <= to_stdLogicVector(to_bitVector(Input(6)) sll 7);
    s1out(4) <= to_stdLogicVector(to_bitVector(Input(4)) sll 10);
    s2out(4) <= to_stdLogicVector(to_bitVector(Input(4)) sll 11);
    s1out(5) <= to_stdLogicVector(to_bitVector(Input(5)) sll 10);
    s2out(5) <= to_stdLogicVector(to_bitVector(Input(5)) sll 11);
	f1: for i in 0 to 9 generate
        if11: if i = 0 or i = 9 generate
            add11: adder port map (
                A => s1out(i),
                B => Input(i),
                O => a2out(i)
            );
		end generate if11;
        if12: if i = 1 or i = 4 or i = 5 or i = 8 generate
            add21: adder port map (
                A => s1out(i),
                B => s2out(i),
                O => a1out(i)
            );
            add22: adder port map (
                A => a1out(i),
                B => Input(i),
                O => a2out(i)
            );
		end generate if12;
        if13: if i = 2 or i = 3 or i = 6 or i = 7 generate
            add31: adder port map (
                A => s1out(i),
                B => s2out(i),
                O => a2out(i)
            );
		end generate if13;
	end generate f1;  
--    mout(0) <= to_stdLogicVector(to_bitVector(Input(0)) sll 1 + Input(0));
--    mout(1) <= to_stdLogicVector(to_bitVector(Input(1)) sll 4 + to_bitVector(Input(1)) sll 3 + Input(1));
--    mout(2) <= to_stdLogicVector(to_bitVector(Input(2)) sll 6 + to_bitVector(Input(2)) sll 5);
--    mout(3) <= to_stdLogicVector(to_bitVector(Input(3)) sll 8 + to_bitVector(Input(3)) sll 7);
--    mout(4) <= to_stdLogicVector(to_bitVector(Input(4)) sll 11 + to_bitVector(Input(4)) sll 10 + Input(4));
--    mout(5) <= to_stdLogicVector(to_bitVector(Input(5)) sll 11 + to_bitVector(Input(5)) sll 10 + Inout(5));
--    mout(6) <= to_stdLogicVector(to_bitVector(Input(6)) sll 8 + to_bitVector(Input(6)) sll 7);
--    mout(7) <= to_stdLogicVector(to_bitVector(Input(7)) sll 6 + to_bitVector(Input(7)) sll 5);
--    mout(8) <= to_stdLogicVector(to_bitVector(Input(8)) sll 4 + to_bitVector(Input(8)) sll 3 + Input(8));
--    mout(9) <= to_stdLogicVector(to_bitVector(Input(9)) sll 1 + Input(9));
	
	f2: for i in 0 to 8 generate
		if21: if i = 0 generate
			add0: adder port map (
				A => a2out(i),
				B => a2out(i + 1),
				O => aout(i)
			);
		end generate if21;
		if22: if i > 0 generate
			add: adder port map (
				A => aout(i - 1),
				B => a2out(i + 1),
				O => aout(i)
			);
		end generate if22;
	end generate f2;  
	
	Output <= aout(8);

		
end Structural;

