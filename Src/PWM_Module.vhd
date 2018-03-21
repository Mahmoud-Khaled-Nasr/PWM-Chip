library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Module is 
	generic (
		PWM_BUFFER_BYTE_SIZE : INTEGER := 2;
		CLOCK_PERIOD : TIME := 10 ps
	);
	port (
		PWM_ENABLE : in std_logic;
		DUTY_CYCLE : in std_logic_vector (8*PWM_BUFFER_BYTE_SIZE - 1 downto 0);
		PWM_SIGNAL : out std_logic
	);
end PWM_Module;


architecture PWM_Module_Arch of PWM_Module is 
	constant PWM_BUFFER_BIT_SIZE : integer := 8 * PWM_BUFFER_BYTE_SIZE ;
	signal high_counter, low_counter, ZERO_COUNTER 
		: std_logic_vector (PWM_BUFFER_BYTE_SIZE * 8 - 1 downto 0);
	signal clk, start : std_logic := '0';
begin
	
	ZERO_COUNTER <= (others => '0');
	
	---------------------------------------------------------------------------
	-------------Create the PWM Clock------------------------------------------
	Create_Clock : process 
	begin
		clk <= '0';
		wait for CLOCK_PERIOD / 2;
		clk <= '1';
		wait for CLOCK_PERIOD / 2;
	end process Create_Clock;
	
	---------------------------------------------------------------------------
	-------------Generate the PWM signal---------------------------------------
	PWM_Signal_Generation : process (PWM_ENABLE, clk)
		variable writing_conditions : boolean;
	begin
		writing_conditions := rising_edge(clk) and start = '1' ;
		--initialize the Counters at the rising edge of the enable signal
		if rising_edge(PWM_ENABLE)then
			high_counter <= DUTY_CYCLE;
			low_counter <= 2 ** PWM_BUFFER_BIT_SIZE - DUTY_CYCLE;
			start <= '1';
		elsif writing_conditions and high_counter /= ZERO_COUNTER then
			high_counter <= high_counter - '1';
			PWM_SIGNAL <= '1';
		elsif writing_conditions and high_counter = ZERO_COUNTER and low_counter /= ZERO_COUNTER then
			low_counter <= low_counter - '1';
			PWM_SIGNAL <= '0';
		elsif writing_conditions and high_counter = ZERO_COUNTER and low_counter = ZERO_COUNTER then
			high_counter <= DUTY_CYCLE;
			low_counter <= 2 ** PWM_BUFFER_BIT_SIZE - DUTY_CYCLE;
		end if;
	end process PWM_Signal_Generation;
end PWM_Module_Arch;


