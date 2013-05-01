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
    f1: for i in 0 to 9 generate
        if11: if i = 0 or i = 9 generate
            s1out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 1);
            add11: adder port map (
                A => s1out(i),
                B => Input(i),
                O => a2out(i)
            );
        end generate if11;
        if12: if i = 1 or i = 8 generate
            s1out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 4);
            s2out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 3);
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
        if13: if i = 2 or i = 7 generate
            s1out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 6);
            s2out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 5);
            add31: adder port map (
                A => s1out(i),
                B => s2out(i),
                O => a2out(i)
            );
        end generate if13;
        if14: if i = 3 or i = 6 generate
            s1out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 8);
            s2out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 7);
            add41: adder port map (
                A => s1out(i),
                B => s2out(i),
                O => a2out(i)
            );
        end generate if14;
        if15: if i = 4 or i = 5 generate
            s1out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 10);
            s2out(i) <= to_stdLogicVector(to_bitVector(Input(i)) sll 11);
            add51: adder port map (
                A => s1out(i),
                B => s2out(i),
                O => a1out(i)
            );
            add52: adder port map (
                A => a1out(i),
                B => Input(i),
                O => a2out(i)
            );
        end generate if15;
    end generate f1; 
--    mout(0) <= to_stdLogicVector(to_bitVector(Input(0)) sll 2 + 1);
--    mout(1) <= to_stdLogicVector(to_bitVector(Input(1)) sll 4 + to_bitVector(Input(1)) sll 3 + 1);
--    mout(2) <= to_stdLogicVector(to_bitVector(Input(2)) sll 6 + to_bitVector(Input(2)) sll 5);
--    mout(3) <= to_stdLogicVector(to_bitVector(Input(3)) sll 8 + to_bitVector(Input(3)) sll 7);
--    mout(4) <= to_stdLogicVector(to_bitVector(Input(4)) sll 11 + to_bitVector(Input(4)) sll 10 + 1);
--    mout(5) <= to_stdLogicVector(to_bitVector(Input(5)) sll 11 + to_bitVector(Input(5)) sll 10 + 1);
--    mout(6) <= to_stdLogicVector(to_bitVector(Input(6)) sll 8 + to_bitVector(Input(6)) sll 7);
--    mout(7) <= to_stdLogicVector(to_bitVector(Input(7)) sll 6 + to_bitVector(Input(7)) sll 5);
--    mout(8) <= to_stdLogicVector(to_bitVector(Input(8)) sll 4 + to_bitVector(Input(8)) sll 3 + 1);
--    mout(9) <= to_stdLogicVector(to_bitVector(Input(9)) sll 2 + 1);
	
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

