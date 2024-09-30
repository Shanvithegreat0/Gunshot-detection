-- src/hmm/viterbi_algorithm.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_point_pkg.ALL;

entity viterbi_algorithm is
    Generic (
        NUM_STATES  : integer := 3;
        NUM_OBS     : integer := NUM_COEFFS
    );
    Port (
        clk                : in  STD_LOGIC;
        reset              : in  STD_LOGIC;
        observation_seq    : in  fp16_6_array(0 to NUM_OBS-1);
        state_sequence     : out integer_array(0 to NUM_OBS-1)
    );
end viterbi_algorithm;

architecture Behavioral of viterbi_algorithm is
    -- HMM parameters (transition and emission probabilities)
    constant A : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_STATES-1) := (
        -- Transition probabilities
    );
    constant B : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_OBS-1) := (
        -- Emission probabilities
    );
    constant Pi : fp16_6_array(0 to NUM_STATES-1) := (
        -- Initial state probabilities
    );
    
    -- Signals for delta and psi
    signal delta : fp16_6_array(0 to NUM_STATES-1, 0 to NUM_OBS-1);
    signal psi   : integer_array(0 to NUM_STATES-1, 0 to NUM_OBS-1);
    
    -- Variables for computations
    variable max_val  : fp16_6;
    variable max_state: integer;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Initialize delta and psi
                for i in 0 to NUM_STATES-1 loop
                    delta(i, 0) <= (Pi(i) * B(i, 0)) srl FP_FRACTIONAL;
                    psi(i, 0) <= 0;
                end loop;
            else
                -- Recursion step
                for t in 1 to NUM_OBS-1 loop
                    for j in 0 to NUM_STATES-1 loop
                        max_val := (others => '0');
                        max_state := 0;
                        for i in 0 to NUM_STATES-1 loop
                            -- Compute the value
                            variable val : fp16_6;
                            val := ((delta(i, t-1) * A(i, j)) srl FP_FRACTIONAL);
                            if val > max_val then
                                max_val := val;
                                max_state := i;
                            end if;
                        end loop;
                        delta(j, t) <= (max_val * B(j, t)) srl FP_FRACTIONAL;
                        psi(j, t) <= max_state;
                    end loop;
                end loop;
                -- Backtracking
                -- Initialize state_sequence(NUM_OBS-1)
                max_val := (others => '0');
                max_state := 0;
                for i in 0 to NUM_STATES-1 loop
                    if delta(i, NUM_OBS-1) > max_val then
                        max_val := delta(i, NUM_OBS-1);
                        max_state := i;
                    end if;
                end loop;
                state_sequence(NUM_OBS-1) <= max_state;
                -- Backtrack through psi
                for t in reverse NUM_OBS-2 downto 0 loop
                    state_sequence(t) <= psi(state_sequence(t+1), t+1);
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
