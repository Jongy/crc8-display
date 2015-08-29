library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx is
    port (
        I_clk        : in std_logic; -- 32Mhz
        I_rx         : in std_logic;

        Q_data       : out unsigned(0 to 7);
        Q_data_ready : out std_logic
    );
end rx;

architecture Behavioral of rx is
    signal L_quad_baud_clk : std_logic := '0';

    signal L_data_ready    : std_logic := '0';
    signal L_data_flag_set : std_logic := '0';
begin

    -- generates the baud rate (9600) divided by four.
    generate_baud: process (I_clk)
        variable V_counter: unsigned(0 to 9) := (others => '0');
    begin
        if rising_edge(I_clk) then
            L_quad_baud_clk <= '0';
            V_counter := V_counter + 1;
            -- (32MHz / 9600 baud) / 4 (quad the baud rate) = 833
            if (V_counter = 833) then
                L_quad_baud_clk <= '1';
                V_counter := (others => '0');
            end if;
        end if;
    end process;

    -- reads serial byte input into next_byte
    read_serial: process(I_clk, L_quad_baud_clk)
        variable V_samples : unsigned(0 to 37) := (others => '1');
    begin
        if rising_edge(L_quad_baud_clk) then
            -- was set the previous rising edge of quad baud clk, should be off now.
            if (L_data_ready = '1') then
                L_data_ready <= '0';
            end if;
            -- RX is LSB first.
            V_samples := I_rx & V_samples(0 to 36);
            -- do we see start & stop bits?
            if (V_samples(0 to 1) = "11" and V_samples(36 to 37) = "00") then
                Q_data <= V_samples(5) & V_samples(9) & V_samples(13) &
                          V_samples(17) & V_samples(21) & V_samples(25) &
                          V_samples(29) & V_samples(33);
                L_data_ready <= '1';
                V_samples := (others => '1');
            end if;
        end if;
    end process;

    mark_data_ready: process(I_clk)
    begin
        if rising_edge(I_clk) then
            if (L_data_ready = '1') then
                if (L_data_flag_set = '0') then
                    L_data_flag_set <= '1';
                    Q_data_ready <= '1';
                else
                    Q_data_ready <= '0';
                end if;
            else
                L_data_flag_set <= '0';
            end if;
        end if;
    end process;

end Behavioral;
