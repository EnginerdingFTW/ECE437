`ifndef PC_IF_VH
`define PC_IF_VH

`include "cpu_types_pkg.vh"

interface pc_if;
  import cpu_types_pkg::*;

  word_t pcaddr, next_pc;
  word_t ex_pc, id_rdat1, ex_rdat1, id_instruction;
  logic [IMM_W-1:0] id_imm16, ex_imm16;
  logic id_jump, id_branch, id_toreg;
  logic ex_equal, ex_branch, ex_jump;
  logic pcen;

  modport pc (
    input ex_pc, id_rdat1, ex_rdat1, id_instruction, id_imm16, ex_imm16, id_jump,
          id_branch, id_toreg, ex_equal, ex_branch, ex_jump, pcen,
    output pcaddr, next_pc
  );

  modport tb (
    input pcaddr, next_pc,
    output ex_pc, id_rdat1, ex_rdat1, id_instruction, id_imm16, ex_imm16, id_jump,
           id_branch, id_toreg, ex_equal, ex_branch, ex_jump, pcen
  );

endinterface

`endif
