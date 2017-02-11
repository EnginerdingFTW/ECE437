`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module control_unit (
  control_unit_if cuif
);

always_comb begin
  cuif.aluop = ALU_ADD;
  cuif.lui = 0; //1 means LUI instr
  cuif.halt = 0;
  cuif.regdst = 0;
  cuif.ext_type = 0;  //1 means 0 extend, not sign
  cuif.alusrc = 0;
  cuif.memtoreg = 0;
  cuif.RWEN = 0;
  cuif.dmemWEN = 0;
  cuif.dmemREN = 0;
  cuif.jump = 0;
  cuif.branch = 0;
  cuif.igOV = 0;
  cuif.link = 0;
  cuif.shift = 0;
  cuif.regtopc = 0;

  cuif.imemREN = 1;
  cuif.pcen = 1;

  case(cuif.instr[31:26])
    RTYPE: begin
      cuif.regdst = 1;
      cuif.RWEN = 1;

      casez(cuif.instr[5:0])
        SLL: begin
          cuif.aluop = ALU_SLL;
          cuif.shift = 1;
        end
        SRL: begin
          cuif.aluop = ALU_SRL;
          cuif.shift = 1;
        end
        JR: begin
          cuif.jump = 1;
          cuif.regtopc = 1;
        end
        ADD: cuif.aluop = ALU_ADD;
        ADDU: begin
          cuif.aluop = ALU_ADD;
          cuif.igOV = 1;
        end
        SUB: cuif.aluop = ALU_SUB;
        SUBU: begin
          cuif.aluop = ALU_SUB;
          cuif.igOV = 1;
        end
        AND: cuif.aluop = ALU_AND;
        OR: cuif.aluop = ALU_OR;
        XOR: cuif.aluop = ALU_XOR;
        NOR: cuif.aluop = ALU_NOR;
        SLT: cuif.aluop = ALU_SLT;
        SLTU: cuif.aluop = ALU_SLTU;
      endcase
    end
    J: begin
      cuif.jump = 1;
    end
    JAL: begin
      cuif.jump = 1;
      cuif.link = 1;
      cuif.RWEN = 1;
    end
    default: begin
    cuif.alusrc = 1;
    cuif.RWEN = 1;
    cuif.regdst = 0;
    casez(cuif.instr[31:26])
      BEQ: begin
        cuif.alusrc = 0;
        cuif.RWEN = 0;
        cuif.branch = 1;
        cuif.jump = 1;  //binary combo for choosing which branch, jumps ignored
        cuif.aluop = ALU_SUB;
      end
      BNE: begin
        cuif.alusrc = 0;
        cuif.RWEN = 0;
        cuif.branch = 1;
        cuif.jump = 0;
        cuif.aluop = ALU_SUB;
      end
      ADDI: cuif.aluop = ALU_ADD; //ext_type and lui = 0
      ADDIU: begin
        cuif.aluop = ALU_ADD;
        cuif.igOV = 1;
      end
      SLTI: cuif.aluop = ALU_SLT;
      SLTIU: cuif.aluop = ALU_SLTU;
      ANDI: begin
        cuif.aluop = ALU_AND;
        cuif.ext_type = 1;
      end
      ORI: begin
        cuif.aluop = ALU_OR;
        cuif.ext_type = 1;
      end
      XORI: begin
        cuif.aluop = ALU_XOR;
        cuif.ext_type = 1;
      end
      LUI: begin
        cuif.aluop = ALU_ADD; //make sure adding imm with 0.
        cuif.lui = 1;
      end
      LW: begin
        cuif.aluop = ALU_ADD;
        cuif.memtoreg = 1;
        cuif.dmemREN = 1;
      end
      LBU: begin
//?load byte unsigned
      end
      LHU: begin
//?load halfword unsigned
      end
      SB: begin
//?store byte
      end
      SH: begin
//?store half word
      end
      SW: begin
        cuif.RWEN = 0;
        cuif.aluop = ALU_ADD;
        cuif.dmemWEN = 1;
      end
      LL: begin
//?Load Link
        cuif.aluop = ALU_ADD;
        cuif.dmemREN = 1;
        cuif.memtoreg = 1;
      end
      SC: begin
//?Store Conditional
      end
      HALT: begin
        cuif.RWEN = 0;
        cuif.halt = 1;
        cuif.pcen = 0;
      end
    endcase
    end
  endcase
end


endmodule
