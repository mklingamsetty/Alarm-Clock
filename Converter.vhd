LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Converter IS
    PORT( 
        number_in: IN std_logic_vector(3 downto 0);
        number_out: OUT std_logic_vector(6 downto 0)
);
END Converter;


ARCHITECTURE behavior OF Converter IS
BEGIN
number_out <= 
    "1000000" when (number_in = "0000") else
    "1111001" when (number_in = "0001") else
    "0100100" when (number_in = "0010") else
    "0110000" when (number_in = "0011") else
    "0011001" when (number_in = "0100") else
    "0010010" when (number_in = "0101") else
    "0000010" when (number_in = "0110") else
    "1111000" when (number_in = "0111") else
    "0000000" when (number_in = "1000") else
    "0010000" when (number_in = "1001");
End behavior;