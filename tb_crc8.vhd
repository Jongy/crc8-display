library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_crc8 is
end tb_crc8;

architecture behavior of tb_crc8 is
    component crc8
    port (
        I_clk        : in std_logic;
        I_rst        : in std_logic;
        I_data       : in unsigned(0 to 7);
        I_data_valid : in std_logic;
        Q_crc        : out unsigned(0 to 7)
    );
    end component;

    signal I_clk        : std_logic := '0';
    signal I_rst        : std_logic := '0';
    signal I_data       : unsigned(0 to 7) := (others => '0');
    signal I_data_valid : std_logic := '0';

    signal Q_crc : unsigned(0 to 7);

    constant I_clk_period : time := 10 ns;
begin

     uut: crc8 port map (
        I_clk => I_clk,
        I_rst => I_rst,
        I_data => I_data,
        I_data_valid => I_data_valid,
        Q_crc => Q_crc
    );

    I_clk_process : process
    begin
        I_clk <= '0';
        wait for I_clk_period/2;
        I_clk <= '1';
        wait for I_clk_period/2;
    end process;


    stim_proc: process
    begin
        I_rst <= '1';
        wait for 100 ns;
        wait for I_clk_period*10;

        I_rst <= '0';
        I_data <= x"61";
        I_data_valid <= '1';
        wait for I_clk_period;
        I_data <= x"62";
        wait for I_clk_period;
        I_data <= x"63";
        wait for I_clk_period;
        I_data_valid <= '0';
        wait for I_clk_period;
        wait;
     end process;

end;
