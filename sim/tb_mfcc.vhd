-- sim/tb_mfcc.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity tb_mfcc is
end tb_mfcc;

architecture test of tb_mfcc is
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    signal data_in   : fp16_6 := (others => '0');
    signal mfcc_out  : fp16_6 array(0 to NUM_COEFFS-1);
begin
    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    -- Instantiate MFCC module
    mfcc_inst : entity work.mfcc_top
        port map (
            clk      => clk,
            reset    => reset,
            data_in  => data_in,
            mfcc_out => mfcc_out
        );
    
    -- Stimulus process
    stimulus : process
    begin
        wait for 100 ns;
        reset <= '0';
        -- Provide input samples to data_in
        -- For example, read samples from a file or generate synthetic data
        wait;
    end process;
end test;
