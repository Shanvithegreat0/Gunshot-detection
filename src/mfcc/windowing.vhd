-- src/mfcc/windowing.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity windowing is
    Generic (
        FRAME_SIZE : integer := 256
    );
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        frame_in    : in  fp16_6_array(0 to FRAME_SIZE-1);
        frame_out   : out fp16_6_array(0 to FRAME_SIZE-1)
    );
end windowing;

architecture Behavioral of windowing is
    -- Precomputed Hamming window coefficients
    constant hamming_coefficients : fp16_6_array(0 to FRAME_SIZE-1) := (
        -- Initialize with precomputed values scaled by 2^FP_FRACTIONAL
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                frame_out <= (others => (others => '0'));
            else
                for i in 0 to FRAME_SIZE-1 loop
                    frame_out(i) <= (frame_in(i) * hamming_coefficients(i)) srl FP_FRACTIONAL;
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
