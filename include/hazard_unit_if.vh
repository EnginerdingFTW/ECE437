`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  import cpu_types_pkg::*;

  opcode_t id_opcode, ex_opcode;
  funct_t funct;
  logic stall, id_flush, mem_flush, ex_flush, wb_flush;
  logic branch_predicted;
  regbits_t ex_rs, ex_rt, mem_rd;
  opcode_t mem_instr;

  modport hu (
    input id_opcode, ex_opcode, funct, branch_predicted,
          ex_rs, ex_rt, mem_rd, mem_instr,
    output stall, id_flush, mem_flush, ex_flush, wb_flush
  );

  modport tb (
    input stall, id_flush, mem_flush, ex_flush, wb_flush,
    output id_opcode, ex_opcode, funct, branch_predicted,
           ex_rs, ex_rt, mem_rd, mem_instr
  );

endinterface

`endif
