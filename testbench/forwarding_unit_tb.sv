`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module forwarding_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  forwarding_unit_if fuif ();

  // test program
  test PROG (CLK, nRST, fuif);
  // DUT
`ifndef MAPPED
  forwarding_unit DUT(fuif);
`else
  forwarding_unit DUT(fuif);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  forwarding_unit_if fuif
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
    fuif.ex_rs = 1;
    fuif.ex_rt = 2;
    fuif.mem_rd = 3;
    fuif.wb_rd = 4;
    fuif.mem_aluout = 32'h66666666;
    fuif.wb_aluout = 32'h77777777;
    fuif.ex_rdat1 = 32'h11111111;
    fuif.ex_rdat2 = 32'h22222222;
    fuif.wb_pc = 32'h33333333;
    fuif.out_pc = 32'h44444444;
    fuif.mem_instr = RTYPE;
    fuif.wb_instr = RTYPE;
    fuif.temp_dmemload = 32'h55555555;
    wait_cycles(3);
    fuif.mem_rd = 1;
    wait_cycles(3);
    fuif.mem_instr = LW;
    wait_cycles(3);
    fuif.mem_rd = 2;
    wait_cycles(3);
    fuif.mem_rd = 3;
    fuif.mem_instr = RTYPE;
    wait_cycles(3);
    fuif.wb_rd = 1;
    wait_cycles(3);
    fuif.wb_rd = 2;
    wait_cycles(3);
    fuif.wb_rd = 4;
    fuif.mem_rd = 2;
    fuif.mem_instr = JAL;
    wait_cycles(3);
    fuif.mem_rd = 4;
    fuif.wb_rd = 2;
    fuif.wb_instr = JAL;
    fuif.mem_rd = 3;
    wait_cycles(3);
  end

endprogram

