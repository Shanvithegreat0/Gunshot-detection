-- src/hmm/forward_algorithm.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity forward_algorithm is
    Generic (
        NUM_STATES  : integer := 3;
        NUM_OBS     : integer := NUM_COEFFS
    );
    Port (
        clk                : in  STD_LOGIC;
        reset              : in  STD_LOGIC;
        observation_seq    : in  fp16_6_array(0 to NUM_OBS-1);
        alpha_out          : out fp16_6_array(0 to NUM_STATES-1)
    );
end forward_algorithm;

architecture Behavioral of forward_algorithm is
    -- HMM parameters (transition and emission probabilities)
    -- These should be initialized with your trained HMM parameters
    constant A : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_STATES-1) := (
        -- Transition probabilities
    );
    constant B : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_OBS-1) := (
        -- Emission probabilities
    );
    constant Pi : fp16_6_array(0 to NUM_STATES-1) := (
        -- Initial state probabilities
    );
    
    -- Signals for alpha coefficients
    signal alpha : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_OBS-1);
    
    -- Variables for computations
    variable temp_sum : fp16_6;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Initialize alpha coefficients
                for i in 0 to NUM_STATES-1 loop
                    alpha(i, 0) <= (Pi(i) * B(i, 0)) srl FP_FRACTIONAL;
                end loop;
            else
                -- Compute alpha coefficients for t > 0
                for t in 1 to NUM_OBS-1 loop
                    for j in 0 to NUM_STATES-1 loop
                        temp_sum := (others => '0');
                        for i in 0 to NUM_STATES-1 loop
                            temp_sum := temp_sum + ((alpha(i, t-1) * A(i, j)) srl FP_FRACTIONAL);
                        end loop;
                        alpha(j, t) <= (temp_sum * B(j, t)) srl FP_FRACTIONAL;
                    end loop;
                end loop;
                -- Output alpha for the last observation
                for i in 0 to NUM_STATES-1 loop
                    alpha_out(i) <= alpha(i, NUM_OBS-1);
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
