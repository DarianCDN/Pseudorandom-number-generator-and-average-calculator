library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    port(   CLK: in std_logic;
            RST: in std_logic;
            LEN: in std_logic_vector(2 downto 0);
           CTRL: in std_logic_vector(2 downto 0);
            CAT: out std_logic_vector(6 downto 0);
             AN: out std_logic_vector(3 downto 0));
end entity;

architecture main_arch of main is
    component CU is
    port(   CLK: in std_logic;
          RESET: in std_logic;
             BF: in std_logic;
             NS: in std_logic;
           LOAD: out std_logic;
             PL: out std_logic;
             SR: out std_logic);
    end component;
    
    component EU is
    port(   CLK: in std_logic;
          RESET: in std_logic;
            LEN: in std_logic_vector(2 downto 0);
           CTRL: in std_logic_vector(2 downto 0);
           LOAD: in std_logic;
             PL: in std_logic;
             SR: in std_logic;
             BF: out std_logic;
             NS: out std_logic;
            CAT: out std_logic_vector(6 downto 0);
             AN: out std_logic_vector(3 downto 0));
    end component;
    
    signal LOAD: std_logic;
    signal PL: std_logic;
    signal SR: std_logic;
    signal BF: std_logic;
    signal NS: std_logic;
begin
    
    COMMAND_UNIT: CU port map (CLK=>CLK, RESET=>RST, BF=>BF, NS=>NS, LOAD=>LOAD, PL=>PL, SR=>SR);
    
    EXECUTION_UNIT: EU port map (CLK=>CLK, RESET=>RST, LEN=>LEN, CTRL=>CTRL, LOAD=>LOAD, PL=>PL, SR=>SR, BF=>BF, NS=>NS, CAT=>CAT, AN=>AN);
end main_arch;
