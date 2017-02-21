`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module hazard_unit (
  hazard_unit_if huif
);


always_comb begin
  huif.id_flush = 0;
  huif.ex_flush = 0;
  huif.mem_flush = 0;
  huif.wb_flush = 0;
  huif.stall = 0;

  //Jumps, JR's, and JAL all take 1 cycle to calculate target, so flush the
  //if/id latch (what's going into id)
  if (huif.id_opcode == J || huif.id_opcode == JAL || (huif.id_opcode == RTYPE && huif.funct == JR)) begin
    huif.id_flush = 1;
  end
  //if branch not predicted correctly, flush out last 2 cycles
  if (huif.ex_opcode == BNE || huif.ex_opcode == BEQ) begin
    if (huif.branch_predicted == 0) begin
      huif.id_flush = 1;
      huif.ex_flush = 1;
    end
  end

  if (huif.mem_instr == LW) begin  //Reading After Write with Load Hazard
    if (huif.ex_rt == huif.mem_rd || huif.ex_rs == huif.mem_rd) begin
      if (huif.dhit == 0 && (huif.mem_dmemREN == 1 || huif.mem_dmemWEN == 1)) begin
        huif.stall = 1;     //stall for 1 cycle, then forward
        huif.mem_flush = 1;
      end
    end
  end
end

endmodule
