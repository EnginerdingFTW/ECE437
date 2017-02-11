`include "pc_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module pc_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  pc_if pcif ();

  // test program
  test PROG (CLK, nRST, pcif);
  // DUT
`ifndef MAPPED
  pc DUT(CLK, nRST, pcif);
`else
  pc DUT(
    .\pcif.pcen(pcif.pcen),
    .\pcif.equal(pcif.equal),
    .\pcif.jump(pcif.jump),
    .\pcif.branch(pcif.branch),
    .\pcif.imm16(pcif.imm16),
    .\pcif.instruction(pcif.instruction),
    .\pcif.alu_out(pcif.alu_out),
    .\pcif.pcaddr(pcif.pcaddr)
);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  pc_if pcif
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
    pcif.rdat1 = 32'hBBBBBBBB;
    pcif.instruction = 32'hAAAAAAAA;
    pcif.imm16 = 16'h0020;
    pcif.branch = 0;
    pcif.jump = 0;
    pcif.equal = 0;
    pcif.pcen = 0;
    pcif.toreg = 0;

    wait_cycles(3);

    pcif.pcen = 1;
    wait_cycles(6);
    pcif.jump = 1;
    wait_cycles(3);
    pcif.toreg = 1;
    wait_cycles(3);
    pcif.rdat1 = 32'h00000000;
    wait_cycles(3);

    //BNE
    pcif.id_pc = 32'h00001000;
    pcif.jump = 0;
    pcif.branch = 1;
    wait_cycles(3);
    pcif.equal = 1;
    wait_cycles(3);

    //go back to 0 for reading sake
    pcif.branch = 0;
    pcif.jump = 1;
    wait_cycles(6);
    pcif.jump = 0;

    //BEQ
    pcif.jump = 1;
    pcif.branch = 1;
    wait_cycles(3);
    pcif.equal = 0;
    wait_cycles(3);

  end

endprogram

