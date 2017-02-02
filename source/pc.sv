`include "pc_if.vh"
`include "cpu_types_pkg.vh"

module pc (
  input CLK, nRST,
  pc_if.pc pcif
);

import cpu_types_pkg::*;

word_t pc, n_pc, pc_4, pc_br, pc_j, pc_jr;

assign pcif.pcaddr = pc;

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    pc <= '0;
   end
  else begin
    if (pcif.pcen == 1) begin
      pc <= n_pc;
    end
    else begin
      pc <= pcif.pcaddr;
    end
  end
end

always_comb begin
  //logic for different n_pc's
  pc_4 = pc + 4;
  pc_j = {pc_4[31:28], (pcif.instruction[27:0]<<2)};
  pc_jr = pcif.alu_out;
  pc_br = pc_4 + ({{16{pcif.imm16[15]}}, pcif.imm16} << 2);

  //program counter mux
  if (pcif.jump == 1 && pcif.toreg == 0 && pcif.branch == 0) begin  //jump
    n_pc = pc_j;
  end
  else if (pcif.jump == 1 && pcif.toreg == 1 && pcif.branch == 0) begin //jump reg
    n_pc = pc_jr;
  end                           //BEQ                                     BNE
  else if (pcif.branch == 1 && ((pcif.equal == 1 && pcif.jump == 1) || (pcif.equal == 0 && pcif.jump == 0))) begin
    n_pc = pc_br;
  end
  else begin
    n_pc = pc_4;
  end
end

endmodule
