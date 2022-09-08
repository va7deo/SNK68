derive_pll_clocks
derive_clock_uncertainty

# core specific constraints
# create_clock -name clk_6M -period "6.0 MHz" [get_nets {emu|clk_6M}]
create_generated_clock -name clk_6M -source [get_nets {emu|pll|pll_inst|altera_pll_i|outclk_wire[0]}] -divide_by 12 [get_nets {emu|clk_6M}]

# create_clock -name clk_18M -period "18.0 MHz" [get_nets {emu|clk_18M}]
create_generated_clock -name clk_18M -source [get_nets {emu|pll|pll_inst|altera_pll_i|outclk_wire[0]}] -divide_by 4 [get_nets {emu|clk_18M}]

# create_clock -name clk_4M -period "4.0 MHz" [get_nets {emu|clk_4M}]
create_generated_clock -name clk_4M -source [get_nets {emu|pll|pll_inst|altera_pll_i|outclk_wire[0]}] -divide_by 18 [get_nets {emu|clk_4M}]



