`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module forwarding_unit (
  forwarding_unit_if.fu fuif
);

always_comb begin
  //aluin1
  fuif.aluin1 = fuif.ex_rdat1;
    if ((fuif.ex_rs == fuif.mem_rd) && (fuif.ex_rs != 0)) begin
      fuif.aluin1 = fuif.mem_aluout;
      if (fuif.mem_instr == LW) begin
        fuif.aluin1 = fuif.temp_dmemload;
      end
    end
    else if ((fuif.ex_rs == fuif.wb_rd) && (fuif.ex_rs != 0)) begin
      fuif.aluin1 = fuif.wb_aluout;
    end

  //aluin2
  fuif.aluin2 = fuif.ex_rdat2;
    if ((fuif.ex_rt == fuif.mem_rd) && (fuif.ex_rt != 0)) begin
      if (fuif.mem_instr == JAL) begin
        fuif.aluin2 = fuif.wb_pc + 4;
      end
      else begin
        fuif.aluin2 = fuif.mem_aluout;
        if (fuif.mem_instr == LW) begin
          fuif.aluin2 = fuif.temp_dmemload;
        end
      end
    end
    else if ((fuif.ex_rt == fuif.wb_rd) && (fuif.ex_rt != 0)) begin
      if (fuif.wb_instr == JAL) begin
        fuif.aluin2 = fuif.out_pc + 4;
      end
      else begin
        fuif.aluin2 = fuif.wb_aluout;
      end
    end

  //jr_in
  fuif.jr_in = fuif.id_rdat1;
  if (fuif.id_rs == fuif.ex_rd) begin
    fuif.jr_in = fuif.ex_aluout;
    if (fuif.ex_instr == JAL) begin
      fuif.jr_in = fuif.mem_pc + 4;
    end
  end
  else if (fuif.id_rs == fuif.mem_rd) begin
    fuif.jr_in = fuif.mem_aluout;
    if (fuif.mem_instr == JAL) begin
      fuif.jr_in = fuif.wb_pc + 4;
    end
  end
  else if (fuif.id_rs == fuif.wb_rd) begin
    fuif.jr_in = fuif.wb_aluout;
    if (fuif.wb_instr == JAL) begin
      fuif.jr_in = fuif.out_pc + 4;
    end
  end
end

endmodule
