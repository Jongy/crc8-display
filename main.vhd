library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port (
        I_clk       : in std_logic;
        I_rx        : in std_logic;

        Q_segments  : out unsigned(0 to 6);
        Q_digit_sel : out unsigned(0 to 3)
    );
end main;

architecture Behavioral of main is
    component crc8
        port (
            I_clk        : in std_logic;
            I_data       : in unsigned(0 to 7);
            I_data_valid : in std_logic;

            Q_crc        : out unsigned(0 to 7)
        );
    end component;

    component rx
        port (
            I_clk        : in std_logic;
            I_rx         : in std_logic;

            Q_data       : out unsigned(0 to 7);
            Q_data_ready : out std_logic
        );
    end component;

    component display is
        port (
            I_clk       : in std_logic;
            I_display   : in unsigned(0 to 15);

            Q_segments  : out unsigned(0 to 6);
            Q_digit_sel : out unsigned(0 to 3)
        );
    end component;

    signal L_data       : unsigned(0 to 7) := (others => '0');
    signal L_data_valid : std_logic := '0';
    signal L_crc        : unsigned(0 to 7) := (others => '1');
    signal L_display    : unsigned(0 to 15) := (others => '0');
begin

    crc8_inst: crc8 port map (
            I_clk => I_clk,
            I_data => L_data,
            I_data_valid => L_data_valid,
            Q_crc => L_crc
        );

    rx_inst: rx port map (
            I_clk => I_clk,
            I_rx => I_rx,
            Q_data => L_data,
            Q_data_ready => L_data_valid
        );

    display_inst: display port map (
            I_clk => I_clk,
            I_display => L_display,
            Q_segments => Q_segments,
            Q_digit_sel => Q_digit_sel
        );

    L_display <= x"00" & L_crc;

end Behavioral;

