/*
  Taylor Lipson
  tlipson@purdue.edu

  functional ALU file
*/

`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu (
  alu_if.alu aif //alu interface;
);

import cpu_types_pkg::*;

assign aif.Z = (aif.out == '0);
assign aif.N = aif.out[31];

always_comb begin
  aif.V = 0;
  casez (aif.aluop)
    ALU_SLL: begin
      aif.out = aif.a << aif.b; //shift port a left by # in b;
    end
    ALU_SRL: begin
      aif.out = aif.a >> aif.b;
    end
    ALU_ADD: begin
      aif.out = $signed(aif.a) + $signed(aif.b);
      if (aif.a[31]&aif.b[31]&~aif.out[31]) begin //if (neg + neg = pos)
        aif.V = 1;
      end
      else if (~aif.a[31]&~aif.b[31]&aif.out[31]) begin //if (pos + pos = neg)
        aif.V = 1;
      end
    end
    ALU_SUB: begin
      aif.out = $signed(aif.a) - $signed(aif.b);
      if (aif.b[31] == aif.out[31]) begin   //(pos - neg = neg), (neg - pos = pos)
        aif.V = 1;
      end
    end
    ALU_AND: begin
      aif.out = aif.a&aif.b;
    end
    ALU_OR: begin
      aif.out = aif.a|aif.b;
    end
    ALU_XOR: begin
      aif.out = aif.a^aif.b;
    end
    ALU_NOR: begin
      aif.out = ~(aif.a|aif.b);
    end
    ALU_SLT: begin
      if ($signed(aif.a) < $signed(aif.b)) begin
        aif.out = 1;
      end
      else begin
        aif.out = 0;
      end
    end
    ALU_SLTU: begin
      if (aif.a < aif.b) begin
        aif.out = 1;
      end
      else begin
        aif.out = 0;
      end
    end
  endcase
end

endmodule
