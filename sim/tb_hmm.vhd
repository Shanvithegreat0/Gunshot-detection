-- sim/tb_hmm.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity tb_hmm is
end tb_hmm;

architecture test of tb_hmm is
    -- Signals for clock and reset
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    -- Signals for HMM module
    signal mfcc_in   : fp16_6_array(0 to NUM_COEFFS-1);
    signal detection : STD_LOGIC;
    
    -- Test data
    constant test_mfcc : fp16_6_array(0 to NUM_COEFFS-1) := (
        -- Initialize with test MFCC values representing gunshot or non-gunshot
    );
begin
    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    -- Instantiate HMM module
    hmm_inst : entity work.hmm_top
        port map (
            clk       => clk,
            reset     => reset,
            mfcc_in   => mfcc_in,
            detection => detection
        );
    
    -- Stimulus process
    stimulus : process
    begin
        -- Wait for global reset
        wait for 100 ns;
        reset <= '0';
        -- Apply test MFCC input
        mfcc_in <= test_mfcc;
        -- Wait to observe detection output
        wait for 500 ns;
        -- Optionally, apply different test inputs
        wait;
    end process;
end test;
