-- src/pkg/fixed_point_pkg.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package fixed_point_pkg is
    -- Define fixed-point types
    subtype fp16_6 is signed(15 downto 0);  -- 16 bits total, 6 integer bits
    constant FP_WIDTH : integer := 16;
    constant FP_FRACTIONAL : integer := 10; -- Number of fractional bits
end package fixed_point_pkg;
