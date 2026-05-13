//**
// ECE 3058 Architecture Concurrency and Energy in Computation
//
// RISCV Processor System Verilog Behavioral Model
//
// School of Electrical & Computer Engineering
// Georgia Institute of Technology
// Atlanta, GA 30332
//
//  Engineer:   Zou, Ivan
//  Module:     core_tb
//  Functionality:
//      This is the testbed for the 5 Stage Pipeline RISCV processor
//
//**
`timescale 1ns / 1ns

module Core_tb;

// Clock and Reset signals to simulate as input into core
    logic clk = 1;
    logic mem_enable;
    logic reset;

    // local variables to display for testbench
    logic[6:0] cycle_count;

    integer i;

    initial
    begin
        cycle_count = 0;

        // do the simulation
        $dumpfile("Core_Simulation.vcd");

        // dump all the signals into the vcd waveforem file
        $dumpvars(0, Core_tb);

        reset = 1'b1;
        mem_enable = 1'b1;

        // Set the Test instructions and preset MEM and Regfile here if desired

        // Start Testbench Test Instructions. First instruction should always be a NOP

        #1 

        // 0x00000000 - First
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[0] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[1] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[2] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[3] = 8'h00;

    // 0x00002783
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[4] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[5] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[6] = 8'h27;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[7] = 8'h83;

    // 0x00178793
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[8] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[9] = 8'h17;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[10] = 8'h87;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[11] = 8'h93;

    // 0x0080056f
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[12] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[13] = 8'h80;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[14] = 8'h05;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[15] = 8'h6f;

    // 0x00a182b3
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[16] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[17] = 8'ha1;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[18] = 8'h82;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[19] = 8'hb3;

    // 0x00a782b3
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[20] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[21] = 8'ha7;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[22] = 8'h82;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[23] = 8'hb3;

    // 0x004005ef
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[24] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[25] = 8'h40;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[26] = 8'h05;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[27] = 8'hef;

    // 0x0040066f
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[28] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[29] = 8'h40;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[30] = 8'h06;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[31] = 8'h6f;

    // 0x00c582b3
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[32] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[33] = 8'hc5;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[34] = 8'h82;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[35] = 8'hb3;

    // 0x003282b3
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[36] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[37] = 8'h32;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[38] = 8'h82;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[39] = 8'hb3;

    // 0x00c006ef
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[40] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[41] = 8'hc0;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[42] = 8'h06;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[43] = 8'hef;

    // 0x003a8a33
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[44] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[45] = 8'h3a;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[46] = 8'h8a;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[47] = 8'h33;

    // 0xfd9ff76f
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[48] = 8'hfd;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[49] = 8'h9f;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[50] = 8'hf7;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[51] = 8'h6f;

    // 0x00402683
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[52] = 8'h00;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[53] = 8'h40;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[54] = 8'h26;
    core_proc.InstructionFetch_Module.InstructionMemory.instr_RAM[55] = 8'h83;

        #6 reset = 1'b0;

        #50 $finish;
    end

    always
        #1 clk <= clk + 1;

    always @(posedge clk) begin
        if (~reset)
            cycle_count <= cycle_count + 1;
    end

    Core core_proc(
        // Inputs
        .clock(clk),
        .reset(reset),
        .mem_en(mem_enable)
    );

endmodule