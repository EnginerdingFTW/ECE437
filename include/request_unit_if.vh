`ifndef REQUEST_UNIT_IF
`define REQUEST_UNIT_IF

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface request_unit;
  logic dmemREN, dmemWEN, MemToReg, WriteMem, dhit, ihit, addr, dmemaddr;

  modport ru (
    input MemToReg, WriteMem, dhit, ihit, addr,
    output dmemREN, dmemWEN, dmemaddr
  );

  modport tb (
    input dmemREN, dmemWEN,
    output MemToReg, WriteMem, dhit, ihit
  );
endinterface
