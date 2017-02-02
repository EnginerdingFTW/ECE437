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
  request_unit_if ruif();
  pc_if pcif();

  assign opcode = opcode_t'(dpif.imemload[31:26]);
  assign rs = dpif.imemload[25:21];
  assign rt = dpif.imemload[20:16];
  assign rd = dpif.imemload[15:11];
  assign shamt = dpif.imemload[10:6]; //might not need
  assign funct = funct_t'(dpif.imemload[5:0]);  //might not need
  assign imm16 = dpif.imemload[15:0];
  assign dest = ((cuif.link == 1) ? 5'h1F : ((cuif.regdst == 1) ? rd : rt));


  //Functional Blocks
  register_file REGS (CLK, nRST, rfif);
  alu ALU (aluif);
  control_unit CONTROL (cuif);
  request_unit REQUEST (CLK, nRST, ruif);
  pc PRG_CNTR (CLK, nRST, pcif);

  //fetch
    //program counter interface
  assign pcif.alu_out = rfif.rdat1;
  assign pcif.instruction = dpif.imemload;  //loaded from pc
  assign pcif.imm16 = imm16;
  assign pcif.branch = cuif.branch;
  assign pcif.jump = cuif.jump;
  assign pcif.equal = aluif.Z;
  assign pcif.toreg = cuif.regtopc;
  assign pcif.pcen = cuif.pcen & dpif.ihit & ~dpif.dhit;

  //decode
    //control unit interface
  assign cuif.instr = dpif.imemload;
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      halt <= 0;
    end
    else if (cuif.halt == 1) begin
      halt <= cuif.halt;
    end
  end

    //register file interface
  assign rfif.WEN = ((cuif.RWEN && opcode != LW && dpif.ihit) || (opcode == LW && dpif.dhit == 1));//cur_RWEN;//cuif.RWEN
  assign rfif.wsel = dest;
  assign rfif.rsel1 = rs;
  assign rfif.rsel2 = rt;
  assign rfif.wdat = wdat;

  //execute
    //alu interface
  assign aluif.a = (cuif.link == 1) ? '0 : rfif.rdat1;
  assign aluif.b = rdat2temp;
  assign aluif.aluop = cuif.aluop;

    //rdat2 mux's
  assign extender_out = (cuif.lui == 1) ? {imm16, 16'h0000} : ((cuif.ext_type == 1) ? {16'h0000, imm16} : {{16{imm16[15]}}, imm16});
  assign rdat2temp = ((cuif.shift == 1) ? {27'h0000000, shamt} : ((cuif.alusrc == 1) ? extender_out : rfif.rdat2));

  //memory
    //request unit interface
  assign ruif.MemToReg = cuif.memtoreg; //dREN
  assign ruif.WriteMem = cuif.dmemWEN;  //dWEN
  assign ruif.dhit = dpif.dhit;
  assign ruif.ihit = dpif.ihit;
  assign ruif.addr = aluif.out;

    //datapath interface
  assign dpif.halt = halt;
  assign dpif.imemREN = cuif.imemREN;
  assign dpif.imemaddr = pcif.pcaddr;
  assign dpif.dmemREN = ruif.dmemREN;
  assign dpif.dmemWEN = ruif.dmemWEN;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluif.out;
      //datomic?

  //writeback
    //mux's
  assign wdat = ((cuif.link == 1) ? pcif.pcaddr + 4 : ((cuif.memtoreg == 1) ? dpif.dmemload : aluif.out));
endmodule
