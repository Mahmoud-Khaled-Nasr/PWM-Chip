library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity i2c_Interface_Module is 
	generic (
		WRITE_SIGNAL : std_logic:='0';
		CHIP_ADDRESS : std_logic_vector (6 downto 0):= "0010001";
		REGISTER_ADDRESS : std_logic_vector (7 downto 0):= X"00";
		PWM_BUFFER_BYTE_SIZE : INTEGER
	);
	port (
		SCL : in std_logic ;
		SDA : inout std_logic ;
		PWM_ENABLE : out std_logic;
		DATA_OUT : out std_logic_vector (8*PWM_BUFFER_BYTE_SIZE - 1 downto 0) 
	);
end i2c_Interface_Module;

architecture I2C_INTERFACE_ARCH of i2c_Interface_Module is 
	signal SHIFT_REGISTER : std_logic_vector (8 downto 0):= "000000001";
	signal START, ENABLE, ACK, CHIP_CHOSEN, REGISTER_CHOSEN : std_logic := '0';
	signal PWM_SHIFT_REGISTER : std_logic_vector (8*PWM_BUFFER_BYTE_SIZE downto 0) := (0 =>'1', others =>'0');
	signal PWM_BYTE_READ_COUNT : std_logic_vector (PWM_BUFFER_BYTE_SIZE downto 0) := (0 =>'1', others =>'0');
begin		
	-------------------------------------------------------------------------------------------------------
	-----------Check the I2C protocol handshake------------------------------------------------------------
	CHECK_I2C_CONDITIONS : process (SCL, SDA, ACK)
	begin
		--Check for the start sequence
		if SCL = '1' and falling_edge(SDA) then 
			START <= '1';
		--Check for the stop sequence
		elsif SCL = '1' and rising_edge(SDA) then
			START <= '0';
		--Check if the chip is selected
		elsif START = '1' and rising_edge(ACK) and CHIP_CHOSEN = '0' then
			if SHIFT_REGISTER(7 downto 0) = CHIP_ADDRESS & WRITE_SIGNAL then
				CHIP_CHOSEN <= '1';
			else
				START <= '0';
			end if;
		--Check if the proper register is selected
		elsif START = '1' and rising_edge(ACK) and CHIP_CHOSEN = '1' and REGISTER_CHOSEN ='0' then
			if SHIFT_REGISTER(7 downto 0) = REGISTER_ADDRESS then
				REGISTER_CHOSEN <= '1';
			else
				CHIP_CHOSEN <= '0';
				START <= '0';
			end if;
		end if;
	end process CHECK_I2C_CONDITIONS;
	
	--------------------------------------------------------------------------------------------------------
	-------------Enable the chip if the chip is selected----------------------------------------------------
	ENABLING_CHIP : process (CHIP_CHOSEN, REGISTER_CHOSEN, START)
	begin
		--Check if the chip and register is chosen correctly
		if CHIP_CHOSEN = '1' and REGISTER_CHOSEN = '1' then
			ENABLE <= '1';
		elsif START = '0' then
			ENABLE <= '0';
		end if;
	end process ENABLING_CHIP;
	
	-------------------------------------------------------------------------------------------------------
	-------------Read a byte from the SDA bus then raise an acknowledge signal to the master--------------- 
	READING : process (SCL, SDA, SHIFT_REGISTER, ACK)
	begin
		--Read the byte to the shift register
		if START = '1' and ACK = '0' and rising_edge(SCL) then 
			SHIFT_REGISTER <= SHIFT_REGISTER(7 downto 0) & SDA;
		elsif ACK = '1' and falling_edge(SCL) then
			SDA <= '1';
			SHIFT_REGISTER <= "000000001";
		elsif ACK = '1' and rising_edge(SCL) then
			ACK <= '0';
		end if;
		--Raise the acknowledge signal 
		if ACK = '0' and rising_edge(SHIFT_REGISTER(8)) then
			ACK <= '1';
		end if;
	end process READING;
	
	----------------------------------------------------------------------
	-------------Out the data after reading-------------------------------
	process (ENABLE, ACK, PWM_BYTE_READ_COUNT)
	begin 
		if ENABLE = '1' and rising_edge(ACk) then
			--extra -8 to remove the first MS byte 
			PWM_SHIFT_REGISTER <= 
				PWM_SHIFT_REGISTER(PWM_BUFFER_BYTE_SIZE * 8 - 8 downto 0) & SHIFT_REGISTER(7 downto 0);
			PWM_BYTE_READ_COUNT <= PWM_BYTE_READ_COUNT(PWM_BUFFER_BYTE_SIZE - 1 downto 0) & '0';
		elsif PWM_BYTE_READ_COUNT(PWM_BUFFER_BYTE_SIZE) = '1' and falling_edge(ACk) then
			--extra -1 to remove the extra bit in the end
			DATA_OUT <= PWM_SHIFT_REGISTER(PWM_BUFFER_BYTE_SIZE * 8 - 1 downto 0);  
			PWM_ENABLE <= '1';
			PWM_SHIFT_REGISTER <= (0 =>'1', others =>'0');
			PWM_BYTE_READ_COUNT <= (0 =>'1', others =>'0');
		end if;
	end process;

end I2C_INTERFACE_ARCH;
