`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif ();

  // test program
  test PROG (CLK, nRST, huif);
  // DUT
`ifndef MAPPED
  hazard_unit DUT(huif);
`else
  hazard_unit DUT(huif);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  hazard_unit_if huif
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
    k = -1;
    huif.ex_opcode = RTYPE;
    huif.id_opcode = RTYPE;
    huif.mem_dmemREN = 0;
    huif.mem_dmemWEN = 0;
    huif.funct = SLL;
    huif.branch_predicted = 1;
    huif.mem_instr = J;
    huif.mem_rd = 1;
    huif.ex_rs = 0;
    huif.ex_rt = 0;
    huif.dhit = 0;
    wait_cycles(3);
    huif.id_opcode = J;
    wait_cycles(3);
    huif.id_opcode = JAL;
    wait_cycles(3);
    huif.id_opcode = RTYPE;
    huif.funct = JR;
    wait_cycles(3);
    huif.ex_opcode = BNE;
    huif.branch_predicted = 0;
    wait_cycles(3);
    huif.ex_opcode = BEQ;
    wait_cycles(3);
    huif.branch_predicted = 1;
    huif.ex_opcode = RTYPE;
    huif.mem_instr = LW;
    wait_cycles(3);
    huif.ex_rs = 1;
    huif.mem_dmemWEN = 1;
    wait_cycles(3);

  end

endprogram

