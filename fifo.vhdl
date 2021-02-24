LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity fifo is 
    generic (ad_width   : integer:= 4;
             data_width : integer:= 4 );
    port (CLK,RST,WR,RD : IN  STD_LOGIC;
          DATA_IN       : IN  STD_LOGIC_VECTOR (data_width-1 DOWNTO 0);
          FULL,EMPTY    : BUFFER STD_LOGIC;
          DATA_OUT      : OUT STD_LOGIC_VECTOR (data_width-1 DOWNTO 0)      
         );
end fifo;

architecture f_arch of fifo is
    signal write_r,read_r,write_rr,read_rr:STD_LOGIC;
    signal read_ptr,write_ptr : UNSIGNED (ad_width-1 DOWNTO 0);
    COMPONENT memory
        generic (ad_width   : integer:= 4;
                 data_width : integer:= 4 );
        port (CLK,WR,RD     : IN  STD_LOGIC;
              WR_AD, RD_AD  : IN  STD_LOGIC_VECTOR (ad_width-1 DOWNTO 0);
              DATA_IN       : IN  STD_LOGIC_VECTOR (data_width-1 DOWNTO 0);
              DATA_OUT      : OUT STD_LOGIC_VECTOR (data_width-1 DOWNTO 0));
		 
    END COMPONENT;     
    begin
        mem1:memory  
            generic map (ad_width => 4,
                        data_width => 4)
            port map (CLK,WR,RD,STD_LOGIC_VECTOR(write_ptr),STD_LOGIC_VECTOR(read_ptr),DATA_IN,DATA_OUT);
		  process(CLK,RST)
		  begin 
            if RST = '1' then 
                write_r  <= '0';
                read_r   <= '0';
                write_rr <= '0';
                read_rr  <= '0';
                read_ptr <=  x"0";
                write_ptr <= x"0";
            else 
                if rising_edge(CLK) then
                    write_r <= WR;
                    read_r <= RD;
                    write_rr <= write_r;
                    read_rr <= read_r;
                    if write_r = '1' and FULL = '0' then
                            write_ptr <= write_ptr + 1;
                    elsif read_r = '1' and  EMPTY= '0' then 
                           read_ptr <= read_ptr + 1;
                    end if; 
                end if; 
            end if; 
        end process;

        process(ALL) 
        begin
				FULL <= '0';
            EMPTY <= '0';
            if write_ptr = read_ptr then
                if RD = '0' and write_rr = '1' then 
                    FULL <= '1';
                elsif WR = '0' and read_rr = '1' then 
                    EMPTY <= '1';
                end if;
            end if; 
              
        end process;
end f_arch;


