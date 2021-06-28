# *************************************************************************
#    ____  ____
#   /   /\/   /
#  /___/  \  /
#  \   \   \/    © Copyright 2017 Xilinx, Inc. All rights reserved.
#   \   \        This file contains confidential and proprietary
#   /   /        information of Xilinx, Inc. and is protected under U.S.
#  /___/   /\    and international copyright and other intellectual
#  \   \  /  \   property laws.
#   \___\/\___\
#
#
# *************************************************************************
#
# Disclaimer:
#
#       This disclaimer is not a license and does not grant any rights to
#       the materials distributed herewith. Except as otherwise provided in
#       a valid license issued to you by Xilinx, and to the maximum extent
#       permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE
#       "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
#       WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
#       INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
#       NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#       (2) Xilinx shall not be liable (whether in contract or tort,
#       including negligence, or under any other theory of liability) for
#       any loss or damage of any kind or nature related to, arising under
#       or in connection with these materials, including for any direct, or
#       any indirect, special, incidental, or consequential loss or damage
#       (including loss of data, profits, goodwill, or any type of loss or
#       damage suffered as a result of any action brought by a third party)
#       even if such damage or loss was reasonably foreseeable or Xilinx
#       had been advised of the possibility of the same.
#
# Critical Applications:
#
#       Xilinx products are not designed or intended to be fail-safe, or
#       for use in any application requiring fail-safe performance, such as
#       life-support or safety devices or systems, Class III medical
#       devices, nuclear facilities, applications related to the deployment
#       of airbags, or any other applications that could lead to death,
#       personal injury, or severe property or environmental damage
#       (individually and collectively, "Critical Applications"). Customer
#       assumes the sole risk and liability of any use of Xilinx products
#       in Critical Applications, subject only to applicable laws and
#       regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS
# FILE AT ALL TIMES.
#
# *************************************************************************

# Define FPM NAME
set_property PFM_NAME "xilinx:xd:${PLATFORM_NAME}:${VER}" [get_files pfm_dynamic.bd]

# Define AXI_PORT for AXI_LITE control
set parVal []
for {set i 1} {$i < 64} {incr i} {
  lappend parVal M[format %02d $i]_AXI {memport "M_AXI_GP"}
}
set_property PFM.AXI_PORT $parVal [get_bd_cells /interconnect_axilite_user_slr1]

set hp3Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp3Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP3" memory "interconnect_aximm_ddrmem2_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp3Val [get_bd_cells /interconnect_axifull_1_user_slr1]


set hpc0Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hpc0Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP0" memory "interconnect_aximm_ddrmem3_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hpc0Val [get_bd_cells /interconnect_axifull_2_user_slr1]

set hp1Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp1Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP1" memory "interconnect_aximm_ddrmem4_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp1Val [get_bd_cells /axi_interconnect_0]

set hp2Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp2Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP2" memory "interconnect_aximm_ddrmem5_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp2Val [get_bd_cells /axi_interconnect_1]


# Define CLOCK
set_property PFM.CLOCK {clkwiz_kernel_clk_out1 {id "0" is_default "true" proc_sys_reset "reset_controllers/psreset_gate_pr_kernel"  status "fixed"} \
                       } [get_bd_ports /clkwiz_kernel_clk_out1]
set_property PFM.CLOCK {clkwiz_kernel2_clk_out1 {id "1" is_default "false" proc_sys_reset "reset_controllers/psreset_gate_pr_kernel2"  status "fixed"} \
                       } [get_bd_ports /clkwiz_kernel2_clk_out1]
set_property PFM.CLOCK {clkwiz_sysclks_clk_out2 {id "2" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_control" status "fixed"} \
			} [get_bd_ports /clkwiz_sysclks_clk_out2]
set_property PFM.CLOCK {clkwiz_kernel3_clk_out {id "3" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel3" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel3_clk_out]
set_property PFM.CLOCK {clkwiz_kernel4_clk_out {id "4" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel4" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel4_clk_out]
set_property PFM.CLOCK {clkwiz_kernel5_clk_out {id "5" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel6" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel5_clk_out]
set_property PFM.CLOCK {clkwiz_kernel6_clk_out {id "6" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel5" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel6_clk_out]
