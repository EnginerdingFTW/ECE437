/*
  Taylor Lipson
  tlipson@purdue.edu

  Pipeline Register Interface
*/
`ifndef PIPELINE_REGISTERS_IF_VH
`define PIPELINE_REGISTERS_IF_VH

//all types
`include "cpu_types_pkg.vh"

interface pipeline_registers_if;
  //import types
  import cpu_types_pkg::*;

  //enable signals
  logic id_flush, ex_flush, mem_flush, wb_flush, stall, j_stall;
  logic ihit, dhit;

  //data signals
  word_t out_pc, id_pc, ex_pc, mem_pc, wb_pc; //pc's going into these stages
  word_t id_rdat1, id_rdat2, ex_rdat1, ex_rdat2;
  word_t ex_aluout, mem_aluout, wb_aluout;
  word_t mem_dmemload, temp_dmemload, wb_dmemload;
  word_t ex_dmemstore, mem_dmemstore;
  word_t id_extender_out, ex_extender_out;
  word_t if_imemload, id_imemload;
  opcode_t id_instr, ex_instr, mem_instr, wb_instr;
  funct_t id_funct, ex_funct;
  regbits_t id_rd, ex_rd, mem_rd, wb_rd;
  regbits_t id_rt, ex_rt, mem_rt, wb_rt;
  regbits_t id_rs, ex_rs, mem_rs, wb_rs;
  regbits_t id_shamt, ex_shamt;
  //for program counter
  logic [IMM_W-1:0] id_imm16, ex_imm16;
  logic id_jump, ex_jump, id_branch, ex_branch;

  //control signals
  aluop_t id_aluop;
  logic id_lui, id_halt, id_ext_type, id_alusrc, id_memtoreg, id_RWEN;
  logic id_imemREN, id_dmemREN, id_dmemWEN, id_link;
  logic id_shift, id_regtopc;

  aluop_t ex_aluop;
  logic ex_lui, ex_shift, ex_alusrc, ex_dmemREN, ex_dmemWEN, ex_halt, ex_memtoreg, ex_link, ex_RWEN;

  logic mem_lui, mem_dmemREN, mem_dmemWEN, mem_halt, mem_memtoreg, mem_link, mem_RWEN;

  logic wb_memtoreg, wb_halt, wb_link, wb_RWEN;

  //register pipeline file ports
  modport pr (
    input   id_pc, if_imemload, id_rdat1, id_rdat2, ex_aluout, mem_dmemload, ex_dmemstore,
            id_extender_out, id_instr, id_funct, id_rd, id_rs, id_rt, id_shamt,
            id_aluop, id_lui, id_halt, id_ext_type, id_alusrc, id_memtoreg,
            id_RWEN, id_imemREN, id_dmemREN, id_dmemWEN, id_jump, id_branch,
            id_link, id_shift, id_regtopc, id_flush, ex_flush, mem_flush,
            wb_flush, stall, ihit, dhit, id_imm16, j_stall,
    output  out_pc, ex_pc, mem_pc, wb_pc, id_imemload, ex_rdat1, ex_rdat2, mem_aluout,
            wb_aluout, temp_dmemload, wb_dmemload, mem_dmemstore, ex_extender_out,
            ex_instr, mem_instr, wb_instr, ex_funct, ex_rd, mem_rd,
            wb_rd, ex_rt, mem_rt, wb_rt, ex_rs, mem_rs, wb_rs, ex_shamt,
            ex_aluop, ex_lui, ex_shift, ex_alusrc, ex_dmemREN, ex_dmemWEN, ex_halt,
            ex_memtoreg, ex_link, ex_RWEN, mem_lui, mem_dmemREN, mem_dmemWEN,
            mem_halt, mem_memtoreg, mem_link, mem_RWEN, wb_memtoreg, wb_halt,
            wb_link, wb_RWEN, ex_imm16, ex_jump, ex_branch
  );
  //alu tb ports
  modport tb (
    input   out_pc, ex_pc, mem_pc, wb_pc, id_imemload, ex_rdat1, ex_rdat2, mem_aluout,
            wb_aluout, temp_dmemload, wb_dmemload, mem_dmemstore, ex_extender_out,
            ex_instr, mem_instr, wb_instr, ex_funct, ex_rd, mem_rd,
            wb_rd, ex_rt, mem_rt, wb_rt, ex_rs, mem_rs, wb_rs, ex_shamt,
            ex_aluop, ex_lui, ex_shift, ex_alusrc, ex_dmemREN, ex_dmemWEN, ex_halt,
            ex_memtoreg, ex_link, ex_RWEN, mem_lui, mem_dmemREN, mem_dmemWEN,
            mem_halt, mem_memtoreg, mem_link, mem_RWEN, wb_memtoreg, wb_halt,
            wb_link, wb_RWEN, ex_imm16, ex_jump, ex_branch,
    output  id_pc, if_imemload, id_rdat1, id_rdat2, ex_aluout, mem_dmemload, ex_dmemstore,
            id_extender_out, id_instr, id_funct, id_rd, id_rs, id_rt, id_shamt,
            id_aluop, id_lui, id_halt, id_ext_type, id_alusrc, id_memtoreg,
            id_RWEN, id_imemREN, id_dmemREN, id_dmemWEN, id_jump, id_branch,
            id_link, id_shift, id_regtopc, id_flush, ex_flush, mem_flush,
            wb_flush, stall, ihit, dhit, id_imm16, j_stall
  );
endinterface

`endif
