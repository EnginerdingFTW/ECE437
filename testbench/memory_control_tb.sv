`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif ();
  cpu_ram_if ramif ();


  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramstate = ccif.ramstate;
  assign ramif.ramload = ccif.ramload;


  // test program
  test PROG (CLK, nRST, ccif);
  // DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
  ram RAM_MOD(CLK, nRST, ramif);
`else
  memory_control DUT(
    .\ccif.ccsnoopaddr(ccif.snoopaddr),
    .\ccif.ccinv(ccif.ccinv),
    .\ccif.ccwait(ccif.ccwait),
    .\ccif.ramREN(ccif.ramREN),
    .\ccif.ramWEN(ccif.ramWEN),
    .\ccif.ramaddr(ccif.ramaddr),
    .\ccif.ramstore(ccif.ramstore),
    .\ccif.dload(ccif.dload),
    .\ccif.iload(ccif.iload),
    .\ccif.dwait(ccif.dwait),
    .\ccif.iwait(ccif.iwait),
    .\ccif.cctrans(ccif.cctrans),
    .\ccif.ccwrite(ccif.ccwrite),
    .\ccif.ramstate(ccif.ramstate),
    .\ccif.ramload(ccif.ramload),
    .\ccif.daddr(ccif.daddr),
    .\ccif.iaddr(ccif.iaddr),
    .\ccif.dstore(ccif.dstore),
    .\ccif.dWEN(ccif.dWEN),
    .\ccif.dREN(ccif.dREN),
    .\ccif.iREN(ccif.iREN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
  ram RAM_MOD(
    .\ramif.ramload(ramif.ramload),
    .\ramif.ramstate(ramif.ramstate),
    .\ramif.ramWEN(ramif.ramWEN),
    .\ramif.ramREN(ramif.ramREN),
    .\ramif.ramstore(ramif.ramstore),
    .\ramif.ramaddr(ramif.ramaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  cache_control_if.cc ccif
);


initial begin
  @(negedge CLK);
  nRST = 1;
  @(negedge CLK);
  nRST = 0;
  @(negedge CLK);
  nRST = 1;
  @(negedge CLK);
  @(negedge CLK);


endprogram
