`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  control_unit_if cuif ();

  // test program
  test PROG (CLK, nRST, cuif);
  // DUT
`ifndef MAPPED
  control_unit DUT(cuif);
`else
  control_unit DUT(cuif);
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  control_unit_if cuif
);
  integer print;
  integer k;

  opcode_t opcode;
  funct_t funct;
  logic [4:0] rs, rt, rd, shamt;

  assign cuif.instr = {opcode, rs, rt, rd, shamt, funct};

  task wait_cycles;
  input integer cycles;
  begin
    for (k = 0; k < cycles; k ++) begin
      @(negedge CLK);
    end
  end
  endtask

  initial begin
    @(negedge CLK);
    nRST = 1;
    @(negedge CLK);
    nRST = 0;
    @(negedge CLK);
    nRST = 1;
    print = 1;
    opcode = RTYPE;
    rs = 0;
    rt = 0;
    rd = 0;
    shamt = 0;
    funct = SLL;
    wait_cycles(3);
    funct = SRL;
    wait_cycles(3);
    funct = JR;
    wait_cycles(3);
    funct = ADD;
    wait_cycles(3);
    funct = ADDU;
    wait_cycles(3);
    funct = SUB;
    wait_cycles(3);
    funct = SUBU;
    wait_cycles(3);
    funct = AND;
    wait_cycles(3);
    funct = OR;
    wait_cycles(3);
    funct = XOR;
    wait_cycles(3);
    funct = NOR;
    wait_cycles(3);
    funct = SLT;
    wait_cycles(3);
    funct = SLTU;
    wait_cycles(3);
    funct = SLL;

    opcode = J;
    wait_cycles(3);
    opcode = JAL;
    wait_cycles(3);
    opcode = BEQ;
    wait_cycles(3);
    opcode = BNE;
    wait_cycles(3);
    opcode = ADDI;
    wait_cycles(3);
    opcode = ADDIU;
    wait_cycles(3);
    opcode = SLTI;
    wait_cycles(3);
    opcode = SLTIU;
    wait_cycles(3);
    opcode = ANDI;
    wait_cycles(3);
    opcode = ORI;
    wait_cycles(3);
    opcode = XORI;
    wait_cycles(3);
    opcode = LUI;
    wait_cycles(3);
    opcode = LW;
    wait_cycles(3);
    opcode = SW;
    wait_cycles(3);
    opcode = LL;
    wait_cycles(3);
    opcode = SC;
    wait_cycles(3);
    opcode = HALT;
    wait_cycles(3);

  end


endprogram

