-- src/mfcc/framing.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity framing is
    Generic (
        FRAME_SIZE : integer := 256;
        OVERLAP    : integer := 128 -- 50% overlap
    );
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        data_in     : in  fp16_6;
        frame_out   : out fp16_6_array(0 to FRAME_SIZE-1);
        frame_ready : out STD_LOGIC
    );
end framing;

architecture Behavioral of framing is
    signal buffer     : fp16_6_array(0 to FRAME_SIZE+OVERLAP-1);
    signal sample_idx : integer range 0 to FRAME_SIZE+OVERLAP-1 := 0;
    signal frame_idx  : integer range 0 to FRAME_SIZE-1 := 0;
    signal frame_valid: STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                buffer <= (others => (others => '0'));
                sample_idx <= 0;
                frame_valid <= '0';
            else
                -- Shift buffer and insert new sample
                for i in FRAME_SIZE+OVERLAP-1 downto 1 loop
                    buffer(i) <= buffer(i-1);
                end loop;
                buffer(0) <= data_in;
                
                if sample_idx = FRAME_SIZE+OVERLAP-1 then
                    sample_idx <= 0;
                    frame_valid <= '1';
                else
                    sample_idx <= sample_idx + 1;
                    frame_valid <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- Output frame when ready
    process(clk)
    begin
        if rising_edge(clk) then
            if frame_valid = '1' then
                for i in 0 to FRAME_SIZE-1 loop
                    frame_out(i) <= buffer(i+OVERLAP);
                end loop;
                frame_ready <= '1';
            else
                frame_ready <= '0';
            end if;
        end if;
    end process;
end Behavioral;
