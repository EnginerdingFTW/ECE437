`ifndef PC_IF_VH
`define PC_IF_VH

`include "cpu_types_pkg.vh"

interface pc_if;
  import cpu_types_pkg::*;

  word_t pcaddr, alu_out, instruction;
  logic [IMM_W-1:0] imm16;
  logic branch, jump, equal, link, pcen, toreg;

  modport pc (
    input alu_out, instruction, imm16, branch, jump, equal, toreg, pcen,
    output pcaddr
  );

  modport tb (
    input pcaddr,
    output alu_out, instruction, imm16, branch, jump, equal, toreg, pcen
  );

endinterface

`endif
