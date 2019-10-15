library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HermesPackage.all;

entity Hermes_crossbar is
port(
	data_av:     in  regNport;
	data_in:     in  arrayNport_regflit;
	data_dup:	 in  regflit;
	data_ack:    out regNport;
	data_ack_dup:out std_logic;
	--sender:      in  regNport;
	free:        in  regNport;
	tab_in:      in  arrayNport_reg3;
	tab_out:     in  arrayNport_reg3;
	tab_dup:	 in  std_logic_vector(NPORT-2 downto 0);
	tx:          out regNport;
	data_out:    out arrayNport_regflit;
	credit_i:    in  regNport);
end Hermes_crossbar;

architecture Hermes_crossbar of Hermes_crossbar is

begin

	data_ack_dup <= credit_i(EAST) when tab_dup(EAST)='1' and free(EAST)='0' else
	 				credit_i(WEST) when tab_dup(WEST)='1' and free(WEST)='0' else
	 				credit_i(NORTH) when tab_dup(NORTH)='1' and free(NORTH)='0' else
	 				credit_i(SOUTH) when tab_dup(SOUTH)='1' and free(SOUTH)='0' else
	 				'0';

----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(EAST) when tab_out(LOCAL)="000" and free(LOCAL)='0' else
			data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else
			data_av(SOUTH) when tab_out(LOCAL)="011" and free(LOCAL)='0' else
			'0';

	data_out(LOCAL) <= data_in(EAST) when tab_out(LOCAL)="000" and free(LOCAL)='0' else
			data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else
			data_in(SOUTH) when tab_out(LOCAL)="011" and free(LOCAL)='0' else
			(others=>'0');

	data_ack(LOCAL) <= credit_i(EAST) when tab_in(LOCAL)="000" else
			credit_i(WEST)  when tab_in(LOCAL)="001" else
			credit_i(NORTH) when tab_in(LOCAL)="010" else
			credit_i(SOUTH) when tab_in(LOCAL)="011" else
			'0';
----------------------------------------------------------------------------------
-- PORTA EAST
----------------------------------------------------------------------------------
	tx(EAST) <= data_av(LOCAL) when (tab_out(EAST)="100" and free(EAST)='0') or (tab_dup(EAST)='1' and free(EAST) = '0') else 
			data_av(WEST) when tab_out(EAST)="001" and free(EAST)='0' else
			data_av(NORTH)  when tab_out(EAST)="010" and free(EAST)='0' else
			data_av(SOUTH) when tab_out(EAST)="011" and free(EAST)='0' else
			'0';
	data_out(EAST) <= data_dup when tab_dup(EAST)='1' and free(EAST)='0' else
			data_in(WEST) when tab_out(EAST)="001" and free(EAST)='0' else
			data_in(NORTH)  when tab_out(EAST)="010" and free(EAST)='0' else
			data_in(SOUTH) when tab_out(EAST)="011" and free(EAST)='0' else
			data_in(LOCAL) when tab_out(EAST)="100" and free(EAST)='0' else
			(others=>'0');
	data_ack(EAST) <= credit_i(WEST) when tab_in(EAST)="001" and data_av(EAST)='1' else
			credit_i(NORTH) when tab_in(EAST)="010" and data_av(EAST)='1' else
			credit_i(SOUTH) when tab_in(EAST)="011" and data_av(EAST)='1' else
			credit_i(LOCAL) when tab_in(EAST)="100" and data_av(EAST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(LOCAL) when (tab_out(WEST)="100" and free(WEST)='0') or (tab_dup(WEST)='1' and free(WEST) = '0') else 
			data_av(EAST) when tab_out(WEST)="000" and free(WEST)='0' else
			data_av(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_av(SOUTH) when tab_out(WEST)="011" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_dup when tab_dup(WEST)='1' and free(WEST)='0' else
			data_in(EAST) when tab_out(WEST)="000" and free(WEST)='0' else
			data_in(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_in(SOUTH) when tab_out(WEST)="011" and free(WEST)='0' else
			data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(EAST) when tab_in(WEST)="000" and data_av(WEST)='1' else
			credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
			credit_i(SOUTH) when tab_in(WEST)="011" and data_av(WEST)='1' else
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(LOCAL) when (tab_out(NORTH)="100" and free(NORTH)='0') or (tab_dup(NORTH)='1' and free(NORTH) = '0') else
			data_av(EAST) when tab_out(NORTH)="000" and free(NORTH)='0' else
			data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_av(SOUTH) when tab_out(NORTH)="011" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_dup when tab_dup(NORTH)='1' and free(NORTH)='0' else
			data_in(EAST) when tab_out(NORTH)="000" and free(NORTH)='0' else
			data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_in(SOUTH) when tab_out(NORTH)="011" and free(NORTH)='0' else
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(EAST) when tab_in(NORTH)="000" and data_av(NORTH)='1' else
			credit_i(WEST)  when tab_in(NORTH)="001" and data_av(NORTH)='1' else
			credit_i(SOUTH) when tab_in(NORTH)="011" and data_av(NORTH)='1' else
			credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA SOUTH
----------------------------------------------------------------------------------
	tx(SOUTH) <= data_av(LOCAL) when (tab_out(SOUTH)="100" and free(SOUTH)='0') or (tab_dup(SOUTH)='1' and free(SOUTH) = '0') else
			data_av(EAST) when tab_out(SOUTH)="000" and free(SOUTH)='0' else
			data_av(WEST)  when tab_out(SOUTH)="001" and free(SOUTH)='0' else
			data_av(NORTH) when tab_out(SOUTH)="010" and free(SOUTH)='0' else
			'0';

	data_out(SOUTH) <= data_dup when tab_dup(SOUTH)='1' and free(SOUTH)='0' else
			data_in(EAST) when tab_out(SOUTH)="000" and free(SOUTH)='0' else
			data_in(WEST)  when tab_out(SOUTH)="001" and free(SOUTH)='0' else
			data_in(NORTH) when tab_out(SOUTH)="010" and free(SOUTH)='0' else
			data_in(LOCAL) when tab_out(SOUTH)="100" and free(SOUTH)='0' else
			(others=>'0');

	data_ack(SOUTH) <= credit_i(EAST) when tab_in(SOUTH)="000" and data_av(SOUTH)='1' else
			credit_i(WEST)  when tab_in(SOUTH)="001" and data_av(SOUTH)='1' else
			credit_i(NORTH) when tab_in(SOUTH)="010" and data_av(SOUTH)='1' else
			credit_i(LOCAL) when tab_in(SOUTH)="100" and data_av(SOUTH)='1' else
			'0';

end Hermes_crossbar;
