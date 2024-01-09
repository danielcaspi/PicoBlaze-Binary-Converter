library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity in_reg is
generic(n: positive := 4);
    Port ( d : in STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in STD_LOGIC;
           EN : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR(7 downto 0));
end in_reg;

architecture Behavioral of in_reg is

signal read: std_logic_vector(7 downto 0);
begin

process(clk)
begin
if rising_edge(clk) then
read<=('0','0','0','0',d(0),d(1),d(2),d(3));
end if;
end process;

process (EN)
begin
if (EN='1') then
q<=read;
end if;
end process;
end Behavioral;
