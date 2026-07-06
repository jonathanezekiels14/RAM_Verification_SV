# Single-Port RAM SystemVerilog Verification

## Overview
This repository contains the complete SystemVerilog-based functional verification for a synchronous Single-Port Random Access Memory (RAM) RTL design . The instantiated memory is an 8-bit wide, 32-location deep (5-bit address) architecture . The verification environment exhaustively validates all operational modes through a structured, Object-Oriented Programming (OOP) testbench .

## Design Architecture
The DUT is a synchronous single-port memory where all operations occur on the positive edge of the clock .

| Signal | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1-bit | System clock for all register updates. |
| `reset` | 1-bit | Synchronous active-high reset. |
| `write_enb` | 1-bit | Write enable signal. |
| `read_enb` | 1-bit | Read enable signal. |
| `data_in` | 8-bit | Write data input. |
| `address` | 5-bit | Memory address selecting one of 32 locations. |
| `data_out` | 8-bit | Read data output. |

## Verification Environment
The testbench is a fully layered OOP SystemVerilog environment.
* Components include a generator, driver, reference model, monitor, and scoreboard.
* Communication between components is handled exclusively via typed mailboxes .
* The interface utilizes separate `drv_cb`, `mon_cb`, and `ref_cb` clocking blocks to prevent race conditions .
* The regression suite executes five distinct tests covering random and directed stimulus .

## Identified Hardware Bugs
During verification, three critical functional bugs were discovered in the DUT :
* **Unhandled Simultaneous R/W:** Asserting both read and write enables simultaneously lacks priority encoding, leading to indeterminate outputs .
* **Partial Reset:** The synchronous reset only clears the memory at the currently pointed address rather than wiping the entire 32-location array .
* **High-Impedance Output:** Deasserting both enables forces the output to a high-Z state, which is physically unrealizable in actual SRAM silicon .

## Simulation Results & Coverage
The regression test suite yielded the following metrics :

| Metric | Result |
| :--- | :--- |
| Total Comparisons | 325 |
| Passed | 100 (30.8%)|
| Failed | 225 (69.2%) |
| Functional Coverage | 100% |
| Code Coverage | 99.66% |

## Future Work
* Correct the identified WBR/RBW priority, full-array reset, and high-Z logic bugs in the RTL .
* Refactor the environment into a complete UVM architecture featuring a sequence library and `uvm_reg` model .
* Implement parameterized compile-time testing to sweep various data and address widths .
* Add SystemVerilog Assertions (SVA) to formally verify output stability and reset conditions .
