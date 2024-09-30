-- src/mfcc/fft.vhd
-- Assuming you have an FFT IP core named fft_core

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity fft is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        data_real   : in  fp16_6 array(0 to FRAME_SIZE-1);
        data_imag   : in  fp16_6 array(0 to FRAME_SIZE-1);
        fft_real    : out fp16_6 array(0 to FRAME_SIZE-1);
        fft_imag    : out fp16_6 array(0 to FRAME_SIZE-1)
    );
end fft;

architecture Behavioral of fft is
begin
    -- Instantiate the FFT IP core
    fft_inst: entity work.fft_core
        port map (
            clk       => clk,
            reset     => reset,
            xn_re     => data_real,
            xn_im     => data_imag,
            xk_re     => fft_real,
            xk_im     => fft_imag
        );
end Behavioral;
