-- sim/tb_top_level.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity tb_top_level is
end tb_top_level;

architecture test of tb_top_level is
    -- Signals for clock and reset
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    -- Signals for top-level module
    signal audio_in  : fp16_6 := (others => '0');
    signal detection : STD_LOGIC;
    
    -- Test audio data
    type audio_array is array(integer range <>) of fp16_6;
    constant test_audio : audio_array(0 to TOTAL_SAMPLES-1) := (
        -- Initialize with audio sample data representing gunshot or non-gunshot
    );
    
    signal sample_index : integer := 0;
begin
    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    -- Instantiate top-level module
    top_inst : entity work.top_level
        port map (
            clk       => clk,
            reset     => reset,
            audio_in  => audio_in,
            detection => detection
        );
    
    -- Stimulus process
    stimulus : process
    begin
        -- Wait for global reset
        wait for 100 ns;
        reset <= '0';
        -- Apply test audio samples
        for i in 0 to TOTAL_SAMPLES-1 loop
            audio_in <= test_audio(i);
            wait for SAMPLE_PERIOD; -- SAMPLE_PERIOD corresponds to your audio sampling rate
        end loop;
        wait;
    end process;
end test;
