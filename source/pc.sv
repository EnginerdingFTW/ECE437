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
assign pcif.next_pc = n_pc;

always_comb begin
  //logic for different n_pc's
  pc_4 = pc + 4;
  pc_j = {pc_4[31:28], (pcif.id_instruction[27:0]<<2)};
  pc_jr = pcif.id_rdat1;
  pc_br = (pcif.ex_pc + 4) + ({{16{pcif.ex_imm16[15]}}, pcif.ex_imm16} << 2);

  //program counter mux
  if (pcif.ex_branch == 1 && ((pcif.ex_equal == 1 && pcif.ex_jump == 1) || (pcif.ex_equal == 0 && pcif.ex_jump == 0))) begin
    n_pc = pc_br;
  end
  else if (pcif.id_jump == 1 && pcif.id_toreg == 0 && pcif.id_branch == 0) begin  //jump
    n_pc = pc_j;      //if jump is in ID and a branch is in EX, problem? watch.
  end
  else if (pcif.id_jump == 1 && pcif.id_toreg == 1 && pcif.id_branch == 0) begin //jump reg
    n_pc = pc_jr;
  end
  else begin
    n_pc = pc_4;
  end
end

endmodule
