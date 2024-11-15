library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Two_Digit_Splitter is
    Port ( 
        data_in  : in  std_logic_vector(6 downto 0);
        hex_1out : out std_logic_vector(6 downto 0);  -- Ones position
        hex_2out : out std_logic_vector(6 downto 0)   -- Tens position
    );
end Two_Digit_Splitter;

architecture Behavioral of Two_Digit_Splitter is

    -- Component declaration for Converter
    component Converter
        Port (
            number_in  : in  std_logic_vector(3 downto 0);
            number_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal hex1_s, hex2_s: std_logic_vector(3 downto 0);
    signal data_s : unsigned(6 downto 0);
	 
begin

    -- Instantiate Converter for ones position
    U_HEX0: Converter
        Port map(
            number_in  => hex1_s,
            number_out => hex_1out
        );

    -- Instantiate Converter for tens position
    U_HEX1: Converter
        Port map(
            number_in  => hex2_s,
            number_out => hex_2out
        );

    -- Process to split the 2-digit number into individual digits
    process(data_s)
    begin
        hex1_s <= (others => '0');  -- Initialize ones position
        hex2_s <= (others => '0');  -- Initialize tens position
        
        -- Handle out-of-range case (values greater than 99)
        if (data_s > to_unsigned(99, 7)) then  -- Use to_unsigned for comparison
            hex1_s <= (others => 'U');  -- Undefined digit for error case
            hex2_s <= (others => 'U');
        elsif data_s < to_unsigned(10, 7) then  -- Use to_unsigned for comparison
            hex1_s <= std_logic_vector(data_s(3 downto 0));  -- Single digit in the ones place
            hex2_s <= "0000";  -- No value in the tens place
        else
            -- Split data_s into tens and ones
            hex2_s <= std_logic_vector(to_unsigned(to_integer(data_s) / 10, 4));  -- Tens place
            hex1_s <= std_logic_vector(to_unsigned(to_integer(data_s) mod 10, 4));  -- Ones place
        end if;
    end process;

    -- Convert the input to unsigned for easier arithmetic
    data_s <= unsigned(data_in);

end Behavioral;
