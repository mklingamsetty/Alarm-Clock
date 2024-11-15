library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.round;
use ieee.std_logic_unsigned.all;

entity Clock_Divider is
    port (clock_in : in std_logic;
    clock_out : out std_logic);
end entity;

architecture logic of Clock_Divider is
signal count : std_logic_vector(31 downto 0) := (others => '0');
signal temp : std_logic := '0';
signal count_2 : std_logic_vector(3 downto 0) := (others => '0');

    begin
        process (clock_in)
        begin
            if (rising_edge(clock_in)) then
                if (unsigned(count) = to_unsigned(83333, 32)) then
                    temp <= not temp;
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end process;
        clock_out <= temp;
end architecture;