`include "pipeline_registers_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module pipeline_registers_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  pipeline_registers_if prif ();

  // test program
  test PROG (CLK, nRST, prif);
  // DUT
`ifndef MAPPED
  pipeline_registers DUT(CLK, nRST, prif);
`else
  pipeline_registers DUT(CLK, nRST, prif);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  pipeline_registers_if prif
);

  integer print;
  integer k;

  task wait_cycles;
  input integer cycles;
  begin
    for (k = 0; k < cycles; k ++) begin
      @(negedge CLK);
    end
  end
  endtask

  initial begin
    @(negedge CLK);
    nRST = 1;
    @(negedge CLK);
    nRST = 0;
    @(negedge CLK);
    nRST = 1;
    print = 1;
    prif.ihit = 0;
    prif.if_pc = 32'h0000FFFF;
    prif.id_rdat1 = 32'h0000FFFF;
    prif.id_rdat2 = 32'h0000FFFF;
    prif.ex_aluout = 32'h0000FFFF;
    prif.mem_dmemload = 32'h0000FFFF;
    prif.mem_dmemstore = 32'h0000FFFF;
    prif.id_extender_out = 32'h0000FFFF;
    prif.id_instr = SLTI;
    prif.id_funct = SLT;
    prif.id_rs = 10;
    prif.id_rt = 9;
    prif.id_rd = 8;
    prif.id_shamt = 4;
    prif.id_aluop = ALU_ADD;
    prif.id_lui = 1;
    prif.id_halt = 1;
    prif.id_ext_type = 1;
    prif.id_alusrc = 1;
    prif.id_memtoreg = 1;
    prif.id_RWEN = 1;
    prif.id_imemREN = 1;
    prif.id_dmemREN = 1;
    prif.id_dmemWEN = 1;
    prif.id_jump = 1;
    prif.id_branch = 1;
    prif.id_link = 1;
    prif.id_shift = 1;
    prif.id_regtopc = 1;
    wait_cycles(3);
    prif.ihit = 1;
    wait_cycles(3);
    prif.ihit = 0;
    wait_cycles(3);
    prif.ihit = 1;
    wait_cycles(3);
    prif.if_stall = 1;
    wait_cycles(3);
    prif.if_stall = 0;
    wait_cycles(3);
    prif.id_stall = 1;
    wait_cycles(3);
    prif.id_stall = 0;
    wait_cycles(3);
    prif.ex_stall = 1;
    wait_cycles(3);
    prif.ex_stall = 0;
    wait_cycles(3);
    prif.mem_stall = 1;
    wait_cycles(3);
    prif.mem_stall = 0;
    wait_cycles(3);
  end


endprogram

