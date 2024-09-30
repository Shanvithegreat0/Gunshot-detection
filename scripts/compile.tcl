# scripts/compile.tcl

# Tcl script for compiling VHDL files using your preferred simulator
# Replace 'simulator_command' with actual commands

simulator_command -work work \
    src/pkg/fixed_point_pkg.vhd \
    src/mfcc/*.vhd \
    src/hmm/*.vhd \
    src/top_level.vhd \
    sim/tb_mfcc.vhd \
    sim/tb_hmm.vhd \
    sim/tb_top_level.vhd
