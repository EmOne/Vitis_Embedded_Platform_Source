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

puts "DTB generation started using XSCT"

set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\""

set dt_repo_path [lindex $argv 1]
puts "dt_repo_path is \"$dt_repo_path\""

set xsa_path [lindex $argv 2]
puts "The xsa path is \"$xsa_path\""

set board [lindex $argv 3]
puts "board is\"$board\""

set core [lindex $argv 4]
puts "core is\"$core\""

set platform_out [lindex $argv 5]
puts "The output path is \"$platform_out\""

set auto_generate [lindex $argv 6]
puts "auto-generate zocl node in dtb option is set to \"$auto_generate\""

# Setting the workspace
#setws $platform_out/Workspace
 
# Adding the device Tree Embedded Sw Repository to xsct
#repo -set $dt_repo_path
::hsi::utils::add_repo $dt_repo_path
 
# Create a $platform_name platform with OS as device_tree, and proc ps core 
platform create -name $platform_name -hw $xsa_path -proc $core -os device_tree -out $platform_out/Workspace

if {$auto_generate} {
  ::hsi::set_property CONFIG.dt_zocl true [hsi get_os]
}

# Set the bsp property periph_type_overrrides to include the BOARD detail.
library -name device_tree -option periph_type_overrides -value "{BOARD $board}"

#Set the default overlay dts name
library -name device_tree -option overlay_custom_dts -value "pl-final.dts"

#dont generate the pl dtsi
#library -name device_tree -option remove_pl -value "true"
 
# Regenerate the bsp to see the modified changes
bsp regenerate

# Generate the platform
platform generate
 
# exit xsct
exit