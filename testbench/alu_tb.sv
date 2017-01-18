/*
  Taylor Lipson
  tlipson@purdue.edu

  alu test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aif ();
  // test program
  test PROG (CLK, aif);
  // DUT
`ifndef MAPPED
  alu DUT(aif);
`else
  alu DUT(
    .\aif.aluop (aif.aluop),
    .\aif.b (aif.b),
    .\aif.a (aif.a),
    .\aif.Z (aif.Z),
    .\aif.V (aif.V),
    .\aif.N (aif.N),
    .\aif.out (aif.out)
  );
`endif

endmodule

program test
(
  input logic CLK,
  alu_if aif
);

integer k;
integer succ;

task check_v;
begin
  succ = 1;
  if (aif.V != 0) succ = 0;
end
endtask


initial begin
  @(negedge CLK);
  @(negedge CLK);
  aif.aluop = ALU_SLL;
  aif.a = 0;
  aif.b = 0;
  succ = 1;
  @(negedge CLK);

  //SLL
  aif.a = 1;
  aif.aluop = ALU_SLL;
  @(negedge CLK);
  for (k = 0; k < 32; k++) begin
    aif.b = k;
    @(negedge CLK);
    check_v();
    if (aif.out != aif.a << k) succ = 0;
    if (!succ) $display("FAIL - SLL: Testcase %d", k);
  end

  //SRL
  aif.aluop = ALU_SRL;
  aif.a = '1;
  for (k = 0; k < 32; k++) begin
    aif.b = k;
    @(negedge CLK);
    check_v();
    if (aif.out != aif.a >> k) succ = 0;
    if (!succ) $display("FAIL - SRL: Testcase %d", k);
  end

  //ADD
  aif.aluop = ALU_ADD;
  succ = 1;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    succ = 1;
    if ($signed(aif.a) + $signed(aif.b) != aif.out) succ = 0;
    if ((aif.a[31]&aif.b[31]&~aif.out[31]|~aif.a[31]&~aif.b[31]&aif.out[31])&~aif.V) succ = 0;
    if (!succ) $display("FAIL - ADD: %d + %d != %d", aif.a, aif.b, aif.out);
  end

  //SUB
  aif.aluop = ALU_SUB;
  succ = 1;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    succ = 1;
    if ($signed(aif.a) - $signed(aif.b) != aif.out) succ = 0;
    if (((aif.a[31]&~aif.b[31]&aif.out[31])|(~aif.a[31]&aif.b[31]&~aif.out[31]))&~aif.V) succ = 0;
    if (!succ) $display("FAIL - SUB: %d - %d != %d", aif.a, aif.b, aif.out);
  end

  //AND
  aif.aluop = ALU_AND;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if ((aif.a&aif.b)!=aif.out) succ = 0;
    if (!succ) $display("FAIL - AND: %d & %d != %d", aif.a, aif.b, aif.out);
  end

  //OR
  aif.aluop = ALU_OR;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if ((aif.a|aif.b)!=aif.out) succ = 0;
    if (!succ) $display("FAIL - OR: %d | %d != %d", aif.a, aif.b, aif.out);
  end

  //XOR
  aif.aluop = ALU_XOR;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if ((aif.a^aif.b)!=aif.out) succ = 0;
    if (!succ) $display("Fail - XOR: %d ^ %d != $d", aif.a, aif.b, aif.out);
  end

  //NOR
  aif.aluop = ALU_NOR;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if ((~(aif.a|aif.b)) != aif.out) succ = 0;
    if (!succ) $display("Fail - NOR: ~( %d | %d) != %d", aif.a, aif.b, aif.out);
  end

  //SLT
  aif.aluop = ALU_SLT;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if (($signed(aif.a) < $signed(aif.b)) != aif.out) succ = 0;
    if (!succ) $display("Fail - SLT: %d < %d != %d", aif.a, aif.b, aif.out);
  end

  //SLTU
  aif.aluop = ALU_SLTU;
  @(negedge CLK);
  for (k = 0; k < 50; k++) begin
    aif.a = $random;
    aif.b = $random;
    @(negedge CLK);
    check_v();
    if ((aif.a < aif.b) != aif.out) succ = 0;
    if (!succ) $display("Fail - SLTU: %d < %d != %d", aif.a, aif.b, aif.out);
  end

  //check Z and N flags
  aif.aluop = ALU_SUB;
  @(negedge CLK);
  aif.a = 0;
  aif.b = 0;
  @(negedge CLK);
  if (aif.Z != 1) $display("incorrect Z flag value - testcase 1");
  if (aif.N != 0) $display("incorrect N flag value - testcase 1");

  aif.b = 1;
  @(negedge CLK);
  if (aif.Z != 0) $display("incorrect Z flag value - testcase 2");
  if (aif.N != 1) $display("incorrect N flag value - testcase 2");

end
endprogram
