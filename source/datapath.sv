/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

`include "datapath_cache_if.vh"
`include "pc_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "pipeline_registers_if.vh"
`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  //define variables
  logic [IMM_W-1:0] imm16;
  logic cur_RWEN, halt;
  word_t wdat, rdat2temp, extender_out, last_pc;
  regbits_t rd, rt, rs, dest, shamt;
  funct_t funct;
  opcode_t opcode;


  //interfaces
  register_file_if rfif();
  alu_if aluif();
  control_unit_if cuif();
//  request_unit_if ruif();
  pc_if pcif();
  pipeline_registers_if prif();
  hazard_unit_if huif();
  forwarding_unit_if fuif();

  assign opcode = opcode_t'(prif.id_imemload[31:26]);
  assign rs = prif.id_imemload[25:21];
  assign rt = prif.id_imemload[20:16];
  assign rd = (cuif.link == 1) ? 5'h1F : prif.id_imemload[15:11];
  assign shamt = prif.id_imemload[10:6]; //might not need
  assign funct = funct_t'(prif.id_imemload[5:0]);  //might not need
  assign imm16 = prif.id_imemload[15:0];
  assign dest = ((cuif.link == 1) ? 5'h1F : ((cuif.regdst == 1) ? rd : rt));


  //Functional Blocks
  register_file REGS (CLK, nRST, rfif);
  alu ALU (aluif);
  control_unit CONTROL (cuif);
//  request_unit REQUEST (CLK, nRST, ruif);
  pc PRG_CNTR (CLK, nRST, pcif);
  pipeline_registers PIPLINE (CLK, nRST, prif);
  hazard_unit HAZARD (huif);
  forwarding_unit FORWARD (fuif);

  //hazard unit
  assign huif.id_opcode = opcode;
  assign huif.ex_opcode = prif.ex_instr;
  assign huif.funct = funct;
  assign huif.branch_predicted = ~((aluif.Z&prif.ex_jump)|(~aluif.Z&~prif.ex_jump));
  assign huif.ex_rs = prif.ex_rs;
  assign huif.ex_rt = prif.ex_rt;
  assign huif.mem_rd = prif.mem_rd;
  assign huif.mem_instr = prif.mem_instr;
  assign huif.dhit = dpif.dhit;
  assign huif.mem_dmemREN = prif.mem_dmemREN;
  assign huif.mem_dmemWEN = prif.mem_dmemWEN;

  //fetch
    //program counter interface
  assign pcif.ex_pc = prif.mem_pc;  //the pc associated with branch is 1 ahead
  assign pcif.id_rdat1 = fuif.jr_in; //rfif.rdat1
  assign pcif.ex_rdat1 = fuif.aluin1;//prif.ex_rdat1;
  assign pcif.id_instruction = prif.id_imemload; //this might be cycle early
  assign pcif.id_imm16 = imm16;
  assign pcif.ex_imm16 = prif.ex_imm16;
  assign pcif.id_jump = cuif.jump;
  assign pcif.id_branch = cuif.branch;
  assign pcif.id_toreg = cuif.regtopc;
  assign pcif.ex_equal = aluif.Z;
  assign pcif.ex_branch = prif.ex_branch;
  assign pcif.ex_jump = prif.ex_jump;
  assign pcif.pcen = dpif.ihit && ~huif.stall;

// pipeline inputs
  assign prif.ihit = dpif.ihit;
  assign prif.dhit = dpif.dhit;
 // assign prif.if_pc = pcif.pcaddr; //is this needed?
  assign prif.id_pc = pcif.pcaddr;
  assign prif.if_imemload = dpif.imemload;
  assign prif.id_rdat1 = rfif.rdat1;
  assign prif.id_rdat2 = rfif.rdat2;
  assign prif.ex_aluout = aluif.out;
  assign prif.mem_dmemload = dpif.dmemload;
  assign prif.ex_dmemstore = fuif.aluin2;//prif.ex_rdat2;
  assign prif.id_extender_out = extender_out;
  assign prif.id_instr = opcode;
  assign prif.id_funct = funct;
  assign prif.id_rd = dest; //the rd slot, the the rd variable up above
  assign prif.id_rs = rs;
  assign prif.id_rt = rt;
  assign prif.id_shamt = shamt;
  assign prif.id_aluop = cuif.aluop;
  assign prif.id_lui = cuif.lui;
  assign prif.id_halt = halt;
  assign prif.id_ext_type = cuif.ext_type;
  assign prif.id_alusrc = cuif.alusrc;
  assign prif.id_memtoreg = cuif.memtoreg;
  assign prif.id_RWEN = cuif.RWEN;
  assign prif.id_imemREN = cuif.imemREN;
  assign prif.id_dmemREN = cuif.dmemREN;
  assign prif.id_dmemWEN = cuif.dmemWEN;
  assign prif.id_jump = cuif.jump;
  assign prif.id_branch = cuif.branch;
  assign prif.id_link = cuif.link;
  assign prif.id_shift = cuif.shift;
  assign prif.id_regtopc = cuif.regtopc;
  assign prif.id_flush = huif.id_flush;
  assign prif.ex_flush = huif.ex_flush;
  assign prif.mem_flush = huif.mem_flush;
  assign prif.wb_flush = huif.wb_flush;
  assign prif.stall = huif.stall;
  assign prif.id_imm16 = imm16;
  assign prif.j_stall = 0; //huif.j_stall

  //decode
    //control unit interface
  assign cuif.instr = prif.id_imemload;
  always_ff @ (posedge CLK, negedge nRST) begin
    if ((nRST == 0)) begin
      halt <= 0;
    end
    else if (huif.id_flush == 1) begin
      halt <= 0;
    end
    else if (huif.ex_flush == 1) begin
      halt <= 0;
    end
    else begin
      if (cuif.halt == 1) begin
        halt <= cuif.halt;
      end
    end
  end

    //register file interface
  assign rfif.WEN = (prif.wb_RWEN);
  assign rfif.wsel = prif.wb_rd;
  assign rfif.rsel1 = rs;
  assign rfif.rsel2 = rt;
  assign rfif.wdat = wdat;

  //execute
    //forwarding unit
  assign fuif.ex_rs = prif.ex_rs;
  assign fuif.ex_rt = prif.ex_rt;
  assign fuif.mem_rd = prif.mem_rd;
  assign fuif.wb_rd = prif.wb_rd;
  assign fuif.mem_aluout = prif.mem_aluout;
  assign fuif.wb_aluout = wdat;//prif.wb_aluout;
  assign fuif.ex_rdat1 = prif.ex_rdat1;
  assign fuif.ex_rdat2 = prif.ex_rdat2;
  assign fuif.wb_pc = prif.wb_pc;
  assign fuif.out_pc = prif.out_pc;
  assign fuif.mem_instr = prif.mem_instr;
  assign fuif.wb_instr = prif.wb_instr;
  assign fuif.temp_dmemload = prif.temp_dmemload;
  assign fuif.id_rdat1 = rfif.rdat1;
  assign fuif.ex_aluout = aluif.out;
  assign fuif.id_rs = rs;
  assign fuif.ex_rd = prif.ex_rd;
  assign fuif.mem_pc = prif.mem_pc;
  assign fuif.ex_instr = prif.ex_instr;

    //alu interface
  assign aluif.a = (prif.ex_link == 1) ? '0 : fuif.aluin1; //was prif.ex_rdat1
  assign aluif.b = rdat2temp;
  assign aluif.aluop = prif.ex_aluop;

    //rdat2 mux's
        //done in decode
  assign extender_out = (cuif.lui == 1) ? {imm16, 16'h0000} : ((cuif.ext_type == 1) ? {16'h0000, imm16} : {{16{imm16[15]}}, imm16});
        //done in execute
  assign rdat2temp = ((prif.ex_shift == 1) ? {27'h0000000, prif.ex_shamt} : ((prif.ex_alusrc == 1) ? prif.ex_extender_out : fuif.aluin2)); //ex_rdat2

  //memory
    //datapath interface
  assign dpif.halt = prif.wb_halt;
  assign dpif.imemREN = cuif.imemREN;
  assign dpif.imemaddr = pcif.pcaddr; //fetch addres
  assign dpif.dmemREN = prif.mem_dmemREN; //in mem pipe
  assign dpif.dmemWEN = prif.mem_dmemWEN && ~prif.mem_halt; //in mem pipe
  assign dpif.dmemstore = prif.mem_dmemstore; //in mem pipe
  assign dpif.dmemaddr = prif.mem_aluout;   //in mem pipe
      //datomic?

  //writeback
    //mux's
  assign wdat = ((prif.wb_link == 1) ? prif.out_pc + 4  : ((prif.wb_memtoreg == 1) ? prif.wb_dmemload : prif.wb_aluout));
endmodule
