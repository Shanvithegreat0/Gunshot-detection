-- src/mfcc/mfcc_top.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity mfcc_top is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        data_in     : in  fp16_6;
        mfcc_out    : out fp16_6 array(0 to NUM_COEFFS-1)
    );
end mfcc_top;

architecture Behavioral of mfcc_top is
    -- Signals connecting submodules
    signal pre_emph_out   : fp16_6;
    signal frame          : fp16_6 array(0 to FRAME_SIZE-1);
    signal windowed_frame : fp16_6 array(0 to FRAME_SIZE-1);
    signal fft_real       : fp16_6 array(0 to FRAME_SIZE-1);
    signal fft_imag       : fp16_6 array(0 to FRAME_SIZE-1);
    signal fft_magnitude  : fp16_6 array(0 to FRAME_SIZE/2);
    signal mel_energies   : fp16_6 array(0 to NUM_FILTERS-1);
    signal log_energies   : fp16_6 array(0 to NUM_FILTERS-1);
begin
    -- Instantiate submodules
    pre_emphasis_inst : entity work.pre_emphasis
        port map (
            clk      => clk,
            reset    => reset,
            data_in  => data_in,
            data_out => pre_emph_out
        );
    
    -- Framing and windowing logic would go here
    -- For simplicity, assume frame is filled externally
    
    windowing_inst : entity work.windowing
        port map (
            clk       => clk,
            reset     => reset,
            frame_in  => frame,
            frame_out => windowed_frame
        );
    
    fft_inst : entity work.fft
        port map (
            clk         => clk,
            reset       => reset,
            data_real   => windowed_frame,
            data_imag   => (others => (others => '0')),
            fft_real    => fft_real,
            fft_imag    => fft_imag
        );
    
    -- Compute magnitude
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                fft_magnitude <= (others => (others => '0'));
            else
                for i in 0 to FRAME_SIZE/2 loop
                    fft_magnitude(i) <= sqrt(fft_real(i)*fft_real(i) + fft_imag(i)*fft_imag(i));
                end loop;
            end if;
        end if;
    end process;
    
    mel_filter_bank_inst : entity work.mel_filter_bank
        port map (
            clk            => clk,
            reset          => reset,
            fft_magnitude  => fft_magnitude,
            mel_energies   => mel_energies
        );
    
    log_module_inst : for i in 0 to NUM_FILTERS-1 generate
        log_inst : entity work.log_module
            port map (
                clk      => clk,
                reset    => reset,
                data_in  => mel_energies(i),
                data_out => log_energies(i)
            );
    end generate;
    
    dct_inst : entity work.dct
        port map (
            clk          => clk,
            reset        => reset,
            log_energies => log_energies,
            mfcc_out     => mfcc_out
        );
end Behavioral;
