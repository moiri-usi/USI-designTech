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

	signal s1out : array32_t(0 to 4);
	signal s2out : array32_t(0 to 4);
	signal a1out : array32_t(0 to 4);
	signal a2out : array32_t(0 to 4);
	signal a3out : array32_t(0 to 4);
	signal aout : array32_t(0 to 8);
	
begin
    add1: adder port map (
        A => Input(0),
        B => Input(9),
        O => a1out(0)
    );
    add2: adder port map (
        A => Input(1),
        B => Input(8),
        O => a1out(1)
    );
    add3: adder port map (
        A => Input(2),
        B => Input(7),
        O => a1out(2)
    );
    add4: adder port map (
        A => Input(3),
        B => Input(6),
        O => a1out(3)
    );
    add5: adder port map (
        A => Input(4),
        B => Input(5),
        O => a1out(4)
    );

    s1out(0) <= to_stdLogicVector(to_bitVector(a1out(0)) sll 1);
    s1out(1) <= to_stdLogicVector(to_bitVector(a1out(1)) sll 4);
    s2out(1) <= to_stdLogicVector(to_bitVector(a1out(1)) sll 3);
    s1out(2) <= to_stdLogicVector(to_bitVector(a1out(2)) sll 6);
    s2out(2) <= to_stdLogicVector(to_bitVector(a1out(2)) sll 5);
    s1out(3) <= to_stdLogicVector(to_bitVector(a1out(3)) sll 8);
    s2out(3) <= to_stdLogicVector(to_bitVector(a1out(3)) sll 7);
    s1out(4) <= to_stdLogicVector(to_bitVector(a1out(4)) sll 10);
    s2out(4) <= to_stdLogicVector(to_bitVector(a1out(4)) sll 11);
    -- (i0 + i9)<<1 + (i0 + i9)
    add01: adder port map (
        A => s1out(0),
        B => a1out(0),
        O => a3out(0)
    );
    -- (i1 + i8)<<4 + (i1 + i8)<<3 + (i1 + i8)
    add11: adder port map (
        A => s1out(1),
        B => s2out(1),
        O => a2out(1)
    );
    add12: adder port map (
        A => a1out(1),
        B => a2out(1),
        O => a3out(1)
    );
    -- (i2 + i7)<<6 + (i2 + i7)<<5
    add21: adder port map (
        A => s1out(2),
        B => s2out(2),
        O => a3out(2)
    );
    -- (i3 + i6)<<8 + (i3 + i6)<<7
    add32: adder port map (
        A => s1out(3),
        B => s2out(3),
        O => a3out(3)
    );
    -- (i4 + i5)<<11 + (i4 + i5)<<10 + (i4 + i5)
    add41: adder port map (
        A => s1out(4),
        B => s2out(4),
        O => a2out(4)
    );
    add42: adder port map (
        A => a1out(4),
        B => a2out(4),
        O => a3out(4)
    );

    f2: for i in 0 to 3 generate
        if21: if i = 0 generate
            add0: adder port map (
                A => a3out(i),
                B => a3out(i + 1),
                O => aout(i)
            );
        end generate if21;
        if22: if i > 0 generate
            add: adder port map (
                A => aout(i - 1),
                B => a3out(i + 1),
                O => aout(i)
            );
        end generate if22;
    end generate f2;  
	
	Output <= aout(3);

		
end Structural;

