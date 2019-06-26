# Copyright 2018 ARDUINO SA (http://www.arduino.cc/)
# This file is part of Vidor IP.
# Copyright (c) 2018
# Authors: Dario Pennisi
#
# This software is released under:
# The GNU General Public License, which covers the main part of
# Vidor IP
# The terms of this license can be found at:
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# You can be released from the requirements of the above licenses by purchasing
# a commercial license. Buying such a license is mandatory if you want to modify or
# otherwise use the software for commercial activities involving the Arduino
# software without disclosing the source code of your own applications. To purchase
# a commercial license, send an email to license@arduino.cc.

#
# request TCL package from ACDS 16.1
#
package require -exact qsys 16.1


#
# module PWM
#
set_module_property DESCRIPTION ""
set_module_property NAME PWM
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP ipTronix
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME PWM
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK            elaboration_callback


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL PWM
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file PWM.v SYSTEM_VERILOG PATH PWM.v TOP_LEVEL_FILE


#
# parameters
#
add_parameter pCHANNELS INTEGER 16
set_parameter_property pCHANNELS DEFAULT_VALUE 16
set_parameter_property pCHANNELS DISPLAY_NAME pCHANNELS
set_parameter_property pCHANNELS TYPE INTEGER
set_parameter_property pCHANNELS UNITS None
set_parameter_property pCHANNELS HDL_PARAMETER true
set_parameter_property pCHANNELS ALLOWED_RANGES {1:32}
add_parameter pPRESCALER_BITS INTEGER 32
set_parameter_property pPRESCALER_BITS DEFAULT_VALUE 32
set_parameter_property pPRESCALER_BITS DISPLAY_NAME pPRESCALER_BITS
set_parameter_property pPRESCALER_BITS TYPE INTEGER
set_parameter_property pPRESCALER_BITS UNITS None
set_parameter_property pPRESCALER_BITS HDL_PARAMETER true
set_parameter_property pPRESCALER_BITS ALLOWED_RANGES {1:32}
add_parameter pMATCH_BITS INTEGER 32
set_parameter_property pMATCH_BITS DEFAULT_VALUE 32
set_parameter_property pMATCH_BITS DISPLAY_NAME pMATCH_BITS
set_parameter_property pMATCH_BITS TYPE INTEGER
set_parameter_property pMATCH_BITS UNITS None
set_parameter_property pMATCH_BITS HDL_PARAMETER true
set_parameter_property pMATCH_BITS ALLOWED_RANGES {1:32}


#
# display items
#


#
# connection point avalon_slave
#
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clk
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 1
set_interface_property avalon_slave readWaitTime 0
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave iWRITE_DATA writedata Input 32
add_interface_port avalon_slave iWRITE write Input 1
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


#
# connection point clk
#
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk iCLOCK clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset iRESET reset Input 1


#
# connection point pwm
#
add_interface pwm conduit end
set_interface_property pwm associatedClock clk
set_interface_property pwm associatedReset ""
set_interface_property pwm ENABLED true
set_interface_property pwm EXPORT_OF ""
set_interface_property pwm PORT_NAME_MAP ""
set_interface_property pwm CMSIS_SVD_VARIABLES ""
set_interface_property pwm SVD_ADDRESS_GROUP ""

# -----------------------------------------------------------------------------
proc log2 {value} {
  set value [expr $value-1]
  for {set log2 0} {$value>0} {incr log2} {
     set value  [expr $value>>1]
  }
  return $log2;
}

# -----------------------------------------------------------------------------
# callbacks
# -----------------------------------------------------------------------------
proc elaboration_callback {} {
  set channels [expr { 1+ [get_parameter_value pCHANNELS] } ]
  add_interface_port avalon_slave iADDRESS address Input [log2 $channels]
  add_interface_port pwm oPWM pwm Output $channels
  set_module_assignment embeddedsw.CMacro.CHANNELS $channels
}

