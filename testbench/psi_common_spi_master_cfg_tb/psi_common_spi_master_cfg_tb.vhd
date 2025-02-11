------------------------------------------------------------
-- Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
-- All rights reserved.
------------------------------------------------------------

------------------------------------------------------------
-- Testbench generated by TbGen.py
-- Adapted to run for cfg feature e.g. Transfer width  
------------------------------------------------------------
-- see Library/Python/TbGenerator

------------------------------------------------------------
-- Libraries
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.psi_common_math_pkg.all;
use work.psi_common_logic_pkg.all;
use work.psi_common_array_pkg.all;

library work;
use work.psi_tb_compare_pkg.all;
use work.psi_tb_activity_pkg.all;
use work.psi_tb_txt_util.all;

------------------------------------------------------------
-- Entity Declaration
------------------------------------------------------------
entity psi_common_spi_master_cfg_tb is
  generic(
    SpiCPOL_g       : natural  := 0;
    SpiCPHA_g       : natural  := 0;
    LsbFirst_g      : boolean  := false;
    MaxTransWidth_g : positive := 32
  );
end entity;

------------------------------------------------------------
-- Architecture
------------------------------------------------------------
architecture sim of psi_common_spi_master_cfg_tb is
  -- *** Fixed Generics ***
  constant ClockDivider_g : natural  := 8;
  --constant MaxTransWidth_g : positive := 8;
  constant CsHighCycles_g : positive := 12;
  constant SlaveCnt_g     : positive := 2;

  -- *** Not Assigned Generics (default values) ***

  -- *** TB Control ***
  signal TbRunning            : boolean                  := True;
  signal NextCase             : integer                  := -1;
  signal ProcessDone          : std_logic_vector(0 to 1) := (others => '0');
  constant AllProcessesDone_c : std_logic_vector(0 to 1) := (others => '1');
  constant TbProcNr_stim_c    : integer                  := 0;
  constant TbProcNr_spi_c     : integer                  := 1;

  -- *** DUT Signals ***
  signal Clk             : std_logic                                            := '1';
  signal Rst             : std_logic                                            := '1';
  signal Start           : std_logic                                            := '0';
  signal Slave           : std_logic_vector(log2ceil(SlaveCnt_g) - 1 downto 0)  := (others => '0');
  signal Busy            : std_logic                                            := '0';
  signal Done            : std_logic                                            := '0';
  signal WrData          : std_logic_vector(MaxTransWidth_g - 1 downto 0)       := (others => '0');
  signal RdData          : std_logic_vector(MaxTransWidth_g - 1 downto 0)       := (others => '0');
  signal SpiSck          : std_logic                                            := '0';
  signal SpiMosi         : std_logic                                            := '0';
  signal SpiMiso         : std_logic                                            := '0';
  signal SpiCs_n         : std_logic_vector(SlaveCnt_g - 1 downto 0)            := (others => '0');
  signal TransWidth      : std_logic_vector(log2ceil(MaxTransWidth_g) downto 0) := to_uslv(MaxTransWidth_g, log2ceil(MaxTransWidth_g) + 1);
  -- *** Handwritten Stuff ***
  signal SlaveTx         : std_logic_vector(MaxTransWidth_g - 1 downto 0);
  signal ExpectedSlaveRx : std_logic_vector(MaxTransWidth_g - 1 downto 0);
  signal SlaveNr         : integer;

  type array_type_t is array (0 to 4) of std_logic_vector(MaxTransWidth_g - 1 downto 0);

  constant MosiWords_c : array_type_t := --(X"AB", X"34", X"FC", X"73", X"AB");
  (to_uslv(171, SlaveTx'length),
   to_uslv(52,  SlaveTx'length),
   to_uslv(252, SlaveTx'length),
   to_uslv(115, SlaveTx'length),
   to_uslv(171, SlaveTx'length));

  constant MisoWords_c : array_type_t := --(X"7C", X"C8", X"35", X"BE", X"7C");
  (to_uslv(124, SlaveTx'length),
   to_uslv(200, SlaveTx'length),
   to_uslv(53,  SlaveTx'length),
   to_uslv(190, SlaveTx'length),
   to_uslv(124, SlaveTx'length));
begin
  ------------------------------------------------------------
  -- DUT Instantiation
  ------------------------------------------------------------
  i_dut : entity work.psi_common_spi_master_cfg
    generic map(
      MaxTransWidth_g => MaxTransWidth_g,
      SpiCPOL_g       => SpiCPOL_g,
      SpiCPHA_g       => SpiCPHA_g,
      LsbFirst_g      => LsbFirst_g,
      ClockDivider_g  => ClockDivider_g,
      CsHighCycles_g  => CsHighCycles_g,
      SlaveCnt_g      => SlaveCnt_g
    )
    port map(
      TransWidth => TransWidth,
      Clk        => Clk,
      Rst        => Rst,
      Start      => Start,
      Slave      => Slave,
      Busy       => Busy,
      Done       => Done,
      WrData     => WrData,
      RdData     => RdData,
      SpiSck     => SpiSck,
      SpiMosi    => SpiMosi,
      SpiMiso    => SpiMiso,
      SpiCs_n    => SpiCs_n
    );

  ------------------------------------------------------------
  -- Testbench Control !DO NOT EDIT!
  ------------------------------------------------------------
  p_tb_control : process
  begin
    wait until Rst = '0';
    wait until ProcessDone = AllProcessesDone_c;
    TbRunning <= false;
    wait;
  end process;

  ------------------------------------------------------------
  -- Clocks !DO NOT EDIT!
  ------------------------------------------------------------
  p_clock_Clk : process
    constant Frequency_c : real := real(100e6);
  begin
    while TbRunning loop
      wait for 0.5 * (1 sec) / Frequency_c;
      Clk <= not Clk;
    end loop;
    wait;
  end process;

  ------------------------------------------------------------
  -- Resets
  ------------------------------------------------------------
  p_rst_Rst : process
  begin
    wait for 1 us;
    -- Wait for two clk edges to ensure reset is active for at least one edge
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    Rst <= '0';
    wait;
  end process;

  ------------------------------------------------------------
  -- Processes
  ------------------------------------------------------------
  -- *** stim ***
  p_stim : process
  begin
    -------------------------------------------------------------------
    print(" *********************************************************");
    print(" **            Paul Scherrer Institut                   **");
    print(" **      psi_common_spi_master_cfg_tb TestBench         **");
    print(" *********************************************************");
    -------------------------------------------------------------------
    -- start of process !DO NOT EDIT
    wait until Rst = '0';

    -- *** Simple Transfer ***
    for i in 0 to 4 loop
      SlaveTx         <= MisoWords_c(i);
      ExpectedSlaveRx <= MosiWords_c(i);
      SlaveNr         <= i mod 2;
      wait until rising_edge(Clk);
      WrData          <= MosiWords_c(i);
      Slave           <= std_logic_vector(to_unsigned(i mod 2, Slave'length));
      Start           <= '1';
      wait until rising_edge(Clk);
      WrData          <= to_uslv(0, WrData'length);
      Slave           <= "0";
      Start           <= '0';
      wait until falling_edge(Clk);
      StdlCompare(1, Busy, "Busy did not go high");
      wait until rising_edge(Clk) and Busy = '0';
      StdlvCompareStdlv(MisoWords_c(i), RdData, "SPI master received wrong data");
    end loop;

    -- *** Check Done Signal ***
    SlaveTx         <= to_uslv(85, SlaveTx'length);
    ExpectedSlaveRx <= to_uslv(170, ExpectedSlaveRx'length);
    SlaveNr         <= 0;
    wait until rising_edge(Clk);
    WrData          <= to_uslv(170, WrData'length);
    Slave           <= "0";
    Start           <= '1';
    wait until rising_edge(Clk);
    WrData          <= to_uslv(0, WrData'length);
    Slave           <= "0";
    Start           <= '0';
    wait until falling_edge(Clk);
    StdlCompare(1, Busy, "Busy did not go high");
    while Busy = '1' loop
      StdlCompare(0, Done, "Done high unexpectedly");
      wait until rising_edge(Clk);
    end loop;
    StdlCompare(1, Done, "Done did not go high");
    StdlvCompareStdlv(to_uslv(85,RdData'length), RdData, "SPI master received wrong data");
    wait until rising_edge(Clk);
    StdlCompare(0, Done, "Done did not go low again");

    -- *** Check Transfer start during busy ***
    SlaveTx         <= to_uslv(85, WrData'length);--X"55";
    ExpectedSlaveRx <= to_uslv(170, WrData'length);--X"AA";
    SlaveNr         <= 0;
    wait until rising_edge(Clk);
    WrData          <= to_uslv(170, WrData'length);--X"AA";
    Slave           <= "0";
    Start           <= '1';
    wait until rising_edge(Clk);
    WrData          <= to_uslv(0, WrData'length);
    Slave           <= "0";
    wait until falling_edge(Clk);
    StdlCompare(1, Busy, "Busy did not go high");
    for i in 0 to 20 loop
      wait until rising_edge(Clk);
    end loop;
    Start           <= '0';
    wait until rising_edge(Clk) and Busy = '0';
    StdlvCompareStdlv(to_uslv(85,RdData'length), RdData, "SPI master received wrong data");
    for i in 0 to 20 loop
      wait until rising_edge(Clk);
      StdlCompare(0, Busy, "Busy did not stay low");
    end loop;
    StdlCompare(0, Done, "Done did not go low again");

    -- end of process !DO NOT EDIT!
    ProcessDone(TbProcNr_stim_c) <= '1';
    wait;
  end process;

  -- *** spi ***
  p_spi : process
    variable ShiftRegRx_v : std_logic_vector(MaxTransWidth_g - 1 downto 0);
    variable ShiftRegTx_v : std_logic_vector(MaxTransWidth_g - 1 downto 0);
  begin
    -- start of process !DO NOT EDIT
    wait until Rst = '0';

    -- Do not wait for this process
    ProcessDone(TbProcNr_spi_c) <= '1';

    while TbRunning loop
      -- If start of transfer
      if SpiCs_n /= "11" then
        ShiftRegTx_v := SlaveTx;
        ShiftRegRx_v := (others => 'U');

        -- Check correct slave
        for s in 0 to SlaveCnt_g - 1 loop
          if s = SlaveNr then
            StdlCompare(0, SpiCs_n(s), "Slave " & to_string(s) & " not selected");
          else
            StdlCompare(1, SpiCs_n(s), "Slave " & to_string(s) & " selected wrongly");
          end if;
        end loop;

        -- loop over bits
        for i in 0 to MaxTransWidth_g - 1 loop
          -- Wait for apply edge 
          if (SpiCPHA_g = 1) and (i /= MaxTransWidth_g - 1) then
            if SpiCPOL_g = 0 then
              wait until rising_edge(SpiSck);
            else
              wait until falling_edge(SpiSck);
            end if;
          elsif (SpiCPHA_g = 0) and (i /= 0) then
            if SpiCPOL_g = 0 then
              wait until falling_edge(SpiSck);
            else
              wait until rising_edge(SpiSck);
            end if;
          end if;
          -- Shift TX
          if LsbFirst_g then
            SpiMiso      <= ShiftRegTx_v(0);
            ShiftRegTx_v := 'U' & ShiftRegTx_v(MaxTransWidth_g - 1 downto 1);
          else
            SpiMiso      <= ShiftRegTx_v(MaxTransWidth_g - 1);
            ShiftRegTx_v := ShiftRegTx_v(MaxTransWidth_g - 2 downto 0) & 'U';
          end if;
          -- Wait for transfer edge
          if ((SpiCPOL_g = 0) and (SpiCPHA_g = 0)) or ((SpiCPOL_g = 1) and (SpiCPHA_g = 1)) then
            wait until rising_edge(SpiSck);
          else
            wait until falling_edge(SpiSck);
          end if;
          -- Shift RX
          if LsbFirst_g then
            ShiftRegRx_v := SpiMosi & ShiftRegRx_v(MaxTransWidth_g - 1 downto 1);
          else
            ShiftRegRx_v := ShiftRegRx_v(MaxTransWidth_g - 2 downto 0) & SpiMosi;
          end if;
        end loop;

        -- wait fir CS going high
        wait until SpiCs_n = "11";
        StdlvCompareStdlv(ExpectedSlaveRx, ShiftRegRx_v, "SPI slave received wrong data");
      else
        wait until rising_edge(Clk);
      end if;
    end loop;

    wait;
  end process;

end;
