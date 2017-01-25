`include "pc_if.vh"
`include "cpu_types_pkg.vh"

module pc (
  input CLK, nRST,
  pc_if.pc pcif
);

import cpu_types_pkg::*;

word_t temp_address;

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    pcif.address <= '0;
  end
  else begin
    pcif.address <= temp_address;
  end
end

always_comb begin
  if (pcif.freeze == 1) begin
    temp_address = temp_address;
  end
  else if (pcif.nPC_sel == 1) begin
    temp_address = pcif.address + 4;
  end
  else begin
    temp_address = pcif.next_address;
  end
end

endmodule
