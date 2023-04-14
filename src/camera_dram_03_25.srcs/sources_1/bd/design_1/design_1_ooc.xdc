################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name PCLK -period 41.667 [get_ports PCLK]
create_clock -name CLK_I -period 10 [get_ports CLK_I]

################################################################################