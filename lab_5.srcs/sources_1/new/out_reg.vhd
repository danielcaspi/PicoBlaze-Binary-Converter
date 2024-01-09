library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity out_reg is

generic(n: positive := 4);
port (clk: in std_logic;
        en: in std_logic;
		d: in std_logic_vector (7 downto 0);
		q: out std_logic_vector (n-1 downto 0));
end out_reg;

architecture Behavioral of out_reg is
signal t:std_logic_vector (7 downto 0);
begin
t<=d;
process(clk) is
begin

if (rising_edge(clk)) then
    if (en = '1') then
	   q <= (t(3),t(2),t(1),t(0));
	end if;
end if;

end process;

end Behavioral;