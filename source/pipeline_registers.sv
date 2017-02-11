`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module pipeline_registers (
  input CLK, nRST,
  pipeline_registers_if.pr prif
);

word_t temp_dmemload;

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    prif.out_pc <= '0;
    prif.id_imemload <= '0;
    temp_dmemload <= '0;
    prif.ex_pc <= '0;
    prif.mem_pc <= '0;
    prif.wb_pc <= '0;
    prif.ex_rdat1 <= '0;
    prif.ex_rdat2 <= '0;
    prif.mem_aluout <= '0;
    prif.wb_aluout <= '0;
    prif.wb_dmemload <= '0;
    prif.mem_dmemstore <= '0;
    prif.ex_extender_out <= '0;
    prif.ex_instr <= RTYPE;
    prif.mem_instr <= RTYPE;
    prif.wb_instr <= RTYPE;
    prif.ex_funct <= SLL;
    prif.ex_rd <= '0;
    prif.mem_rd <= '0;
    prif.wb_rd <= '0;
    prif.ex_rt <= '0;
    prif.mem_rt <= '0;
    prif.wb_rt <= '0;
    prif.ex_rs <= '0;
    prif.mem_rs <= '0;
    prif.wb_rs <= '0;
    prif.ex_shamt <= '0;
    prif.ex_aluop <= ALU_SLL;
    prif.ex_lui <= '0;
    prif.mem_lui <= '0;
    prif.ex_alusrc <= '0;
    prif.ex_dmemREN <= '0;
    prif.mem_dmemREN <= '0;
    prif.ex_dmemWEN <= '0;
    prif.mem_dmemWEN <= '0;
    prif.ex_halt <= '0;
    prif.mem_halt <= '0;
    prif.wb_halt <= '0;
    prif.ex_memtoreg <= '0;
    prif.mem_memtoreg <= '0;
    prif.wb_memtoreg <= '0;
    prif.ex_link <= '0;
    prif.mem_link <= '0;
    prif.ex_shift <= '0;
    prif.wb_link <= '0;
    prif.ex_RWEN <= '0;
    prif.mem_RWEN <= '0;
    prif.wb_RWEN <= '0;
    prif.ex_imm16 <= '0;
    prif.ex_jump <= '0;
    prif.ex_branch <= '0;
  end
  else if (prif.ihit == 1) begin
    //if -> id
    if (prif.id_flush == 1) begin  //stall if -> id
      prif.id_imemload <= '0;
    end
    else begin
if (prif.stall == 0) begin
      prif.id_imemload <= prif.if_imemload;
end
    end
    //id -> ex
    if (prif.ex_flush == 1) begin
      prif.ex_pc <= '0;
      prif.ex_rdat1 <= '0;
      prif.ex_rdat2 <= '0;
      prif.ex_extender_out <= '0;
      prif.ex_instr <= RTYPE;
      prif.ex_funct <= SLL;
      prif.ex_rd <= '0;
      prif.ex_rt <= '0;
      prif.ex_rs <= '0;
      prif.ex_shamt <= '0;
      prif.ex_aluop <= ALU_SLL;
      prif.ex_lui <= '0;
      prif.ex_shift <= '0;
      prif.ex_alusrc <= '0;
      prif.ex_dmemREN <= '0;
      prif.ex_dmemWEN <= '0;
      prif.ex_halt <= '0;
      prif.ex_memtoreg <= '0;
      prif.ex_link <= '0;
      prif.ex_RWEN <= '0;
      prif.ex_imm16 <= '0;
      prif.ex_jump <= '0;
      prif.ex_branch <= '0;
    end
    else begin
if (prif.stall == 0) begin
      prif.ex_pc <= prif.id_pc;
      prif.ex_rdat1 <= prif.id_rdat1;
      prif.ex_rdat2 <= prif.id_rdat2;
      prif.ex_extender_out <= prif.id_extender_out;
      prif.ex_instr <= prif.id_instr;
      prif.ex_funct <= prif.id_funct;
      prif.ex_rd <= prif.id_rd;
      prif.ex_rt <= prif.id_rt;
      prif.ex_rs <= prif.id_rs;
      prif.ex_shamt <= prif.id_shamt;
      prif.ex_aluop <= prif.id_aluop;
      prif.ex_lui <= prif.id_lui;
      prif.ex_shift <= prif.id_shift;
      prif.ex_alusrc <= prif.id_alusrc;
      prif.ex_dmemREN <= prif.id_dmemREN;
      prif.ex_dmemWEN <= prif.id_dmemWEN;
      prif.ex_halt <= prif.id_halt;
      prif.ex_memtoreg <= prif.id_memtoreg;
      prif.ex_link <= prif.id_link;
      prif.ex_RWEN <= prif.id_RWEN;
      prif.ex_imm16 <= prif.id_imm16;
      prif.ex_jump <= prif.id_jump;
      prif.ex_branch <= prif.id_branch;
end
    end
    //ex -> mem
    if (prif.mem_flush == 1) begin
      prif.mem_pc <= '0;
      prif.mem_aluout <= '0;
      prif.mem_dmemstore <= '0;
      prif.mem_instr <= RTYPE;
      prif.mem_rd <= '0;
      prif.mem_rs <= '0;
      prif.mem_rt <= '0;
      prif.mem_lui <= '0;
      prif.mem_dmemREN <= '0;
      prif.mem_dmemWEN <= '0;
      prif.mem_halt <= '0;
      prif.mem_memtoreg <= '0;
      prif.mem_link <= '0;
      prif.mem_RWEN <= '0;
    end
    else begin
if (prif.stall == 0) begin
      prif.mem_pc <= prif.ex_pc;
      prif.mem_aluout <= prif.ex_aluout;
      prif.mem_dmemstore <= prif.ex_dmemstore;
      prif.mem_instr <= prif.ex_instr;
      prif.mem_rd <= prif.ex_rd;
      prif.mem_rs <= prif.ex_rs;
      prif.mem_rt <= prif.ex_rt;
      prif.mem_lui <= prif.ex_lui;
      prif.mem_dmemREN <= prif.ex_dmemREN;
      prif.mem_dmemWEN <= prif.ex_dmemWEN;
      prif.mem_halt <= prif.ex_halt;
      prif.mem_memtoreg <= prif.ex_memtoreg;
      prif.mem_link <= prif.ex_link;
      prif.mem_RWEN <= prif.ex_RWEN;
end
    end
      //mem/wb is never stalled because we are waiting on memory.
    //mem -> wb
    if (prif.wb_flush == 1) begin
      prif.wb_pc <= '0;
      prif.wb_aluout <= '0;
      prif.wb_dmemload <= '0;
      prif.wb_instr <= RTYPE;
      prif.wb_rd <= '0;
      prif.wb_rs <= '0;
      prif.wb_rt <= '0;
      prif.wb_memtoreg <= '0;
      prif.wb_halt <= '0;
      prif.wb_link <= '0;
      prif.wb_RWEN <= '0;
    end
    else begin
      prif.wb_pc <= prif.mem_pc;
      prif.wb_aluout <= prif.mem_aluout;
      prif.wb_dmemload <= temp_dmemload;
      prif.wb_instr <= prif.mem_instr;
      prif.wb_rd <= prif.mem_rd;
      prif.wb_rs <= prif.mem_rs;
      prif.wb_rt <= prif.mem_rt;
      prif.wb_memtoreg <= prif.mem_memtoreg;
      prif.wb_halt <= prif.mem_halt;
      prif.wb_link <= prif.mem_link;
      prif.wb_RWEN <= prif.mem_RWEN;
    end
      prif.out_pc <= prif.wb_pc;
  end
  else if (prif.dhit == 1) begin
    prif.mem_dmemREN <= 0;
    prif.mem_dmemWEN <= 0;
    temp_dmemload <= prif.mem_dmemload;
    prif.wb_pc <= prif.mem_pc;
    prif.wb_aluout <= prif.mem_aluout;
    prif.wb_dmemload <= temp_dmemload;
    prif.wb_instr <= prif.mem_instr;
    prif.wb_rd <= prif.mem_rd;
    prif.wb_rs <= prif.mem_rs;
    prif.wb_rt <= prif.mem_rt;
    prif.wb_memtoreg <= prif.mem_memtoreg;
    prif.wb_halt <= prif.mem_halt;
    prif.wb_link <= prif.mem_link;
    prif.wb_RWEN <= prif.mem_RWEN;
  end

end





endmodule;
