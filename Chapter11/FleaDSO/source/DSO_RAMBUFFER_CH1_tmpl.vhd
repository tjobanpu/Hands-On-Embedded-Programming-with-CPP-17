-- VHDL module instantiation generated by SCUBA Diamond (64-bit) 3.9.1.119
-- Module  Version: 7.5
-- Sat Feb 17 18:18:02 2018

-- parameterized module component declaration
component DSO_RAMBUFFER_CH1
    port (DataInA: in  std_logic_vector(8 downto 0); 
        DataInB: in  std_logic_vector(8 downto 0); 
        AddressA: in  std_logic_vector(9 downto 0); 
        AddressB: in  std_logic_vector(9 downto 0); 
        ClockA: in  std_logic; ClockB: in  std_logic; 
        ClockEnA: in  std_logic; ClockEnB: in  std_logic; 
        WrA: in  std_logic; WrB: in  std_logic; ResetA: in  std_logic; 
        ResetB: in  std_logic; QA: out  std_logic_vector(8 downto 0); 
        QB: out  std_logic_vector(8 downto 0));
end component;

-- parameterized module component instance
__ : DSO_RAMBUFFER_CH1
    port map (DataInA(8 downto 0)=>__, DataInB(8 downto 0)=>__, AddressA(9 downto 0)=>__, 
        AddressB(9 downto 0)=>__, ClockA=>__, ClockB=>__, ClockEnA=>__, 
        ClockEnB=>__, WrA=>__, WrB=>__, ResetA=>__, ResetB=>__, QA(8 downto 0)=>__, 
        QB(8 downto 0)=>__);
