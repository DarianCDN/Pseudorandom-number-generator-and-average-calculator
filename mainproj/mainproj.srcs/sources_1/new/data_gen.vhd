library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_gen is
    port(   CLK: in std_logic;
           CTRL: in std_logic_vector(2 downto 0);
            VAL: out std_logic_vector(7 downto 0);
           CERR: out std_logic;
        DATACLK: out std_logic);
end entity;

architecture dg_arch of data_gen is
    component clk1hz is
    Port (  clk100: in STD_LOGIC;
            clk1hz: out std_logic);
    end component;
    
    component clk25 is
    Port ( clk1hz : in STD_LOGIC;
            clk25: out std_logic);
    end component;
    
    component stud1 is
    Port ( CLK : in STD_LOGIC;
           SEQ1 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component stud2 is
    Port ( CLK : in STD_LOGIC;
           SEQ2 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component prbs4gen is
    Port ( CLK : in STD_LOGIC;
           PRBS4 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component prbs8gen is
    Port ( CLK : in STD_LOGIC;
           PRBS8 : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal tDCLK:std_logic;
    signal CLOCK25:std_logic;
    signal inDATACLK: std_logic;
    
    signal seq1:std_logic_vector(7 downto 0):="00000000";   -- important to note that all but PRBS8 generate 4 bit outputs so the most significant 4 bits will be 
    signal seq2:std_logic_vector(7 downto 0):="00000000";   -- padded with '0' for further 8-bit signal transmission
    signal prbs4:std_logic_vector(7 downto 0):="00000000";
    signal prbs8:std_logic_vector(7 downto 0):="00000000";
    
begin

    CLKDIV: clk1hz port map (clk100=>CLK, clk1hz=>tDCLK); -- 1hz clock divider
    CLKDIV25: clk25 port map (clk1hz=>tDCLK, clk25=>CLOCK25); -- 0.25 clk freq divider
            
    inDATACLK<= CLOCK25 when CTRL="001" else    -- selection of frequency in function of CTRL
              tDCLK;
              
    DATACLK<= inDATACLK;
              
    STUD1GEN: stud1 port map (CLK=>inDATACLK, SEQ1=>SEQ1(3 downto 0));
    
    STUD2GEN: stud2 port map (CLK=>inDATACLK, SEQ2=>SEQ2(3 downto 0));
    
    PRBS4generator: prbs4gen port map (CLK=>inDATACLK, PRBS4=>PRBS4(3 downto 0));
    
    PRBS8generator: prbs8gen port map (CLK=>inDATACLK, PRBS8=>PRBS8);

    VAL<= "00000000" when CTRL="000" else         
          SEQ1 when CTRL="001" else               
          SEQ1 when CTRL="010" else               -- in case of the configuration involving the 0.25 clock frequency, the first predetermined sequence will be used
          SEQ2 when CTRL="011" else
          "00000000" when CTRL="100" else         -- in case of invalid CTRL configurations, error will appear and the value transmissed is 0 as to have no impact
          "00000000" when CTRL="101" else         -- on the values taken in for addition, and later, average computation
          PRBS4 when CTRL="110" else
          PRBS8;
          
    CERR<= '1' when CTRL="100" else
           '1' when CTRL="101" else
           '0';
    
end architecture;