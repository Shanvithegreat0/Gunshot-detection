# constraints/constraints.xdc

# =====================================================================
# Clock Constraints
# =====================================================================

# The ZedBoard uses a 100 MHz clock connected to pin E9
set_property PACKAGE_PIN E9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# =====================================================================
# Reset Signal
# =====================================================================

# The reset button is connected to pin C12
set_property PACKAGE_PIN C12 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# =====================================================================
# Audio Input Signal
# =====================================================================

# Assume audio_in is connected to the XADC analog input pin (e.g., AD0P)
# For analog inputs, you need to configure the XADC module separately
# Alternatively, if using a Pmod microphone on JA1 pin, adjust accordingly
set_property PACKAGE_PIN G3 [get_ports audio_in]
set_property IOSTANDARD LVCMOS33 [get_ports audio_in]

# =====================================================================
# Detection Output Signal
# =====================================================================

# Map detection to an LED (e.g., LD0 connected to pin T22)
set_property PACKAGE_PIN T22 [get_ports detection]
set_property IOSTANDARD LVCMOS33 [get_ports detection]
