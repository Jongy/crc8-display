library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8 is
    port(
        I_clk        : in std_logic;
        I_rst        : in std_logic;
        I_data       : in unsigned(0 to 7);
        I_data_valid : in std_logic;

        Q_crc        : out unsigned(0 to 7)
    );
end crc8;

architecture Behavioral of crc8 is
    constant C_poly : unsigned(0 to 8) := "100000111";
    signal L_crc : unsigned(0 to 7) := (others => '0');
begin
    crc8_proc : process(I_clk, I_rst)
        variable V_crc : unsigned(0 to 8) := (others => '0');
    begin
        if (I_rst = '1') then
            L_crc <= (others => '0');
        elsif rising_edge(I_clk) then
            if (I_data_valid = '1') then
                V_crc := (I_data xor L_crc) & '0';
                for I in 0 to 7 loop
                    if (V_crc(0) = '1') then
                        V_crc := V_crc xor C_poly;
                    end if;
                    V_crc := V_crc(1 to 8) & '0';
                end loop;
                L_crc <= V_crc(0 to 7);
            end if;
        end if;
    end process;

    Q_crc <= L_crc;
end Behavioral;
