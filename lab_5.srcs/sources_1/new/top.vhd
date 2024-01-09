----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2023 11:26:05 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
Port (      clk : in std_logic;
			sw:in std_logic_vector(3 downto 0);
			rst	: in std_logic;
			leds : out std_logic_vector(3 downto 0));
end top;

architecture Behavioral of top is

-- processor

component kcpsm6 is
 generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                 interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
          scratch_pad_memory_size : integer := 64);
 port (                   address : out std_logic_vector(11 downto 0);
                      instruction : in std_logic_vector(17 downto 0);
                      bram_enable : out std_logic;
                          in_port : in std_logic_vector(7 downto 0);
                         out_port : out std_logic_vector(7 downto 0);
                          port_id : out std_logic_vector(7 downto 0);
                     write_strobe : out std_logic;
                   k_write_strobe : out std_logic;
                      read_strobe : out std_logic;
                        interrupt : in std_logic;
                    interrupt_ack : out std_logic;
                            sleep : in std_logic;
                            reset : in std_logic;
                              clk : in std_logic);
end component kcpsm6;

-- program ROM
component lab_5 is 
 Port (      address : in std_logic_vector(11 downto 0);
         instruction : out std_logic_vector(17 downto 0);
              enable : in std_logic;
                 clk : in std_logic);
 
 end component lab_5;

component out_reg is
generic(n: positive := 4);
port (clk: in std_logic;
        en: in std_logic;
		d: in std_logic_vector (7 downto 0);
		q: out std_logic_vector (n-1 downto 0));
end component out_reg;

component in_reg is
 generic(n: positive := 4);
    Port ( d : in STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in STD_LOGIC;
           EN : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR(7 downto 0));
end component in_reg;



--signals from the processor
signal address : std_logic_vector(11 downto 0) ;
signal instruction : std_logic_vector (17 downto 0);
signal  port_id : std_logic_vector (7 downto 0);
signal  out_port :std_logic_vector (7 downto 0);
signal in_port : std_logic_vector (7 downto 0);
signal write_strobe : std_logic  ;
signal read_strobe : std_logic  ;
signal interrupt : std_logic  ;
signal interrupt_ack : std_logic  ;
signal bram_enable,k_write_strobe: std_logic;

-- internal signals
signal choose: std_logic;
signal read_in: std_logic;

begin


processor: kcpsm6  port map(
                   address => address,
                     instruction => instruction,
                     bram_enable => bram_enable,
                         in_port => in_port,
                        out_port => out_port,
                         port_id => port_id,
                    write_strobe => write_strobe,
                  k_write_strobe => k_write_strobe,
                     read_strobe => read_strobe,
                       interrupt => '0',
                   interrupt_ack => interrupt_ack,
                           sleep => '0',
                           reset => rst,
                             clk => clk);





program_rom: lab_5 Port map (      address => address,
         instruction => instruction,
              enable => bram_enable,                             
                 clk => clk);
 

-- the following registers just buffer between the lcd and the leds to the micro controller
leds_reg: out_reg generic map(n => 4)  -- 8 bit register
port map (clk => clk,
         en => choose, 
         d => out_port,
		 q => leds);
		 
input_reg: in_reg generic map(n => 4)
           port map(d=>sw,clk=>clk,EN=>read_in,q=>in_port);

interrupt <= '0';  -- no interupt

process(write_strobe)
begin

if (write_strobe ='1') and (port_id = x"01") then
        choose <= '1';
else
        choose <= '0';
end if;
end process;

-- EN input
process(read_strobe)
begin

if (read_strobe ='1') and (port_id = x"02") then
        read_in <= '1';
else
        read_in <= '0';
end if;
end process;
end Behavioral;

