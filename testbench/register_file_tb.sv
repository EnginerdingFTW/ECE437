/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  register_file_if.rf rfif
);

integer k;
integer d;
integer t1;
integer t2;

initial begin
  @(negedge CLK);
  nRST = 1;
  @(negedge CLK);
  nRST = 0;
  @(negedge CLK);
  nRST = 1;
  @(negedge CLK);
  @(negedge CLK);
  rfif.rsel1 = 0;
  rfif.rsel2 = 0;
  rfif.wdat = 10;
  rfif.wsel = 0;
  rfif.WEN = 1;

  d = 0;
  for (k = 0; k < 32; k++) begin
    @(negedge CLK);
    d = d + 1;
    rfif.wdat = d;
    rfif.wsel = d;
  end

  d = 0;
  for (k = 0; k < 32; k++) begin
    t1 = rfif.rdat1;
    t2 = rfif.rdat2;
    @(negedge CLK);
    d = d + 1;
    rfif.rsel1 = d;
    rfif.rsel2 = d;
  end

end
endprogram
