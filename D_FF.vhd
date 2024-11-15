library ieee;
use ieee.std_logic_1164.all;

entity D_FF is 
port(
    clk: in std_logic;
    reset : in std_logic;
    D : in std_logic;
    Q : out std_logic
);
end D_FF;

architecture behavior of D_FF is
begin 
    process(clk, reset)
    begin 
        if (reset = '0') then --active low reset
            Q <= '0';
        elsif (clk' event and clk ='0') then
            Q<=D;
        end if;
    end process;
end behavior;