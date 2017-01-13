/*
  Taylor Lipson
  tlipson@purdue.edu

  alu interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

//all types
`include "cpu_types_pkg.vh"

interface alu_if;
  //import types
  import cpu_types_pkg::*;

  logic Z, N, V;  //zero, negative, overflow
  aluop_t aluop;  //alu opcode
  word_t a, b, out; //a b and out ports

  //alu file ports
  modport alu (
    input a, b, aluop,
    output out, N, V, Z
  );
  //alu tb ports
  modport tb (
    input out, N, V, Z,
    output a, b, aluop
  );
endinterface

`endif
