# Copyright 2021 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

file mkdir build 
cd build
source ../xsa_scripts/project.tcl
source ../xsa_scripts/dr.bd.tcl
source ../xsa_scripts/pfm_decls.tcl

#Wrapper Generation
make_wrapper -files [get_files ./xilinx_zcu102_base/xilinx_zcu102_base.srcs/sources_1/bd/xilinx_zcu102_base/xilinx_zcu102_base.bd] -top
add_files -norecurse ./xilinx_zcu102_base/xilinx_zcu102_base.srcs/sources_1/bd/xilinx_zcu102_base/hdl/xilinx_zcu102_base_wrapper.v

#Target Generate Step
generate_target all [get_files ./xilinx_zcu102_base/xilinx_zcu102_base.srcs/sources_1/bd/xilinx_zcu102_base/xilinx_zcu102_base.bd]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#Generate the final simulation script which will compile
launch_simulation -scripts_only
launch_simulation -step compile
launch_simulation -step elaborate

#Generating Emulation XSA
file mkdir hw_emu
write_hw_platform -hw_emu -file hw_emu/hw_emu.xsa

#Generating Pre-Synth HW XSA
set pre_synth ""

if { $argc > 1} {
  set pre_synth [lindex $argv 2]
}
if {$pre_synth} {
  set_property platform.platform_state "pre_synth" [current_project]
  write_hw_platform -hw -force -file hw.xsa
} else {
  launch_runs impl_1 -to_step write_bitstream -jobs 16
  wait_on_run impl_1
  write_hw_platform -hw -force -include_bit -file hw.xsa
}
#generate README.hw

set fd [open README.hw w] 

set board [lindex $argv 0]

puts $fd "##########################################################################"
puts $fd "This is a brief document containing design specific details for : ${board}"
puts $fd "This is auto-generated by Petalinux ref-design builder created @ [clock format [clock seconds] -format {%a %b %d %H:%M:%S %Z %Y}]"
puts $fd "##########################################################################"

set board_part [get_board_parts [current_board_part -quiet]]
if { $board_part != ""} {
  puts $fd "BOARD: $board_part" 
}

set design_name [get_property NAME [get_bd_designs]]
puts $fd "BLOCK DESIGN: $design_name" 

set columns {%40s%30s%15s%50s}
puts $fd [string repeat - 150]
puts $fd [format $columns "MODULE INSTANCE NAME" "IP TYPE" "IP VERSION" "IP"]
puts $fd [string repeat - 150]
foreach ip [get_ips] {
  set catlg_ip [get_ipdefs -all [get_property IPDEF $ip]] 
  puts $fd [format $columns [get_property NAME $ip] [get_property NAME $catlg_ip] [get_property VERSION $catlg_ip] [get_property VLNV $catlg_ip]]
}
close $fd

cd ..
