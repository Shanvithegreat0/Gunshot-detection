-- src/mfcc/mel_filter_bank.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity mel_filter_bank is
    Generic (
        NUM_FILTERS : integer := 26;
        FFT_SIZE    : integer := 256
    );
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        fft_magnitude : in  fp16_6 array(0 to FFT_SIZE/2);
        mel_energies  : out fp16_6 array(0 to NUM_FILTERS-1)
    );
end mel_filter_bank;

architecture Behavioral of mel_filter_bank is
    -- Mel filter coefficients
    constant mel_filters : fp16_6 array(0 to NUM_FILTERS-1, 0 to FFT_SIZE/2) := (
        -- Initialize with precomputed coefficients
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                mel_energies <= (others => (others => '0'));
            else
                for i in 0 to NUM_FILTERS-1 loop
                    mel_energies(i) <= (others => '0');
                    for j in 0 to FFT_SIZE/2 loop
                        mel_energies(i) <= mel_energies(i) + ((fft_magnitude(j) * mel_filters(i, j)) srl FP_FRACTIONAL);
                    end loop;
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
