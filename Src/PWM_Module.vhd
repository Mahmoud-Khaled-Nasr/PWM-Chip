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

-------------------------------------------------------------------------------
--------------------Important Note---------------------------------------------
---This code is only intended as a VHDL simulation without synthesis in mind---
-------------------------------------------------------------------------------

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
		DUTY_CYCLE : in std_logic_vector 
			(8*PWM_BUFFER_BYTE_SIZE - 1 downto 0);
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
		elsif writing_conditions and high_counter = ZERO_COUNTER 
			and low_counter /= ZERO_COUNTER then
			
			low_counter <= low_counter - '1';
			PWM_SIGNAL <= '0';
		elsif writing_conditions and high_counter = ZERO_COUNTER 
			and low_counter = ZERO_COUNTER then
			
			high_counter <= DUTY_CYCLE;
			low_counter <= 2 ** PWM_BUFFER_BIT_SIZE - DUTY_CYCLE;
		end if;
	end process PWM_Signal_Generation;
end PWM_Module_Arch;


