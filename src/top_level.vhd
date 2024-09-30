-- src/top_level.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity top_level is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        audio_in    : in  fp16_6;
        detection   : out STD_LOGIC
    );
end top_level;

architecture Behavioral of top_level is
    signal mfcc_out : fp16_6 array(0 to NUM_COEFFS-1);
begin
    mfcc_inst : entity work.mfcc_top
        port map (
            clk      => clk,
            reset    => reset,
            data_in  => audio_in,
            mfcc_out => mfcc_out
        );
    
    hmm_inst : entity work.hmm_top
        port map (
            clk       => clk,
            reset     => reset,
            mfcc_in   => mfcc_out,
            detection => detection
        );
end Behavioral;
