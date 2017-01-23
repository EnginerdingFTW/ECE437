`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;
/*
  Summary: When a write or read is requested to memory, the signal needs to be
  held until the write/read has finished.
*/
module request_unity (
  input logic CLK, nRST,
  request_unit_if.ru ruif
);

logic n_dmemREN, n_dmemWEN;

assign ruif.dmemaddr = ruif.addr;

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    ruif.dmemREN <= 0;
    ruif.dmemWEN <= 0;
  end
  else begin
    ruif.dmemREN <= n_dmemREN;
    ruif.dmemWEN <= n_dmemWEN;
  end
end

always_comb begin
  if (ruif.dhit) begin  //VERY IMPORTANT -> de-assert the D-request.
    n_dmemREN = 0;
    n_dmemREN = 0;
  end
  else if (ruif.ihit) begin
    n_dmemREN = ruif.MemToReg;
    n_dmemWEN = ruif.WriteMem;
  end
  else begin
    n_dmemREN = ruif.dmemREN;
    n_dmemWEN = ruif.dmemWEN;
  end
end

endmodule
