# scripts/synthesize.tcl

# TCL script for synthesizing the project using Xilinx Vivado

# Set the project name and directory
set project_name "gunshot_detection_fpga"
set project_dir "./"

# Create a new project
create_project $project_name $project_dir -part xc7z020clg484-1

# Add source files
add_files -scan_for_includes \
    ./src/pkg/fixed_point_pkg.vhd \
    ./src/mfcc/*.vhd \
    ./src/hmm/*.vhd \
    ./src/top_level.vhd

# Add constraints
add_files ./constraints/constraints.xdc

# Set the top module
set_property top top_level [current_fileset]

# Run synthesis
launch_runs synth_1 -jobs 4

# Wait for synthesis to complete
wait_on_run synth_1

# Run implementation
launch_runs impl_1 -to_step write_bitstream -jobs 4

# Wait for implementation to complete
wait_on_run impl_1

# Generate bitstream
write_bitstream -force $project_dir/$project_name.bit

# Close the project
close_project
