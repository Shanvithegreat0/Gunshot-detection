-- src/mfcc/pre_emphasis.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity pre_emphasis is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        data_in   : in  fp16_6;
        data_out  : out fp16_6
    );
end pre_emphasis;

architecture Behavioral of pre_emphasis is
    signal x_prev : fp16_6 := (others => '0');
    constant PRE_EMPHASIS_COEFF : fp16_6 := to_signed(0.95 * 2**FP_FRACTIONAL, FP_WIDTH);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                x_prev <= (others => '0');
                data_out <= (others => '0');
            else
                data_out <= data_in - ((PRE_EMPHASIS_COEFF * x_prev) srl FP_FRACTIONAL);
                x_prev <= data_in;
            end if;
        end if;
    end process;
end Behavioral;
