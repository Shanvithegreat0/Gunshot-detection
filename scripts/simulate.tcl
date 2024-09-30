# scripts/simulate.tcl

# Run simulations for testbenches
simulator_command -do "run -all" tb_mfcc
simulator_command -do "run -all" tb_hmm
simulator_command -do "run -all" tb_top_level
