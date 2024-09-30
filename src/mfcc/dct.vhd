-- src/mfcc/dct.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity dct is
    Generic (
        NUM_COEFFS : integer := 13;
        NUM_FILTERS: integer := 26
    );
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        log_energies  : in  fp16_6 array(0 to NUM_FILTERS-1);
        mfcc_out      : out fp16_6 array(0 to NUM_COEFFS-1)
    );
end dct;

architecture Behavioral of dct is
    -- DCT coefficient matrix
    constant dct_coefficients : fp16_6 array(0 to NUM_COEFFS-1, 0 to NUM_FILTERS-1) := (
        -- Initialize with precomputed DCT coefficients
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                mfcc_out <= (others => (others => '0'));
            else
                for k in 0 to NUM_COEFFS-1 loop
                    mfcc_out(k) <= (others => '0');
                    for n in 0 to NUM_FILTERS-1 loop
                        mfcc_out(k) <= mfcc_out(k) + ((log_energies(n) * dct_coefficients(k, n)) srl FP_FRACTIONAL);
                    end loop;
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
