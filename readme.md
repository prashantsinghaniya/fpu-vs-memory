# Optimizing RISC-V Performance: FPU Register Caching for Reduced Memory Traffic

## 1. Project Overview
This project explores an architectural optimization technique for RISC-V processors: utilizing the Floating-Point Unit (FPU) register file as a "software-managed cache" for temporary data storage.

Modern processors often suffer from the "Memory Wall," where CPU execution speed outpaces memory access speed. By manually managing data placement and "hoisting" frequently used constants or intermediate values into FPU registers (`f0` - `f31`), this project demonstrates significant performance improvements by reducing Load/Store instructions and minimizing pipeline stalls.

## 2. Objectives
As outlined in the project requirements:
* **Feasibility:** Determine if FPU registers can store data for immediate future use to avoid memory access.
* **Implementation:** Develop curated assembly programs (Matrix Multiplication and FFT) to demonstrate this benefit.
* **Analysis:** Compare "Baseline" (Memory-bound) vs. "Modified" (Register-bound) implementations.
* **Sensitivity Study:** Analyze performance under varying relative latencies (Memory vs. FPU speed) using the gem5 simulator.

## 3. Methodology

### 3.1 The Optimization Strategy
Two versions of each benchmark were created in RISC-V Assembly:
1.  **Baseline Implementation:** Follows a standard **Load-Compute-Store** paradigm. Data is loaded from memory immediately before use and results are stored back immediately. This reflects unoptimized compiler behavior.
2.  **Modified Implementation (Register Caching):** Uses loop tiling and register blocking. Data required for a block of computation is loaded *once* into FPU registers, reused across multiple arithmetic operations, and stored only when the block is complete.

### 3.2 Benchmarks
* **Matrix Multiplication ($128 \times 128$):** A compute-intensive kernel highly sensitive to memory bandwidth.
* **Fast Fourier Transform (16-point):** A signal processing kernel involving complex number arithmetic and butterfly operations.

### 3.3 Simulation Environment
* **Simulator:** gem5 (version 23.x/24.x)
* **Architecture:** RISC-V (64-bit)
* **CPU Model:** Modified O3CPU (Out-of-Order).
    * *Modification:* The CPU was constrained to a scalar pipeline (Issue width = 1) to accurately measure pipeline stalls and latency effects without aggressive superscalar masking.
* **Latency Modeling:** Experiments were run with varying D-Cache latencies (1, 2, 3 cycles) vs. FPU latencies (1, 2 cycles).

## 4. Directory Structure
Ensure your project folder is organized as follows for the automation script to work:

```text
|-gem5/
|-project/
  ├── input_dir/                   # Place all .s source files here
  │   ├── matrix_mul_original.s
  │   ├── matrix_mul_modified.s
  │   ├── fft_mem16.s
  │   └── fft_modified16.s
  ├── scripts/
  │   ├── run.sh                   # Automation script (Compile + Link + Simulate)
  │   └── find_parameter.py        # Python parser for gem5 stats
  ├── dump_dir/                    # Generated .o objects and executables (Auto-created)
  ├── output_dir/                  # gem5 simulation results (Auto-created)
  ├── link.ld
  |-- run.sh                      # Linker script (Required by run.sh)
  |-- random_number.py.           # generating the random numbers for result verification
  |-- find_parameter.py           # finding simsecond cycles etc
  └── README.md

How to Run
The project uses a unified automation script (run.sh) that handles assembly, linking, and simulation in one step.

Prerequisites
RISC-V Toolchain: Ensure riscv64-linux-gnu-as and riscv64-linux-gnu-ld are in your PATH.

Linker Script: Ensure link.ld is present in the root directory.

Source Files: Place your assembly files (.s) inside the input_dir folder.

modify_se.py: plce modify_se.py at location gem5/configs/deprecated/example

Run the script providing the filename (which must exist inside input_dir).

What the modify_se.py does:
makes the o3 cpu inorder and is used for changing latency

# Example: Running the original.s
./run.sh original.s

What the script does:

Assembles: Converts input_dir/file.s to dump_dir/file.o.

Links: Links the object file using link.ld to create the executable in dump_dir/.

Simulates: Runs gem5 using the O3CPU and caches, outputting results to output_dir/file/.


After the simulation completes, use the Python script to extract key metrics from the detailed gem5 statistics.

Bash

# Example extraction
python3 scripts/find_parameter.py output_dir/matrix_mul_modified/stats.txt
Output Files
Console Output: output_dir/<filename>/sim_stdout.txt (Contains the printed matrix/FFT results).

Statistics: output_dir/<filename>/stats.txt (Contains cycle counts, cache hits/misses, etc.).
