/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  assign ccif.ramREN = ((ccif.dREN == 1 | ccif.iREN == 1) & (ccif.dWEN == 0));
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.dload = ccif.ramload;
  assign ccif.iload = (ccif.iREN == 1) ? ccif.ramload : '0;
  assign ccif.ramstore = ccif.dstore;

  always_comb begin
    if (ccif.dREN == 1 || ccif.dWEN == 1) begin //d instr > i instr
      ccif.ramaddr = ccif.daddr;
    end
    else begin
      ccif.ramaddr = ccif.iaddr;
    end

    ccif.iwait = 1;
    ccif.dwait = 1;
    if (ccif.ramstate == ACCESS) begin    //d instr > i instr
      if (ccif.dWEN == 1 || ccif.dREN == 1) begin
        ccif.dwait = 0;
      end
      else if (ccif.iREN) begin
        ccif.iwait = 0;
      end
    end
  end
endmodule
