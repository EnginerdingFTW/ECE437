`ifndef PC_IF_VH
`define PC_IF_VH

`include "cpu_types_pkg.vh"

interface pc_if;
  import cpu_types_pkg::*

  word_t address, next_address;
  logic nPC_sel, freeze;

  modport pc (
    input next_address, nPC_sel, freeze,
    output address
  );

  modport tb (
    input address,
    output next_address, nPC_sel, freeze
  );

endinterface

`endif
