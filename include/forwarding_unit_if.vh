`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  import cpu_types_pkg::*;

  regbits_t ex_rs, ex_rt, mem_rd, wb_rd;
  word_t mem_aluout, wb_aluout;
  word_t ex_rdat1, ex_rdat2;
  word_t wb_pc, out_pc;
  opcode_t mem_instr, wb_instr;
  word_t temp_dmemload;
  word_t aluin1, aluin2;

  //for jr
  word_t jr_in, id_rdat1, ex_aluout;
  regbits_t id_rs, ex_rd;
  word_t mem_pc;
  opcode_t ex_instr;

  modport fu (
    input ex_rs, ex_rt, mem_rd, wb_rd, mem_aluout, wb_aluout,
          ex_rdat1, ex_rdat2, wb_pc, out_pc, mem_instr, wb_instr,
          temp_dmemload, id_rdat1, ex_aluout, id_rs, ex_rd,
          mem_pc, ex_instr,
    output aluin1, aluin2, jr_in
  );

  modport tb (
    input aluin1, aluin2, jr_in,
    output ex_rs, ex_rt, mem_rd, wb_rd, mem_aluout, wb_aluout,
           ex_rdat1, ex_rdat2, wb_pc, out_pc, mem_instr, wb_instr,
           temp_dmemload, id_rdat1, ex_aluout, id_rs, ex_rd,
           mem_pc, ex_instr
  );

endinterface

`endif
