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
  parameter CPUS = 2;

  assign ccif.ramREN = (ccif.dREN == 1 || cif.iREN == 1);
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.dload = ccif.ramload;
  assign ccif.iload = ccif.ramload;
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
      else if begin
        if (ccif.iREN == 1) begin
          ccif.iwait = 0;
        end
      end
    end
  end
endmodule
