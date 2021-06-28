# Create PFM attributes
set_property PFM_NAME "xilinx.com:xd:${PLATFORM_NAME}:${VER}" [get_files [current_bd_design].bd]

set_property PFM.CLOCK {clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"} clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"} clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"}} [get_bd_cells /clk_wiz_0]
set_property PFM.AXI_PORT {M_AXI_HPM1_FPD {memport "M_AXI_GP"} S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "HPC1" memory "ps_e HPC1_DDR_LOW"}  S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "ps_e HP0_DDR_LOW"}  S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "ps_e HP1_DDR_LOW"}  S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "ps_e HP2_DDR_LOW"}} [get_bd_cells /ps_e]

set parVal []
for {set i 1} {$i < 64} {incr i} {
  lappend parVal M[format %02d $i]_AXI {memport "M_AXI_GP"}
}
set_property PFM.AXI_PORT $parVal [get_bd_cells /interconnect_axilite]

set hp3Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp3Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP3" memory "ps_e HP3_DDR_LOW"}
}
set_property PFM.AXI_PORT $hp3Val [get_bd_cells /interconnect_axifull]

set hpc0Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hpc0Val S[format %02d $i]_AXI {memport "S_AXI_HPC" sptag "HPC0" memory "ps_e HPC0_DDR_LOW"}
}
set_property PFM.AXI_PORT $hpc0Val [get_bd_cells /axi_interconnect_hpc0]

set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]

#Platform Properties
set_property platform.default_output_type "sd_card" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.extensible "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]

file mkdir ./xilinx_zcu104_base/xilinx_zcu104_base.sdk

save_bd_design
validate_bd_design
generate_target  all  [get_files  ./xilinx_zcu104_base/xilinx_zcu104_base.srcs/sources_1/bd/xilinx_zcu104_base/xilinx_zcu104_base.bd]
make_wrapper -files [get_files ./xilinx_zcu104_base/xilinx_zcu104_base.srcs/sources_1/bd/xilinx_zcu104_base/xilinx_zcu104_base.bd] -top
add_files -norecurse ./xilinx_zcu104_base/xilinx_zcu104_base.srcs/sources_1/bd/xilinx_zcu104_base/hdl/xilinx_zcu104_base_wrapper.v

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
