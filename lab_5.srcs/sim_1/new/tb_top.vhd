----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2023 12:42:36 AM
-- Design Name: 
-- Module Name: tb_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

component top 
Port (      clk : in std_logic;
			sw:in std_logic_vector(3 downto 0);
			rst	: in std_logic;
			leds : out std_logic_vector(3 downto 0));
end component top;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal sw : std_logic_vector(3 downto 0) := (others => '0');
   signal leds: std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
BEGIN
   
   dut: top PORT MAP (
          clk => clk,
          rst => rst,
          sw => sw,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for 100 ns;	
      rst <= '0';
      
      -- insert stimulus here 
      sw <= "1011";
      wait for 10 ms;
      sw <= "0101";
      wait for 2 ms;
      sw <= "0010";
      wait;
      
   end process;

end Behavioral;
