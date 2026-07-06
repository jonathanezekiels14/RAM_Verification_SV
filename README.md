# Single-Port RAM SystemVerilog Verification

## Overview
This repository contains the complete SystemVerilog-based functional verification for a synchronous Single-Port Random Access Memory (RAM) RTL design[cite: 12]. The instantiated memory is an 8-bit wide, 32-location deep (5-bit address) architecture[cite: 12]. The verification environment exhaustively validates all operational modes through a structured, Object-Oriented Programming (OOP) testbench[cite: 12].

## Design Architecture
The DUT is a synchronous single-port memory where all operations occur on the positive edge of the clock[cite: 12].

| Signal | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1-bit | System clock for all register updates[cite: 12]. |
| `reset` | 1-bit | Synchronous active-high reset[cite: 12]. |
| `write_enb` | 1-bit | Write enable signal[cite: 12]. |
| `read_enb` | 1-bit | Read enable signal[cite: 12]. |
| `data_in` | 8-bit | Write data input[cite: 12]. |
| `address` | 5-bit | Memory address selecting one of 32 locations[cite: 12]. |
| `data_out` | 8-bit | Read data output[cite: 12]. |

## Verification Environment
The testbench is a fully layered OOP SystemVerilog environment[cite: 12].
* Components include a generator, driver, reference model, monitor, and scoreboard[cite: 12].
* Communication between components is handled exclusively via typed mailboxes[cite: 12].
* The interface utilizes separate `drv_cb`, `mon_cb`, and `ref_cb` clocking blocks to prevent race conditions[cite: 12].
* The regression suite executes five distinct tests covering random and directed stimulus[cite: 12].

## Identified Hardware Bugs
During verification, three critical functional bugs were discovered in the DUT[cite: 12]:
* **Unhandled Simultaneous R/W:** Asserting both read and write enables simultaneously lacks priority encoding, leading to indeterminate outputs[cite: 12].
* **Partial Reset:** The synchronous reset only clears the memory at the currently pointed address rather than wiping the entire 32-location array[cite: 12].
* **High-Impedance Output:** Deasserting both enables forces the output to a high-Z state, which is physically unrealizable in actual SRAM silicon[cite: 12].

## Simulation Results & Coverage
The regression test suite yielded the following metrics[cite: 12]:

| Metric | Result |
| :--- | :--- |
| Total Comparisons | 325[cite: 12] |
| Passed | 100 (30.8%)[cite: 12] |
| Failed | 225 (69.2%)[cite: 12] |
| Functional Coverage | 100%[cite: 12] |
| Code Coverage | 99.66%[cite: 12] |

## Future Work
* Correct the identified WBR/RBW priority, full-array reset, and high-Z logic bugs in the RTL[cite: 12].
* Refactor the environment into a complete UVM architecture featuring a sequence library and `uvm_reg` model[cite: 12].
* Implement parameterized compile-time testing to sweep various data and address widths[cite: 12].
* Add SystemVerilog Assertions (SVA) to formally verify output stability and reset conditions[cite: 12].
