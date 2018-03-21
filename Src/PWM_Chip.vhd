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
----Objective: Apertus PWM Chip task ------------------------------------------
----File Name: PWM_Chip -------------------------------------------------------
-------------------------------------------------------------------------------  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Chip is 
	generic (
		PWM_BUFFER_BYTE_SIZE : INTEGER := 1
	);
	port (
		SCL : in std_logic;
		SDA : inout std_logic;
		PWM_SIGNAL : out std_logic
	);
end PWM_Chip;

architecture PWM_Chip_Arch of PWM_Chip is
	component i2c_Interface_Module is 
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
	end component i2c_Interface_Module;
	
	component PWM_Module is 
	generic (
		PWM_BUFFER_BYTE_SIZE : INTEGER;
		CLOCK_PERIOD : TIME := 10 ps
	);
	port (
		PWM_ENABLE : in std_logic;
		DUTY_CYCLE : in std_logic_vector (8*PWM_BUFFER_BYTE_SIZE - 1 downto 0);
		PWM_SIGNAL : out std_logic
	);
	end component PWM_Module;
	
	signal pwm_enable_signal : std_logic;
	signal i2c_data_out : std_logic_vector 
		(PWM_BUFFER_BYTE_SIZE * 8 - 1 downto 0);
begin
	I2C : i2c_Interface_Module 
		generic map (PWM_BUFFER_BYTE_SIZE => PWM_BUFFER_BYTE_SIZE)
		port map (SCL => SCL, SDA => SDA, 
		PWM_ENABLE => pwm_enable_signal, DATA_OUT => i2c_data_out);
	
	PWM : PWM_Module 
		generic map (PWM_BUFFER_BYTE_SIZE => PWM_BUFFER_BYTE_SIZE)
		port map (PWM_ENABLE => pwm_enable_signal, DUTY_CYCLE => i2c_data_out,
		PWM_SIGNAL => PWM_SIGNAL);
	
end PWM_Chip_Arch;
