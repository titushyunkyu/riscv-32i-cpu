# Pipelined RISC-V 32I CPU

This project is a Verilog implementation of a RISC-V 32I CPU. The design includes a five-stage pipelined datapath with Fetch, Decode, Execute, Memory, and Writeback stages. Pipeline registers are used between stages, and hazard handling is implemented for register forwarding, load-use stalls, and branch flushes.

## Features

- RISC-V 32I instruction support
- Five-stage pipelined CPU design
- Behavioral Verilog implementation
- Register forwarding for data hazards
- Pipeline stall logic for load-use hazards
- Pipeline flush logic for taken branches and jumps
- Register file and RAM verification through simulation

## Repository Structure

```text
src/
    Verilog source files for the CPU design

asm/
    RISC-V assembly test programs used for verification

docs/
    Project report and verification documentation
