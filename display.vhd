library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- show a 16-bit unsigned integer as 4 hexadecimal digits on a 7-segment * 4 display.
entity display is
    port (
        I_clk       : in std_logic;
        I_display   : in unsigned(0 to 15);

        Q_segments  : out unsigned(0 to 6);
        Q_digit_sel : out unsigned(0 to 3)
    );
end display;

architecture Behavioral of display is
    -- ON segments are active low.
    constant seg_zero  : unsigned(0 to 6) := "0000001";
    constant seg_one   : unsigned(0 to 6) := "1001111";
    constant seg_two   : unsigned(0 to 6) := "0010010";
    constant seg_three : unsigned(0 to 6) := "0000110";
    constant seg_four  : unsigned(0 to 6) := "1001100";
    constant seg_five  : unsigned(0 to 6) := "0100100";
    constant seg_six   : unsigned(0 to 6) := "0100000";
    constant seg_seven : unsigned(0 to 6) := "0001111";
    constant seg_eight : unsigned(0 to 6) := "0000000";
    constant seg_nine  : unsigned(0 to 6) := "0000100";
    constant seg_a     : unsigned(0 to 6) := "0001000";
    constant seg_b     : unsigned(0 to 6) := "1100000";
    constant seg_c     : unsigned(0 to 6) := "0110001";
    constant seg_d     : unsigned(0 to 6) := "1000010";
    constant seg_e     : unsigned(0 to 6) := "0110000";
    constant seg_f     : unsigned(0 to 6) := "0111000";

    signal L_display_clk : std_logic := '0';
    signal L_digit_sel   : unsigned(0 to 1) := (others => '0');
begin

    -- divide I_clk to get a slower clock, at 32Mhz the seven segments don't work so well...
    display_clk: process(I_clk)
        variable V_clk_divider : unsigned(0 to 5);
    begin
        if rising_edge(I_clk) then
            V_clk_divider := V_clk_divider + 1;
            if V_clk_divider = 0 then
                L_display_clk <= not L_display_clk;
            end if;
        end if;
    end process;

    update_display: process(L_display_clk)
        variable V_cur_nibble : unsigned(0 to 3);
    begin
        if rising_edge(L_display_clk) then
            case L_digit_sel is
                when "00" =>
                    L_digit_sel <= "01"; Q_digit_sel <= "0010"; V_cur_nibble := I_display(4 to 7);
                when "01" =>
                    L_digit_sel <= "10"; Q_digit_sel <= "0100"; V_cur_nibble := I_display(8 to 11);
                when "10" =>
                    L_digit_sel <= "11"; Q_digit_sel <= "1000"; V_cur_nibble := I_display(12 to 15);
                when "11" =>
                    L_digit_sel <= "00"; Q_digit_sel <= "0001"; V_cur_nibble := I_display(0 to 3);
                when others => null;
            end case;

            case V_cur_nibble is
                when "0000" => Q_segments <= seg_zero;
                when "0001" => Q_segments <= seg_one;
                when "0010" => Q_segments <= seg_two;
                when "0011" => Q_segments <= seg_three;
                when "0100" => Q_segments <= seg_four;
                when "0101" => Q_segments <= seg_five;
                when "0110" => Q_segments <= seg_six;
                when "0111" => Q_segments <= seg_seven;
                when "1000" => Q_segments <= seg_eight;
                when "1001" => Q_segments <= seg_nine;
                when "1010" => Q_segments <= seg_a;
                when "1011" => Q_segments <= seg_b;
                when "1100" => Q_segments <= seg_c;
                when "1101" => Q_segments <= seg_d;
                when "1110" => Q_segments <= seg_e;
                when "1111" => Q_segments <= seg_f;
                when others => null;
            end case;
        end if;
    end process;

end Behavioral;
