library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
port(   CLK: in std_logic;
          RESET: in std_logic;
             BF: in std_logic;
             NS: in std_logic;
           LOAD: out std_logic;
             PL: out std_logic;
             SR: out std_logic);
end CU;

architecture Behavioral of CU is

signal state, nxstate: STD_LOGIC_VECTOR (1 DOWNTO 0);


begin

update_state: process(clk)
    begin
    if reset = '1' then
        state <= "00";
    elsif clk'event and clk = '1' then
        state <= nxstate;
    end if;
end process;

transitions: process(state, BF, NS)
begin
    LOAD <= '0'; PL <= '0'; SR <= '0';
    case state is
    when "00" =>
         nxstate <= "01"; SR <= '0'; load <= '0';
    
    when "01" => 
        if BF='1' then PL<='1'; nxstate<="10"; SR<='0'; LOAD<='0';
                else nxstate<="01"; PL<='0'; SR<='0'; LOAD<='0';
                end if;
    when "10" =>
       if NS='1' then LOAD<='1'; nxstate<="01"; PL<='0'; SR<='0';
                else SR<='1'; nxstate<="10"; PL<='0'; LOAD<='0';
                end if; 
    when others=> 
            LOAD <= '0'; PL <= '0'; SR <= '0';
            nxstate <= "00";
    end case;
end process;
    
 
end Behavioral;
