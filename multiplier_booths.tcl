# Define library paths
set LIBRARY_HOME "/home/Amoghhdixit/ASIC/ASIC-LABS/ASIC-Flow_labs_v1p4/library_32nm/SAED32_EDK"
set TARGET_LIBRARY "saed32rvt_ss0p95v125c.db"
set LOGICAL_LIBRARY_PATH "${LIBRARY_HOME}/lib/stdcell_rvt/db_nldm"


# Define project paths
set search_path "/home/Amoghhdixit/RSA/replace_with_your_name/codes/"
lappend search_path "${LOGICAL_LIBRARY_PATH}"

set_app_var search_path "${search_path}"
set_app_var target_library "${TARGET_LIBRARY}"
set_app_var synthetic_library dw_foundation.sldb
set_app_var link_library "* $target_library $synthetic_library"

# Define working directory
define_design_lib work -path "work"

# Read Verilog files
analyze -library work -format verilog multiplier_booths.v
elaborate -architecture verilog -library work multiplier_booths

# Check design
#check_desig 

# Compile
# uniquify
# compile -area_effort medium -map_effort high -power_effort high

# Reports
report_cell 
report_area 
report_timing
report_power

# Design optimization Constrains 
create_clock -period 4 [get_ports clock]
#creat_clock -period 4 -waveform {1 0} -name master_clock
set_input_delay 2 -clock clock [all_inputs]
set_output_delay 2 -clock clock [all_outputs] 
#area
set_max_area 300
#power
#set_max_leakage_power 10uw

#DRC
#set_wire_load_mode TOP
set_max_transition 0.01 [current_design]
set_max_capacitance 0.05 [current_design]
set_load 5 [get_ports done]
set_fanout_load 5 [get_ports OUT]
set_drive 1.5 [get_ports load]
# Reports
report_cell 
report_area 
report_timing
report_power

#optimize
#compile_ultra
#compile_ultra -gate_clock

write -format verilog -hierarchy -output muliplier_booth.v

#SDC file
write_sdc counter_async_constraints.sdc
