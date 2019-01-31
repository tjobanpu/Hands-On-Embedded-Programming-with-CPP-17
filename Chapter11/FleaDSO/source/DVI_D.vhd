--------------------------------------------------------------------------------
-- Engineer:      Mike Field <hamster@snap.net.nz>
-- Description:   Converts VGA signals into DVID bitstreams.
--
--                'clk' and 'clk_n' should be 5x clk_pixel.
--
--                'blank' should be asserted during the non-display 
--                portions of the frame
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Library UNISIM;
--use UNISIM.vcomponents.all;

entity dvid is
    Port ( clk       : in  STD_LOGIC;
           clk_n     : in  STD_LOGIC;
           clk_pixel : in  STD_LOGIC;
           red_p     : in  STD_LOGIC_VECTOR (7 downto 0);
           green_p   : in  STD_LOGIC_VECTOR (7 downto 0);
           blue_p    : in  STD_LOGIC_VECTOR (7 downto 0);
           blank     : in  STD_LOGIC;
           hsync     : in  STD_LOGIC;
           vsync     : in  STD_LOGIC;
           red_s     : out STD_LOGIC_VECTOR (0 downto 0);
           green_s   : out STD_LOGIC_VECTOR (0 downto 0);
           blue_s    : out STD_LOGIC_VECTOR (0 downto 0);
           clock_s   : out STD_LOGIC_VECTOR (0 downto 0)); 
end dvid;
 
architecture Behavioral of dvid is 
   COMPONENT TDMS_encoder
   PORT(
      clk     : IN  std_logic;
      data    : IN  std_logic_vector(7 downto 0);
      c       : IN  std_logic_vector(1 downto 0);
      blank   : IN  std_logic;          
      encoded : OUT std_logic_vector(9 downto 0)
      );
   END COMPONENT;

   signal encoded_red, encoded_green, encoded_blue : std_logic_vector(9 downto 0);
   signal latched_red, latched_green, latched_blue : std_logic_vector(9 downto 0) := (others => '0');
   signal shift_red,   shift_green,   shift_blue   : std_logic_vector(9 downto 0) := (others => '0');
   
   signal shift_clock   : std_logic_vector(9 downto 0) := "0000011111";

	signal dummy10	: std_logic;
	signal dummy20	: std_logic;
	signal dummy11	: std_logic;
	signal dummy21	: std_logic;
	signal dummy12	: std_logic;
	signal dummy22	: std_logic;
	signal dummy13	: std_logic;
	signal dummy23	: std_logic;

	
   constant c_red       : std_logic_vector(1 downto 0) := (others => '0');
   constant c_green     : std_logic_vector(1 downto 0) := (others => '0');
   signal   c_blue      : std_logic_vector(1 downto 0);

begin   
   c_blue <= vsync & hsync;
    
   u21 : entity work.TDMS_encoder PORT MAP(clk => clk_pixel, data => red_p,   c => c_red,   blank => blank, encoded => encoded_red);
   u22 : entity work.TDMS_encoder PORT MAP(clk => clk_pixel, data => green_p, c => c_green, blank => blank, encoded => encoded_green);
   u23 : entity work.TDMS_encoder PORT MAP(clk => clk_pixel, data => blue_p,  c => c_blue,  blank => blank, encoded => encoded_blue);

 --  ODDR2_red   : ODDR2 generic map( DDR_ALIGNMENT => "C0", INIT => '0', SRTYPE => "ASYNC") 
 --     port map (Q => red_s,   D0 => shift_red(0),   D1 => shift_red(1),   C0 => clk, C1 => clk_n, CE => '1', R => '0', S => '0');
  
 --  ODDR2_green : ODDR2 generic map( DDR_ALIGNMENT => "C0", INIT => '0', SRTYPE => "ASYNC") 
 --     port map (Q => green_s, D0 => shift_green(0), D1 => shift_green(1), C0 => clk, C1 => clk_n, CE => '1', R => '0', S => '0');

  -- ODDR2_blue  : ODDR2 generic map( DDR_ALIGNMENT => "C0", INIT => '0', SRTYPE => "ASYNC") 
 --     port map (Q => blue_s,  D0 => shift_blue(0),  D1 => shift_blue(1),  C0 => clk, C1 => clk_n, CE => '1', R => '0', S => '0');

 --  ODDR2_clock : ODDR2 generic map( DDR_ALIGNMENT => "C0", INIT => '0', SRTYPE => "ASYNC") 
 --     port map (Q => clock_s, D0 => shift_clock(0), D1 => shift_clock(1), C0 => clk, C1 => clk_n, CE => '1', R => '0', S => '0');


	u2 : entity work.ddr_out
    port map (clkop=>clk, clkos=>clk_n, clkout=>dummy10, reset=>'0',
        data(1 downto 0)=>shift_red(1 downto 0), dout(0 downto 0)=>red_s); 
		 
	u3 : entity work.ddr_out 
    port map (clkop=>clk, clkos=>clk_n, clkout=>dummy11, reset=>'0', 
        data(1 downto 0)=>shift_green(1 downto 0), dout(0 downto 0)=>green_s);		
		
	u4 : entity work.ddr_out
    port map (clkop=>clk, clkos=>clk_n, clkout=>dummy12, reset=>'0', 
        data(1 downto 0)=>shift_blue(1 downto 0), dout(0 downto 0)=>blue_s);			

	u5 : entity work.ddr_out
    port map (clkop=>clk, clkos=>clk_n, clkout=>dummy13, reset=>'0',
        data(1 downto 0)=>shift_clock(1 downto 0), dout(0 downto 0)=>clock_s);
 
 
   process(clk_pixel)
   begin
      if rising_edge(clk_pixel) then 
            latched_red   <= encoded_red;
            latched_green <= encoded_green;
            latched_blue  <= encoded_blue;
      end if;
   end process;

   process(clk)
   begin
      if rising_edge(clk) then 
         if shift_clock = "0000011111" then
            shift_red   <= latched_red;
            shift_green <= latched_green;
            shift_blue  <= latched_blue;
         else
            shift_red   <= "00" & shift_red  (9 downto 2);
            shift_green <= "00" & shift_green(9 downto 2);
            shift_blue  <= "00" & shift_blue (9 downto 2);
         end if;
         shift_clock <= shift_clock(1 downto 0) & shift_clock(9 downto 2);
      end if;
   end process;
   
end Behavioral;
