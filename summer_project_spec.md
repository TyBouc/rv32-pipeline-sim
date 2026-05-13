# Summer Project: RV32I Pipeline Verification Environment
**Goal:** internship + NE hardware recruiting  
**Timeline:** June 1 – August 15 (~10.5 weeks)  
**Roles it targets:** Design Verification Engineer, RTL Design Engineer  

---

## What You're Building

A **self-checking verification environment** for a pipelined RISC-V processor.

This means three things working together:

1. **DUT** — A clean 5-stage RV32I pipeline in SystemVerilog (your pipeline, not Lab 2's)
2. **ISS** — A golden reference model in C that simulates the same instructions functionally
3. **Testbench** — A Verilator-based harness that runs programs through both, compares outputs, and reports bugs

At the end, you can run any RV32I program through your environment and it will automatically tell you:
- Whether the pipeline executed it correctly (register file + memory match)
- How many cycles it took (CPI)
- Which hazards were triggered (RAW, load-use, branch flush)
- Where it failed if it didn't pass

---

## Why This Project Specifically

### What AMD verification interns actually do
They write testbenches. They build reference models. They run constrained-random tests
to find bugs in RTL that directed tests miss. This project is that workflow, built from scratch.

### Why it's not your coursework
- Lab 2: you fixed a broken pipeline. No testbench, no reference model, no randomized testing.
- Lab 3/4: C simulators for cache and VM. No hardware, no co-simulation.
- This project: you own the full verification methodology. New skills, new framing.

### Why Verilator specifically
Verilator is the industry-standard open-source RTL simulator. AMD uses it.
Knowing it is itself a resume bullet. It compiles SystemVerilog into C++, which lets
your C ISS and your SV testbench talk to each other directly — no file-passing hacks.

### The resume line
> "Designed a self-checking verification environment for a pipelined RV32I processor
> including a C-based ISS golden reference, SystemVerilog assertions, and constrained-
> random test generation using Verilator co-simulation"

That maps directly to every verification intern JD AMD has posted.

---

## The Three Components

### 1. DUT — RV32I 5-Stage Pipeline (SystemVerilog)
Your pipeline. Written clean, from scratch (informed by Lab 2 but not copied).

**Stages:** IF → ID → EX → MEM → WB  
**Instructions:** ADD, ADDI, SUB, LW, SW, BEQ, BNE, JAL, SLT (extend Lab 2's set)  
**Hazard handling:**
- Data forwarding (EX→EX, MEM→EX)
- Load-use stall
- Branch flush (resolve in EX)

**What's new vs. Lab 2:**
- SW instruction (Lab 2 didn't require stores)
- BEQ/BNE (conditional branches, not just JAL)
- Designed to be verified, not just to pass Gradescope

---

### 2. ISS — Instruction Set Simulator (C)
A functional (not timing-accurate) RV32I simulator.  
~400-600 lines of C. No pipeline, no cycles — just: fetch, decode, execute, update state.

**Inputs:** Binary instruction stream + initial memory contents  
**Outputs:** Final register file state + final memory state  

This is your ground truth. If the DUT disagrees with the ISS, there's a bug in the pipeline.

**Key functions:**
```c
void iss_reset(ISS *cpu);
void iss_load_program(ISS *cpu, uint32_t *instrs, int count);
void iss_run(ISS *cpu);           // run to completion
uint32_t iss_get_reg(ISS *cpu, int reg);
uint32_t iss_get_mem(ISS *cpu, uint32_t addr);
```

This is genuinely new work. You've never written an ISS. It's not a cache sim or VM sim.

---

### 3. Testbench — Verilator Co-Simulation Harness (C++)
The glue that runs both and compares them.

**Flow per test:**
1. Generate (or load) an instruction program
2. Run it through ISS → capture golden register file + memory
3. Run it through DUT (Verilator simulation) → capture DUT register file + memory
4. Compare: PASS or FAIL with diff of mismatched registers
5. Log CPI, stall cycles, hazard counts

**Test categories:**
- **Directed:** hand-written programs targeting specific hazards
- **Constrained random:** randomly generated valid RV32I sequences (no illegal encodings)
- **Regression:** all previous failing tests, run every time to prevent regressions

---

## Test Suite Breakdown

### Directed Tests (write these first)
| Test Name | What It Exercises |
|---|---|
| `test_no_hazard` | Back-to-back independent instructions |
| `test_raw_forward_ex` | RAW resolved by EX→EX forwarding |
| `test_raw_forward_mem` | RAW resolved by MEM→EX forwarding |
| `test_load_use` | Load-use stall (1 cycle inserted) |
| `test_branch_not_taken` | BEQ where branch not taken |
| `test_branch_taken` | BEQ where branch taken, flush 2 instructions |
| `test_jal` | JAL + link register correctness |
| `test_store_load` | SW then LW to same address |
| `test_chain_hazards` | 5+ instruction chain with mixed RAW dependencies |
| `test_loop` | Small loop (10 iterations) using BNE |

### Constrained Random Tests
Write a C function that generates random programs with constraints:
- Only valid opcodes
- Register indices 0-31
- Immediate values in valid ranges
- Occasionally force hazard patterns (back-to-back writes to same register)

Run 500-1000 random programs. Any mismatch between ISS and DUT is a bug.

### Performance Tests
- `matmul_3x3`: 3x3 matrix multiply hand-coded in RV32I assembly
- `bubble_sort`: sort 8 elements
- Report CPI for each. These become your "results" section.

---

## Repo Structure

```
rv32i-verif/
├── rtl/
│   ├── core/
│   │   ├── IF_Stage.sv
│   │   ├── ID_Stage.sv
│   │   ├── EX_Stage.sv
│   │   ├── MEM_Stage.sv
│   │   ├── WB_Stage.sv
│   │   ├── Hazard_Unit.sv
│   │   ├── Forward_Unit.sv
│   │   └── Core.sv
│   └── tb/
│       └── assertions.sv        ← SVA properties
├── iss/
│   ├── iss.h
│   ├── iss.c                    ← golden reference model
│   └── iss_test.c               ← standalone ISS tests
├── sim/
│   ├── tb_main.cpp              ← Verilator testbench harness
│   ├── test_gen.c               ← random test generator
│   └── compare.c                ← register file diff checker
├── tests/
│   ├── directed/
│   │   ├── test_raw_forward.S   ← RISC-V assembly
│   │   └── ...
│   └── random/
│       └── (generated at runtime)
├── scripts/
│   ├── run_all.sh               ← run full test suite
│   ├── run_directed.sh
│   └── gen_report.py            ← parse logs → summary table
├── docs/
│   ├── architecture.md
│   └── results.md               ← your analysis writeup
├── Makefile
└── README.md
```

---

## Week-by-Week Plan

### Week 1 — Environment + DUT skeleton
- Install Verilator, confirm it works
- Write pipeline skeleton: all stages present, wires connected, no logic yet
- Confirm it compiles through Verilator with no errors
- Set up GitHub repo with structure above
- **Checkpoint:** `make` produces a Verilator simulation binary

### Week 2 — DUT functional (no hazards)
- Implement instruction decode + ALU + register file
- ADD, ADDI, SUB, LW, SW working with no-hazard programs
- Write `test_no_hazard` directed test manually, confirm it passes
- **Checkpoint:** 3 directed no-hazard tests pass

### Week 3 — ISS in C
- Write the full RV32I ISS
- Test it standalone: run the same no-hazard programs, confirm register state
- **Checkpoint:** ISS produces correct register file for 10 hand-written programs

### Week 4 — Verilator harness + self-checking
- Write `tb_main.cpp`: load program → run DUT → extract state → compare vs ISS
- Run first co-simulation: ISS vs DUT, confirm PASS on no-hazard tests
- **Checkpoint:** automated PASS/FAIL working for 5 tests

### Week 5 — Hazard unit: forwarding
- Implement EX→EX and MEM→EX forwarding in `Forward_Unit.sv`
- Write directed RAW forwarding tests
- **Checkpoint:** `test_raw_forward_ex` and `test_raw_forward_mem` pass

### Week 6 — Hazard unit: stalls + flushes
- Implement load-use stall in `Hazard_Unit.sv`
- Implement branch flush (BEQ, BNE, JAL)
- Write directed tests for each
- **Checkpoint:** all 10 directed tests pass

### Week 7 — Constrained random testing
- Write test generator in C
- Run 200 random programs, log any ISS/DUT mismatches
- Fix any bugs the random tests find
- **Checkpoint:** 200 random programs, 0 mismatches

### Week 8 — Performance logging + assembly benchmarks
- Add CPI counter, stall counter, flush counter to testbench
- Write matmul_3x3 and bubble_sort in RV32I assembly
- Run them, record CPI
- **Checkpoint:** CPI numbers for both benchmarks in a table

### Week 9 — SVA assertions + coverage
- Write 5-10 SystemVerilog assertions (e.g., "forwarding path is never active when no hazard exists")
- Add simple hazard coverage: how many of each hazard type were triggered across the random suite
- **Checkpoint:** assertions fire correctly, coverage report generated

### Week 10 — Polish + writeup
- Clean README with: what it is, how to run it, architecture diagram, results table
- Write `docs/results.md`: 1 page analysis of what you found
- Record a 2-minute demo (optional but strong for LinkedIn)
- **Checkpoint:** repo is presentable to a recruiter

---

## What "Done" Looks Like

```
$ make test
[DIRECTED ] test_no_hazard        PASS  CPI=1.00
[DIRECTED ] test_raw_forward_ex   PASS  CPI=1.12
[DIRECTED ] test_raw_forward_mem  PASS  CPI=1.08
[DIRECTED ] test_load_use         PASS  CPI=1.20  stalls=3
[DIRECTED ] test_branch_taken     PASS  CPI=1.33  flushes=2
[DIRECTED ] test_loop             PASS  CPI=1.28
...
[RANDOM   ] 500 tests             PASS  0 mismatches
[BENCH    ] matmul_3x3            PASS  CPI=1.41  cycles=312
[BENCH    ] bubble_sort           PASS  CPI=1.19  cycles=187

Coverage: RAW_EX=234  RAW_MEM=189  LOAD_USE=67  BRANCH_FLUSH=112
```

That output is your interview talking point.

---

## Skills You'll Have When Done

| Skill | Where It Shows Up |
|---|---|
| SystemVerilog RTL design | Every hardware JD |
| Verilator co-simulation | AMD, Google, Rivos, Tenstorrent |
| C ISS / reference model | Architecture + verification roles |
| Constrained-random testing | Verification engineer JDs explicitly |
| SVA assertions | Industry-standard verification methodology |
| RISC-V ISA | Universal in computer architecture hiring |
| Git, Makefiles, structured repo | Table stakes, but done right |

---

## Target Companies in New England This Applies To

| Company | Location | Why This Project Fits |
|---|---|---|
| AMD | Boxborough, MA | Direct match: RTL + verification intern roles |
| Analog Devices | Wilmington, MA | Embedded RTL + verification |
| Marvell | Santa Clara but MA presence | SoC verification |
| Intel | Hudson, MA | CPU verification |
| Draper Laboratory | Cambridge, MA | Embedded systems, RTL |
| MIT Lincoln Laboratory | Lexington, MA | Hardware + systems (needs clearance) |
| Rivos | Remote/distributed | RISC-V startup, verification-heavy |

---

## Where to Start Monday

1. `sudo apt install verilator` — confirm version ≥ 5.0
2. Create GitHub repo `rv32i-verif`, add README placeholder
3. Write `rtl/core/Core.sv` with empty module stubs for all 5 stages
4. Confirm `verilator --lint-only rtl/core/Core.sv` runs clean
5. That's Week 1 Day 1 done.

Everything else follows the week plan above.
