/*
  Taylor Lipson
  tlipson@purdue.edu

  control unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

//all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  //import types
  import cpu_types_pkg::*;

  word_t instr;
  aluop_t aluop;
  logic lui, halt, regdst, ext_type, alusrc, memtoreg, RWEN;
  logic imemREN, dmemWEN, dmemREN, jump, branch, igOV, pcen, link;
  logic shift, regtopc;

  //alu file ports
  modport cu (
    input instr,
    output aluop, lui, halt, regdst, ext_type, alusrc, memtoreg, RWEN, regtopc,
           imemREN, dmemWEN, dmemREN, jump, branch, igOV, pcen, link, shift
  );
  //alu tb ports
  modport tb (
    input aluop, lui, halt, regdst, ext_type, alusrc, memtoreg, RWEN, regtopc,
          imemREN, dmemWEN, dmemREN, jump, branch, igOV, pcen, link, shift,
    output instr
  );
endinterface

`endif
