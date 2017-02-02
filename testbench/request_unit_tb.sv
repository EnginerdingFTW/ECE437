`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  request_unit_if ruif ();

  // test program
  test PROG (CLK, nRST, ruif);
  // DUT
`ifndef MAPPED
  request_unit DUT(CLK, nRST, ruif);
`else
  request_unit DUT(CLK, nRST, ruif);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  request_unit_if ruif
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
    ruif.MemToReg = 0;
    ruif.WriteMem = 0;
    ruif.dhit = 0;
    ruif.ihit = 0;
    ruif.addr = '0;
    wait_cycles(3);
    //load
    ruif.MemToReg = 1;
    wait_cycles(3);
    ruif.dhit = 1;
    wait_cycles(1);
    ruif.dhit = 0;
    wait_cycles(3);
    ruif.MemToReg = 0;
    ruif.WriteMem = 1;
    wait_cycles(3);
    ruif.ihit = 1;
    ruif.dhit = 1;
    wait_cycles(1);
    ruif.ihit = 0;
    ruif.dhit = 0;
    wait_cycles(2);
    ruif.ihit = 1;
    wait_cycles(2);
    ruif.ihit = 0;
    wait_cycles(2);

  end


endprogram

