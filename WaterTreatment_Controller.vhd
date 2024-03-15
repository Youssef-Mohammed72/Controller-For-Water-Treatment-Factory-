----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/17/2023 01:28:24 PM
-- Design Name: 
-- Module Name: WaterTreatment_Controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


--IEEE definition
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
----------------------------------------------

--Entity definition
----------------------------------------------
entity Water_Treatment_Controller is
port(
	--sequential Circuit
	Clk,Rst                    : in  std_Logic;
	
	--Primary Input
	Pressure_Check,Tank_Filled : in  std_logic;
	T1,T2,T3,T4                : in  std_logic;
	Network_Pump               : in  std_logic;
	
	--Primary Output
	Cf_Valve,Chlorine_Valve    : out std_Logic;
	Mixer                      : out std_Logic;
	Cleaner                    : out std_Logic;
	Water_pump                 : out std_Logic;
	Air_Pump                   : out std_Logic;
	Process_Finished           : out std_Logic;
	Out_Network_Pump           : out std_Logic
);
end Water_Treatment_Controller;
----------------------------------------------




--Architecture definition
--------------------------------------------------------------
architecture behavioral of Water_Treatment_Controller is

--State definition
----------------------------------------------
type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8);

signal Present_state,Next_state :state;
----------------------------------------------

 
begin

--sequential Circuit
----------------------------------------------
	Seq:process(Clk)
	begin
		if(Rising_edge(Clk))then
			if(Rst='0')then
				Present_state<=s0;
			else 
				Present_state<=Next_state;
			end if;
		end if;
	end process Seq;
----------------------------------------------


--combinational Circuit
----------------------------------------------	
	Comb:process(Present_state,T1,T2,T3,T4,Pressure_Check,Tank_Filled,Network_Pump)
	begin
	
	case Present_state is
		when S0 =>
			Cf_Valve  <='0';  Chlorine_Valve<='0';
			Mixer     <='0';  Cleaner       <='0';
			Water_pump<='0';  Air_Pump      <='0';
	
			Process_Finished<='0';
			Out_Network_Pump<='0';
			if((Pressure_Check='1')and(Tank_Filled='1'))then
				Next_state<=S1;
			else
				Next_state<=S0;
			end if;
			
		when S1 =>
			Cf_Valve  <='1';
			Mixer     <='1';
			Water_pump<='0';
			if(T1='1')then
				Next_state<=S2;
			else
				Next_state<=S1;
			end if;
		
		when S2 =>
			Cf_Valve  <='0';
			Mixer     <='0';
			Water_pump<='1';
			if((Pressure_Check='1')and(Tank_Filled='1'))then
				Next_state<=S3;
			else
				Next_state<=S2;
			end if;	

		when S3 =>
			Cleaner   <='1';
			Air_Pump  <='1';
			Water_pump<='0';
			if(T2='1')then
				Next_state<=S4;
			else
				Next_state<=S3;
			end if;

		when S4 =>
			Cleaner   <='0';
			Air_Pump  <='0';
			Water_pump<='1';
			if((Pressure_Check='1')and(Tank_Filled='1'))then
				Next_state<=S5;
			else
				Next_state<=S4;
			end if;			

		when S5 =>
			Water_pump<='0';
			if(T3='1')then
				Next_state<=S6;
			else
				Next_state<=S5;
			end if;		

		when S6 =>
			Water_pump<='1';
			if((Pressure_Check='1')and(Tank_Filled='1'))then
				Next_state<=S7;
			else
				Next_state<=S6;
			end if;		

		when S7 =>
			Water_pump    <='0';
			Chlorine_Valve<='1';
			if(T4='1')then
				Process_Finished<='1';
				Next_state<=S8;
			else
				Next_state<=S7;
			end if;	

		when S8 =>
			Water_pump    <='0';
			Chlorine_Valve<='0';
			if(Network_Pump='1')then
				Out_Network_Pump<='1';
				Next_state<=S0;
			else
				Next_state<=S8;
			end if;	
	end case;
	end process Comb;
----------------------------------------------	
	
	
end behavioral;
--------------------------------------------------------------
