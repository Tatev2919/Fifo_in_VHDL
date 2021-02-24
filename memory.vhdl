LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is 
    generic (ad_width   : integer:= 4;
             data_width : integer:= 4 );
    port (CLK,WR,RD     : IN  STD_LOGIC;
          WR_AD, RD_AD  : IN  STD_LOGIC_VECTOR (ad_width-1  DOWNTO 0);
          DATA_IN       : IN  STD_LOGIC_VECTOR (data_width-1 DOWNTO 0);
          DATA_OUT      : OUT STD_LOGIC_VECTOR (data_width-1 DOWNTO 0)      
         );
end memory;


architecture m1 of memory is
    TYPE MEM IS ARRAY (2**(ad_width)-1 DOWNTO 0) OF STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
    signal MEMORY : MEM;
	 signal ad_w,ad_r: INTEGER RANGE ad_width-1 DOWNTO 0;
begin 
    process (CLK,WR_AD,RD_AD) is 
    begin
		  ad_w <= CONV_INTEGER(WR_AD);
		  ad_r <= CONV_INTEGER(RD_AD);
        if rising_edge(CLK) then
            if WR = '1' then 
                MEMORY(ad_w) <= DATA_IN;
            elsif RD = '1' then 
                DATA_OUT <= MEMORY(ad_r);
            else 
                DATA_OUT <= "ZZZZ";
            end if; 
        end if;
    end process;
end m1;
