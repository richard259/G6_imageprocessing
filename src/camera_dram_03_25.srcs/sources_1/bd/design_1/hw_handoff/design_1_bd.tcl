
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# OV7670_config, OV7670_config_rom, SCCB_inverted_logic, camera_read_with_addr, compression, self_init, sevenSegment, threshold_control, vga_mux, pingPongDRAMController, pixelToStream, streamToVga

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-1
   set_property BOARD_PART digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_4 "Massive input buffer to deal with potential for the frames in and out to have their
blanking periods go out of sync. This might cause some pixels to be lost since the
input from the camera does not respect any back-pressure.

Needed to cover potentially 45 lines, so a depth of 3600 is needed.
640*2 (bytes per row) * 45 (blanking rows) / 2 (relative frequency of output to input) * 8 (byte witdh)" [get_bd_designs $design_name]
  set_property USER_COMMENTS.comment_5 "With better control over the output,
the buffer can be quite small" [get_bd_designs $design_name]

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_vga_dram
proc create_hier_cell_hier_vga_dram { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_vga_dram() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR2_0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 PIP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 PIXEL

  # Create pins
  create_bd_pin -dir I PIPenable
  create_bd_pin -dir O -from 3 -to 0 bOut
  create_bd_pin -dir I -type clk clk_in
  create_bd_pin -dir O -from 3 -to 0 gOut
  create_bd_pin -dir O hSync
  create_bd_pin -dir I newFrameStart
  create_bd_pin -dir I pixelClk
  create_bd_pin -dir O -from 3 -to 0 rOut
  create_bd_pin -dir I resetn
  create_bd_pin -dir O vSync

  # Create instance: axi_datamover_0, and set properties
  set axi_datamover_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_datamover:5.1 axi_datamover_0 ]
  set_property -dict [ list \
   CONFIG.c_dummy {0} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {8} \
   CONFIG.c_mm2s_include_sf {false} \
   CONFIG.c_s2mm_burst_size {8} \
   CONFIG.c_s_axis_s2mm_tdata_width {64} \
   CONFIG.c_single_interface {1} \
 ] $axi_datamover_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {191.399} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.2} \
   CONFIG.CLKOUT2_JITTER {126.455} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {144.719} \
   CONFIG.CLKOUT3_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_OUT1_PORT {clk_vga} \
   CONFIG.CLK_OUT2_PORT {clk_200} \
   CONFIG.CLK_OUT3_PORT {clk_100} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {31.750} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: fifo_to_dram, and set properties
  set fifo_to_dram [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_to_dram ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {7} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Safety_Circuit {true} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Flags_Reset_Value {1} \
   CONFIG.Full_Threshold_Assert_Value_axis {511} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {512} \
   CONFIG.Programmable_Empty_Type_axis {Single_Programmable_Empty_Threshold_Constant} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TKEEP_WIDTH {8} \
   CONFIG.TSTRB_WIDTH {8} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_to_dram

  # Create instance: fifo_to_vga, and set properties
  set fifo_to_vga [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_to_vga ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_axis {62} \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.Enable_Safety_Circuit {true} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Flags_Reset_Value {1} \
   CONFIG.Full_Threshold_Assert_Value_axis {57} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {64} \
   CONFIG.Programmable_Empty_Type_axis {No_Programmable_Empty_Threshold} \
   CONFIG.Programmable_Full_Type_axis {Single_Programmable_Full_Threshold_Constant} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TKEEP_WIDTH {8} \
   CONFIG.TSTRB_WIDTH {8} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_to_vga

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0 ]

  # Create instance: pingPongDRAMControll_0, and set properties
  set block_name pingPongDRAMController
  set block_cell_name pingPongDRAMControll_0
  if { [catch {set pingPongDRAMControll_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pingPongDRAMControll_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PONG {0x82000000} \
   CONFIG.BYTES_PER_TRANSFER {64} \
 ] $pingPongDRAMControll_0

  # Create instance: pixelToStream_0, and set properties
  set block_name pixelToStream
  set block_cell_name pixelToStream_0
  if { [catch {set pixelToStream_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pixelToStream_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.PACKETS_TO_APPEND {0} \
   CONFIG.STREAM_WIDTH {64} \
 ] $pixelToStream_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_input, and set properties
  set proc_sys_reset_input [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_input ]

  # Create instance: streamToVga_0, and set properties
  set block_name streamToVga
  set block_cell_name streamToVga_0
  if { [catch {set streamToVga_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $streamToVga_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.PIP_SCALE {4} \
   CONFIG.STREAM_WIDTH {64} \
 ] $streamToVga_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins DDR2_0] [get_bd_intf_pins mig_7series_0/DDR2]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins PIP] [get_bd_intf_pins streamToVga_0/PIP]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins PIXEL] [get_bd_intf_pins pixelToStream_0/PIXEL]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_datamover_0/M_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_datamover_0_M_AXIS_MM2S [get_bd_intf_pins axi_datamover_0/M_AXIS_MM2S] [get_bd_intf_pins fifo_to_vga/S_AXIS]
  connect_bd_intf_net -intf_net axi_datamover_0_M_AXIS_MM2S_STS [get_bd_intf_pins axi_datamover_0/M_AXIS_MM2S_STS] [get_bd_intf_pins pingPongDRAMControll_0/MM2S_STS]
  connect_bd_intf_net -intf_net axi_datamover_0_M_AXIS_S2MM_STS [get_bd_intf_pins axi_datamover_0/M_AXIS_S2MM_STS] [get_bd_intf_pins pingPongDRAMControll_0/S2MM_STS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net fifo_to_dram_M_AXIS [get_bd_intf_pins axi_datamover_0/S_AXIS_S2MM] [get_bd_intf_pins fifo_to_dram/M_AXIS]
  connect_bd_intf_net -intf_net fifo_to_vga_M_AXIS [get_bd_intf_pins fifo_to_vga/M_AXIS] [get_bd_intf_pins streamToVga_0/STREAM]
  connect_bd_intf_net -intf_net pingPongDRAMControll_0_MM2S_CMD [get_bd_intf_pins axi_datamover_0/S_AXIS_MM2S_CMD] [get_bd_intf_pins pingPongDRAMControll_0/MM2S_CMD]
  connect_bd_intf_net -intf_net pingPongDRAMControll_0_S2MM_CMD [get_bd_intf_pins axi_datamover_0/S_AXIS_S2MM_CMD] [get_bd_intf_pins pingPongDRAMControll_0/S2MM_CMD]
  connect_bd_intf_net -intf_net pixelToStream_0_STREAM [get_bd_intf_pins fifo_to_dram/S_AXIS] [get_bd_intf_pins pixelToStream_0/STREAM]

  # Create port connections
  connect_bd_net -net M00_ACLK_1 [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net Net1 [get_bd_pins axi_datamover_0/m_axi_mm2s_aresetn] [get_bd_pins axi_datamover_0/m_axi_s2mm_aresetn] [get_bd_pins axi_datamover_0/m_axis_mm2s_cmdsts_aresetn] [get_bd_pins axi_datamover_0/m_axis_s2mm_cmdsts_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins fifo_to_vga/s_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins streamToVga_0/resetn]
  connect_bd_net -net PIPenable_0_1 [get_bd_pins PIPenable] [get_bd_pins streamToVga_0/PIPenable]
  connect_bd_net -net clk_in_1 [get_bd_pins clk_in] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_100 [get_bd_pins axi_datamover_0/m_axi_mm2s_aclk] [get_bd_pins axi_datamover_0/m_axi_s2mm_aclk] [get_bd_pins axi_datamover_0/m_axis_mm2s_cmdsts_aclk] [get_bd_pins axi_datamover_0/m_axis_s2mm_cmdsts_awclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_wiz_0/clk_100] [get_bd_pins fifo_to_dram/s_aclk] [get_bd_pins fifo_to_vga/s_aclk] [get_bd_pins pingPongDRAMControll_0/clk] [get_bd_pins pixelToStream_0/clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins proc_sys_reset_input/slowest_sync_clk] [get_bd_pins streamToVga_0/clk]
  connect_bd_net -net clk_wiz_0_clk_200 [get_bd_pins clk_wiz_0/clk_200] [get_bd_pins mig_7series_0/sys_clk_i]
  connect_bd_net -net clk_wiz_0_clk_vga [get_bd_pins clk_wiz_0/clk_vga] [get_bd_pins streamToVga_0/pixelClk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_input/dcm_locked]
  connect_bd_net -net fifo_to_dram_axis_prog_empty [get_bd_pins fifo_to_dram/axis_prog_empty] [get_bd_pins pingPongDRAMControll_0/inputFIFOEmpty]
  connect_bd_net -net fifo_to_dram_m_axis_tlast [get_bd_pins fifo_to_dram/m_axis_tlast] [get_bd_pins pingPongDRAMControll_0/s2mmLast]
  connect_bd_net -net fifo_to_vga_axis_prog_full [get_bd_pins fifo_to_vga/axis_prog_full] [get_bd_pins pingPongDRAMControll_0/outputFIFOFull]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net newFrameStart_0_1 [get_bd_pins newFrameStart] [get_bd_pins pingPongDRAMControll_0/newFrameStart]
  connect_bd_net -net pingPongDRAMControll_0_resetForFrameN [get_bd_pins pingPongDRAMControll_0/resetForFrameN] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net pixelClk_0_1 [get_bd_pins pixelClk] [get_bd_pins pixelToStream_0/pixelClk]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net resetn_1 [get_bd_pins resetn] [get_bd_pins mig_7series_0/sys_rst] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net resetn_for_frame [get_bd_pins fifo_to_dram/s_aresetn] [get_bd_pins pingPongDRAMControll_0/resetn] [get_bd_pins pixelToStream_0/resetn] [get_bd_pins proc_sys_reset_input/peripheral_aresetn]
  connect_bd_net -net streamToVga_0_bOut [get_bd_pins bOut] [get_bd_pins streamToVga_0/bOut]
  connect_bd_net -net streamToVga_0_gOut [get_bd_pins gOut] [get_bd_pins streamToVga_0/gOut]
  connect_bd_net -net streamToVga_0_hSync [get_bd_pins hSync] [get_bd_pins streamToVga_0/hSync]
  connect_bd_net -net streamToVga_0_rOut [get_bd_pins rOut] [get_bd_pins streamToVga_0/rOut]
  connect_bd_net -net streamToVga_0_vSync [get_bd_pins vSync] [get_bd_pins streamToVga_0/vSync]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins proc_sys_reset_input/ext_reset_in] [get_bd_pins util_vector_logic_0/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR2_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR2_0 ]

  # Create ports
  set AN [ create_bd_port -dir O -from 7 -to 0 AN ]
  set BTNC [ create_bd_port -dir I BTNC ]
  set BTND [ create_bd_port -dir I BTND ]
  set BTNL [ create_bd_port -dir I BTNL ]
  set BTNR [ create_bd_port -dir I -type rst BTNR ]
  set BTNU [ create_bd_port -dir I BTNU ]
  set CA [ create_bd_port -dir O CA ]
  set CB [ create_bd_port -dir O CB ]
  set CC [ create_bd_port -dir O CC ]
  set CD [ create_bd_port -dir O CD ]
  set CE [ create_bd_port -dir O CE ]
  set CF [ create_bd_port -dir O CF ]
  set CG [ create_bd_port -dir O CG ]
  set CLK_I [ create_bd_port -dir I -type clk CLK_I ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {CPU_RESETN} \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $CLK_I
  set CPU_RESETN [ create_bd_port -dir I CPU_RESETN ]
  set DP [ create_bd_port -dir O DP ]
  set LED1 [ create_bd_port -dir O LED1 ]
  set LED2 [ create_bd_port -dir O LED2 ]
  set LED3 [ create_bd_port -dir O LED3 ]
  set PCLK [ create_bd_port -dir I -type clk PCLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {24000000} \
 ] $PCLK
  set PWDN [ create_bd_port -dir O -from 0 -to 0 PWDN ]
  set SIOC_oe [ create_bd_port -dir O SIOC_oe ]
  set SIOD_oe [ create_bd_port -dir O SIOD_oe ]
  set SW [ create_bd_port -dir I -from 15 -to 0 SW ]
  set VGA_B [ create_bd_port -dir O -from 3 -to 0 VGA_B ]
  set VGA_G [ create_bd_port -dir O -from 3 -to 0 VGA_G ]
  set VGA_HS [ create_bd_port -dir O VGA_HS ]
  set VGA_R [ create_bd_port -dir O -from 3 -to 0 VGA_R ]
  set VGA_VS [ create_bd_port -dir O VGA_VS ]
  set XCLK [ create_bd_port -dir O -type clk XCLK ]
  set href [ create_bd_port -dir I href ]
  set p_data [ create_bd_port -dir I -from 7 -to 0 p_data ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset
  set vsync [ create_bd_port -dir I vsync ]

  # Create instance: OV7670_config_0, and set properties
  set block_name OV7670_config
  set block_cell_name OV7670_config_0
  if { [catch {set OV7670_config_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $OV7670_config_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLK_FREQ {24000000} \
 ] $OV7670_config_0

  # Create instance: OV7670_config_rom_0, and set properties
  set block_name OV7670_config_rom
  set block_cell_name OV7670_config_rom_0
  if { [catch {set OV7670_config_rom_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $OV7670_config_rom_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: SCCB_inverted_logic_0, and set properties
  set block_name SCCB_inverted_logic
  set block_cell_name SCCB_inverted_logic_0
  if { [catch {set SCCB_inverted_logic_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $SCCB_inverted_logic_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLK_FREQ {24000000} \
 ] $SCCB_inverted_logic_0

  # Create instance: camera_read_with_addr_0, and set properties
  set block_name camera_read_with_addr
  set block_cell_name camera_read_with_addr_0
  if { [catch {set camera_read_with_addr_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $camera_read_with_addr_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {24000000} \
 ] [get_bd_pins /camera_read_with_addr_0/p_clock]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {184.947} \
   CONFIG.CLKOUT1_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_JITTER {137.681} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {200.470} \
   CONFIG.CLKOUT3_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {25} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLK_OUT1_PORT {clk_24} \
   CONFIG.CLK_OUT2_PORT {clk_100} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {9.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {37.500} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {9} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: compression_0, and set properties
  set block_name compression
  set block_cell_name compression_0
  if { [catch {set compression_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $compression_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: de_noise_0, and set properties
  set de_noise_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:de_noise:2.1 de_noise_0 ]

  # Create instance: edge_detection_0, and set properties
  set edge_detection_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:edge_detection:4.3 edge_detection_0 ]

  # Create instance: hier_vga_dram
  create_hier_cell_hier_vga_dram [current_bd_instance .] hier_vga_dram

  # Create instance: self_init_0, and set properties
  set block_name self_init
  set block_cell_name self_init_0
  if { [catch {set self_init_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $self_init_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sevenSegment_0, and set properties
  set block_name sevenSegment
  set block_cell_name sevenSegment_0
  if { [catch {set sevenSegment_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sevenSegment_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_DIVISION {100000} \
 ] $sevenSegment_0

  # Create instance: threshold_control_0, and set properties
  set block_name threshold_control
  set block_cell_name threshold_control_0
  if { [catch {set threshold_control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $threshold_control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vga_mux_0, and set properties
  set block_name vga_mux
  set block_cell_name vga_mux_0
  if { [catch {set vga_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vga_mux_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {b11111} \
   CONFIG.CONST_WIDTH {5} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {12} \
   CONFIG.DOUT_WIDTH {4} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {2} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create interface connections
  connect_bd_intf_net -intf_net compression_0_PIP [get_bd_intf_pins compression_0/PIP] [get_bd_intf_pins hier_vga_dram/PIP]
  connect_bd_intf_net -intf_net hier_vga_dram_DDR2_0 [get_bd_intf_ports DDR2_0] [get_bd_intf_pins hier_vga_dram/DDR2_0]
  connect_bd_intf_net -intf_net vga_mux_0_OUTPXL [get_bd_intf_pins hier_vga_dram/PIXEL] [get_bd_intf_pins vga_mux_0/OUTPXL]

  # Create port connections
  connect_bd_net -net BTNR_1 [get_bd_ports BTNR] [get_bd_pins compression_0/reset]
  connect_bd_net -net CLK_I_1 [get_bd_ports CLK_I] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins sevenSegment_0/clk]
  connect_bd_net -net OV7670_config_0_SCCB_interface_addr [get_bd_pins OV7670_config_0/SCCB_interface_addr] [get_bd_pins SCCB_inverted_logic_0/address]
  connect_bd_net -net OV7670_config_0_SCCB_interface_data [get_bd_pins OV7670_config_0/SCCB_interface_data] [get_bd_pins SCCB_inverted_logic_0/data]
  connect_bd_net -net OV7670_config_0_SCCB_interface_start [get_bd_pins OV7670_config_0/SCCB_interface_start] [get_bd_pins SCCB_inverted_logic_0/start]
  connect_bd_net -net OV7670_config_0_rom_addr [get_bd_pins OV7670_config_0/rom_addr] [get_bd_pins OV7670_config_rom_0/addr]
  connect_bd_net -net OV7670_config_rom_0_dout [get_bd_pins OV7670_config_0/rom_data] [get_bd_pins OV7670_config_rom_0/dout]
  connect_bd_net -net PCLK_1 [get_bd_ports PCLK] [get_bd_pins camera_read_with_addr_0/p_clock] [get_bd_pins compression_0/clk] [get_bd_pins de_noise_0/clk] [get_bd_pins edge_detection_0/clk] [get_bd_pins hier_vga_dram/pixelClk] [get_bd_pins vga_mux_0/clk]
  connect_bd_net -net PIPenable_1 [get_bd_pins hier_vga_dram/PIPenable] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net SCCB_inverted_logic_0_ready [get_bd_pins OV7670_config_0/SCCB_interface_ready] [get_bd_pins SCCB_inverted_logic_0/ready]
  connect_bd_net -net SW_1 [get_bd_ports SW] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net btnc_0_1 [get_bd_ports BTNL] [get_bd_pins self_init_0/btnc]
  connect_bd_net -net btnc_0_2 [get_bd_ports BTNC] [get_bd_pins threshold_control_0/btnc]
  connect_bd_net -net btndown_0_1 [get_bd_ports BTND] [get_bd_pins threshold_control_0/btndown]
  connect_bd_net -net btnup_0_1 [get_bd_ports BTNU] [get_bd_pins threshold_control_0/btnup]
  connect_bd_net -net camera_read_with_addr_0_detection [get_bd_pins camera_read_with_addr_0/detection] [get_bd_pins compression_0/pixel_in] [get_bd_pins edge_detection_0/pixel_in]
  connect_bd_net -net camera_read_with_addr_0_frame_done [get_bd_pins camera_read_with_addr_0/frame_done] [get_bd_pins compression_0/v_sync] [get_bd_pins de_noise_0/reset] [get_bd_pins edge_detection_0/reset] [get_bd_pins hier_vga_dram/newFrameStart] [get_bd_pins vga_mux_0/newFrame]
  connect_bd_net -net camera_read_with_addr_0_pixel_data [get_bd_pins camera_read_with_addr_0/pixel_data] [get_bd_pins vga_mux_0/data_in_1]
  connect_bd_net -net camera_read_with_addr_0_pixel_valid [get_bd_pins camera_read_with_addr_0/pixel_valid] [get_bd_pins compression_0/in_valid] [get_bd_pins edge_detection_0/in_valid] [get_bd_pins vga_mux_0/data_valid_1]
  connect_bd_net -net camera_read_with_addr_0_wr_addr [get_bd_pins camera_read_with_addr_0/wr_addr] [get_bd_pins vga_mux_0/addr_in_1]
  connect_bd_net -net clk_wiz_0_clk_24 [get_bd_ports XCLK] [get_bd_pins OV7670_config_0/clk] [get_bd_pins OV7670_config_rom_0/clk] [get_bd_pins SCCB_inverted_logic_0/clk] [get_bd_pins clk_wiz_0/clk_24] [get_bd_pins self_init_0/clk]
  connect_bd_net -net clk_wiz_0_clk_100 [get_bd_pins clk_wiz_0/clk_100] [get_bd_pins hier_vga_dram/clk_in] [get_bd_pins threshold_control_0/clk]
  connect_bd_net -net compression_0_recognized_int [get_bd_pins compression_0/recognized_int] [get_bd_pins sevenSegment_0/digit0]
  connect_bd_net -net compression_0_recognized_int2 [get_bd_pins compression_0/recognized_int2] [get_bd_pins sevenSegment_0/digit2]
  connect_bd_net -net compression_0_recognized_int3 [get_bd_pins compression_0/recognized_int3] [get_bd_pins sevenSegment_0/digit3]
  connect_bd_net -net de_noise_0_addr [get_bd_pins de_noise_0/addr] [get_bd_pins vga_mux_0/addr_in_3]
  connect_bd_net -net de_noise_0_data_out [get_bd_pins de_noise_0/data_out] [get_bd_pins vga_mux_0/data_in_3]
  connect_bd_net -net de_noise_0_output_valid [get_bd_pins de_noise_0/output_valid] [get_bd_pins vga_mux_0/data_valid_3]
  connect_bd_net -net design_1_0_SIOC_oe [get_bd_ports SIOC_oe] [get_bd_pins SCCB_inverted_logic_0/SIOC_oe]
  connect_bd_net -net design_1_0_SIOD_oe [get_bd_ports SIOD_oe] [get_bd_pins SCCB_inverted_logic_0/SIOD_oe]
  connect_bd_net -net edge_detection_0_addr [get_bd_pins edge_detection_0/addr] [get_bd_pins vga_mux_0/addr_in_2]
  connect_bd_net -net edge_detection_0_data_out [get_bd_pins edge_detection_0/data_out] [get_bd_pins vga_mux_0/data_in_2] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net edge_detection_0_output_valid [get_bd_pins de_noise_0/in_valid] [get_bd_pins edge_detection_0/output_valid] [get_bd_pins vga_mux_0/data_valid_2]
  connect_bd_net -net hier_vga_dram_bOut [get_bd_ports VGA_B] [get_bd_pins hier_vga_dram/bOut]
  connect_bd_net -net hier_vga_dram_gOut [get_bd_ports VGA_G] [get_bd_pins hier_vga_dram/gOut]
  connect_bd_net -net hier_vga_dram_hSync [get_bd_ports VGA_HS] [get_bd_pins hier_vga_dram/hSync]
  connect_bd_net -net hier_vga_dram_rOut [get_bd_ports VGA_R] [get_bd_pins hier_vga_dram/rOut]
  connect_bd_net -net hier_vga_dram_vSync [get_bd_ports VGA_VS] [get_bd_pins hier_vga_dram/vSync]
  connect_bd_net -net href_1 [get_bd_ports href] [get_bd_pins camera_read_with_addr_0/href]
  connect_bd_net -net p_data_1 [get_bd_ports p_data] [get_bd_pins camera_read_with_addr_0/p_data]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/resetn]
  connect_bd_net -net resetn_0_1 [get_bd_ports CPU_RESETN] [get_bd_pins hier_vga_dram/resetn]
  connect_bd_net -net self_init_0_start [get_bd_pins OV7670_config_0/start] [get_bd_pins self_init_0/start]
  connect_bd_net -net sevenSegment_0_AN [get_bd_ports AN] [get_bd_pins sevenSegment_0/AN]
  connect_bd_net -net sevenSegment_0_CA [get_bd_ports CA] [get_bd_pins sevenSegment_0/CA]
  connect_bd_net -net sevenSegment_0_CB [get_bd_ports CB] [get_bd_pins sevenSegment_0/CB]
  connect_bd_net -net sevenSegment_0_CC [get_bd_ports CC] [get_bd_pins sevenSegment_0/CC]
  connect_bd_net -net sevenSegment_0_CD [get_bd_ports CD] [get_bd_pins sevenSegment_0/CD]
  connect_bd_net -net sevenSegment_0_CE [get_bd_ports CE] [get_bd_pins sevenSegment_0/CE]
  connect_bd_net -net sevenSegment_0_CF [get_bd_ports CF] [get_bd_pins sevenSegment_0/CF]
  connect_bd_net -net sevenSegment_0_CG [get_bd_ports CG] [get_bd_pins sevenSegment_0/CG]
  connect_bd_net -net sevenSegment_0_DP [get_bd_ports DP] [get_bd_pins sevenSegment_0/DP]
  connect_bd_net -net threshold_control_0_COMPRESSION [get_bd_pins compression_0/threshold] [get_bd_pins sevenSegment_0/digit5] [get_bd_pins threshold_control_0/COMPRESSION]
  connect_bd_net -net threshold_control_0_DENOISE [get_bd_pins de_noise_0/thresh] [get_bd_pins sevenSegment_0/digit6] [get_bd_pins threshold_control_0/DENOISE]
  connect_bd_net -net threshold_control_0_EDGE_DETECTION [get_bd_pins edge_detection_0/thresh] [get_bd_pins sevenSegment_0/digit7] [get_bd_pins threshold_control_0/EDGE_DETECTION]
  connect_bd_net -net threshold_control_0_led1 [get_bd_ports LED1] [get_bd_pins threshold_control_0/led1]
  connect_bd_net -net threshold_control_0_led2 [get_bd_ports LED2] [get_bd_pins threshold_control_0/led2]
  connect_bd_net -net threshold_control_0_led3 [get_bd_ports LED3] [get_bd_pins threshold_control_0/led3]
  connect_bd_net -net vsync_1 [get_bd_ports vsync] [get_bd_pins camera_read_with_addr_0/vsync]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports PWDN] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins sevenSegment_0/digit1] [get_bd_pins sevenSegment_0/digit4] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins de_noise_0/pixel_in] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins vga_mux_0/SW] [get_bd_pins xlslice_1/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x08000000 -offset 0x80000000 [get_bd_addr_spaces hier_vga_dram/axi_datamover_0/Data] [get_bd_addr_segs hier_vga_dram/mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


