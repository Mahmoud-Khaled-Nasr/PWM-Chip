-------------------------------------------------------------------------------
---- Licensed to the Apache Software Foundation (ASF) under one ---------------
---- or more contributor license agreements.  See the NOTICE file -------------
---- distributed with this work for additional information --------------------
---- regarding copyright ownership.  The ASF licenses this file ---------------
---- to you under the Apache License, Version 2.0 (the ------------------------
---- "License"); you may not use this file except in compliance ---------------
---- with the License.  You may obtain a copy of the License at----------------

----  http://www.apache.org/licenses/LICENSE-2.0 ------------------------------

---- Unless required by applicable law or agreed to in writing, ---------------
---- software distributed under the License is distributed on an --------------
---- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY -------------------
---- KIND, either express or implied.  See the License for the ----------------
---- specific language governing permissions and limitations ------------------
---- under the License. -------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
----Author: Mahmoud Khaled Nasr -----------------------------------------------
----Email: mahmoud.k.nasr@gmail.com -------------------------------------------
----Objective: Apertus PWM Chip task -----------------------------------------------
----File Name: PWM_Chip -------------------------------------------------------
-------------------------------------------------------------------------------  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity I2C_Interface_Module is 
	generic (
		WRITE_SIGNAL : std_logic := '0';
		CHIP_ADDRESS : std_logic_vector (6 downto 0) := "0010001";
		REGISTER_ADDRESS : std_logic_vector (7 downto 0) := X"00";
		PWM_BUFFER_BYTE_SIZE : INTEGER := 2 
	);
	port (
		SCL : in std_logic ;
		SDA : inout std_logic ;
		PWM_ENABLE : out std_logic;
		DATA_OUT : out std_logic_vector (8*PWM_BUFFER_BYTE_SIZE - 1 downto 0) 
	);
end I2C_Interface_Module;

architecture I2C_Interface_Arch of I2C_Interface_Module is 
	constant PWM_BUFFER_BIT_SIZE : integer := 8 * PWM_BUFFER_BYTE_SIZE;
	signal shift_register : std_logic_vector (8 downto 0):= "000000001";
	signal start, enable, ack, chip_chosen, register_chosen : std_logic := '0';
	signal pwm_shift_register : std_logic_vector (PWM_BUFFER_BIT_SIZE downto 0) := (0 =>'1', others =>'0');
	signal pwm_byte_read_count : std_logic_vector (PWM_BUFFER_BYTE_SIZE downto 0) := (0 =>'1', others =>'0');
begin		
	-------------------------------------------------------------------------------------------------------
	-----------Check the I2C protocol handshake------------------------------------------------------------
	Check_I2C_Conditions : process (SCL, SDA, ack)
	begin
		--Check for the start sequence
		if SCL = '1' and falling_edge(SDA) then 
			start <= '1';
		--Check for the stop sequence
		elsif SCL = '1' and rising_edge(SDA) then
			start <= '0';
		--Check if the chip is selected
		elsif start = '1' and rising_edge(ack) and chip_chosen = '0' then
			if shift_register(7 downto 0) = CHIP_ADDRESS & WRITE_SIGNAL then
				chip_chosen <= '1';
			else
				start <= '0';
			end if;
		--Check if the proper register is selected
		elsif start = '1' and rising_edge(ack) and chip_chosen = '1' and register_chosen ='0' then
			if shift_register(7 downto 0) = REGISTER_ADDRESS then
				register_chosen <= '1';
			else
				chip_chosen <= '0';
				start <= '0';
			end if;
		end if;
	end process Check_I2C_Conditions;
	
	--------------------------------------------------------------------------------------------------------
	-------------Enable the chip if the chip is selected----------------------------------------------------
	Enabling_Chip : process (chip_chosen, register_chosen, start)
	begin
		--Check if the chip and register is chosen correctly
		if chip_chosen = '1' and register_chosen = '1' then
			enable <= '1';
		elsif start = '0' then
			enable <= '0';
		end if;
	end process Enabling_Chip;
	
	-------------------------------------------------------------------------------------
	--------Reading from SDA then raise the acknowledge signal to the master------------- 
	Reading : process (SCL, SDA, shift_register, ack)
	begin
		--Read the byte to the shift register
		if start = '1' and ack = '0' and rising_edge(SCL) then 
			shift_register <= shift_register(7 downto 0) & SDA;
		elsif ack = '1' and falling_edge(SCL) then
			SDA <= '1';
			shift_register <= "000000001";
		elsif ack = '1' and rising_edge(SCL) then
			ack <= '0';
		end if;
		--Raise the acknowledge signal 
		if ack = '0' and rising_edge(shift_register(8)) then
			ack <= '1';
		end if;
	end process Reading;
	
	----------------------------------------------------------------------
	--------Output the data after reading---------------------------------
	Processing_Data : process (enable, ack, pwm_byte_read_count)
	begin 
		if enable = '1' and rising_edge(ack) then
			--extra -8 to remove the first most significant byte 
			pwm_shift_register <= 
				pwm_shift_register(PWM_BUFFER_BIT_SIZE - 8 downto 0) & shift_register(7 downto 0);
			pwm_byte_read_count <= pwm_byte_read_count(PWM_BUFFER_BYTE_SIZE - 1 downto 0) & '0';
		elsif pwm_byte_read_count(PWM_BUFFER_BYTE_SIZE) = '1' and falling_edge(ACk) then
			--extra -1 to remove the extra bit in the end
			DATA_OUT <= pwm_shift_register(PWM_BUFFER_BIT_SIZE - 1 downto 0);  
			PWM_ENABLE <= '1';
			pwm_shift_register <= (0 =>'1', others =>'0');
			pwm_byte_read_count <= (0 =>'1', others =>'0');
		end if;
	end process Processing_Data;

end I2C_Interface_Arch;
