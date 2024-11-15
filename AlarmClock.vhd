library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AlarmClock is
    Port (    
              clk : in std_logic;
              rst : in std_logic;
              sw1 : in std_logic;
              sw2 : in std_logic;
              sw3 : in std_logic;
              sw4 : in std_logic;
              hex_1out : out std_logic_vector(6 downto 0);
              hex_2out : out std_logic_vector(6 downto 0);
              hex_3out : out std_logic_vector(6 downto 0);
              hex_4out : out std_logic_vector(6 downto 0);
              bell : out std_logic
           );
end AlarmClock;

architecture Behavioral of AlarmClock is

    -- Component declaration for Two_Digit_Splitter
    component Two_Digit_Splitter
        Port (
            data_in  : in  std_logic_vector(6 downto 0);
            hex_1out : out std_logic_vector(6 downto 0);
            hex_2out : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Component declaration for Clock_Divider
    component Clock_Divider
        Port (
            clock_in  : in  std_logic;
            clock_out : out std_logic
        );
    end component;

    signal data_hrs_s, data_min_s : std_logic_vector(6 downto 0);
    signal alarm_val_hrs_s, alarm_val_min_s, time_hrs_s, time_min_s : unsigned(6 downto 0);
    signal counter_s : unsigned(31 downto 0);
    signal clk_div_s, alarm_active_s, alarm_sel_s : std_logic;

    type state_t is (TIM3, SET_TIME, SET_ALARM);
    signal state_r: state_t;

begin

    -- Instantiate the Two_Digit_Splitter component for hours display
    U_HRS : Two_Digit_Splitter
        Port map(
            data_in => data_hrs_s,
            hex_1out => hex_3out,
            hex_2out => hex_4out
        );

    -- Instantiate the Two_Digit_Splitter component for minutes display
    U_MIN : Two_Digit_Splitter
        Port map(
            data_in => data_min_s,
            hex_1out => hex_1out,
            hex_2out => hex_2out
        );

    -- Instantiate the Clock_Divider component
    U_CLK_DIV : Clock_Divider
        Port map(
            clock_in => clk,
            clock_out => clk_div_s
        );

    -- State machine process
    sync_proc: process(clk_div_s, rst)
    begin
        if(rst = '1') then
            state_r <= TIM3;
            bell <= '0';
            alarm_active_s <= '0';
            alarm_sel_s <= '0';
            alarm_val_hrs_s <= (others => '0');
            alarm_val_min_s <= (others => '0');
            time_hrs_s <= (others => '0');
            time_min_s <= (others => '0');
        elsif(rising_edge(clk_div_s)) then
            case(state_r) is
              when TIM3 =>
                -- Check if the alarm should ring
                if ((alarm_val_hrs_s = time_hrs_s) and (alarm_val_min_s = time_min_s) and alarm_active_s = '1') then
                    bell <= '1';
                   end if;

                -- Increment time
                if(time_hrs_s = 23 and time_min_s = 59) then
                    time_hrs_s <= (others => '0');
                    time_min_s <= (others => '0');
                elsif(time_min_s = 59) then
                    time_hrs_s <= time_hrs_s + 1;
                    time_min_s <= (others => '0');
                else
                    time_min_s <= time_min_s + 1;
                end if;

                -- Check for state transitions
                if(sw1 = '1') then
                    state_r <= SET_TIME;
                elsif(sw2 = '1') then
                    alarm_sel_s <= '1';
                    state_r <= SET_ALARM;
                end if;

              when SET_TIME =>
                -- Increment time
                if(sw1 = '0') then
                    state_r <= TIM3;
                else
                    if(sw3 = '1') then
                        if(time_min_s = 59) then
                            time_min_s <= (others => '0');
                        else
                            time_min_s <= time_min_s + 1;
                        end if;
                    elsif(sw4 = '1') then
                        if(time_hrs_s = 23) then
                            time_hrs_s <= (others => '0');
                        else
                            time_hrs_s <= time_hrs_s + 1;
                        end if;
                    end if;
                end if;

              when SET_ALARM =>
                -- Set alarm
                if(sw2 = '0') then
                    alarm_active_s <= '1';
                    alarm_sel_s <= '0';
                    state_r <= TIM3;
                else
                    if(sw3 = '1') then
                        if(alarm_val_min_s = 59) then
                            alarm_val_min_s <= (others => '0');
                        else
                            alarm_val_min_s <= alarm_val_min_s + 1;
                        end if;
                    elsif(sw4 = '1') then
                        if(alarm_val_hrs_s = 23) then
                            alarm_val_hrs_s <= (others => '0');
                        else
                            alarm_val_hrs_s <= alarm_val_hrs_s + 1;
                        end if;
                    end if;
                end if;
            end case;
        end if;
    end process;

    -- Handle hour and minute data selection for time or alarm display
    data_hrs_s <= std_logic_vector(time_hrs_s) when (alarm_sel_s = '0') else std_logic_vector(alarm_val_hrs_s);
    data_min_s <= std_logic_vector(time_min_s) when (alarm_sel_s = '0') else std_logic_vector(alarm_val_min_s);

end architecture;
