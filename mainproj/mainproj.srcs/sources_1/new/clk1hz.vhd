library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity clk1hz is
    Port ( clk100 : in STD_LOGIC;
            clk1hz: out std_logic);
end clk1hz;

architecture arch_n of clk1hz is
    signal n: std_logic_vector(25 downto 0):=(others=>'0');
begin
    process(CLK100)
    begin
        if CLK100'EVENT and CLK100='1' then
            n<=n+1;
        end if;
        clk1hz<=n(25);
    end process;
end architecture;
