`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0 ();
  caches_if cif1 ();
  cache_control_if ccif (cif0, cif1);
  cpu_ram_if ramif ();


  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;


  // test program
  test PROG (CLK, nRST, ccif);
  // DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
  ram RAM_MOD(CLK, nRST, ramif);
`else
  memory_control DUT(
//  CLK, nRST, ccif
/*
  CLK,
  nRST,
  ccif.ccsnoopaddr,
  ccif.ccinv,
  ccif.ccwait,
  ccif.ramREN,
  ccif.ramWEN,
  ccif.ramaddr,
  ccif.ramstore,
  ccif.dload,
  ccif.iload,
  ccif.dwait,
  ccif.iwait,
  ccif.cctrans,
  ccif.ccwrite,
  ccif.ramstate,
  ccif.ramload,
  ccif.daddr,
  ccif.iaddr,
  ccif.dstore,
  ccif.dWEN,
  ccif.dREN,
  ccif.iREN
*/

    .\ccif.cctrans(ccif.cctrans),
    .\ccif.ccwrite(ccif.ccwrite),
    .\ccif.ramstate(ccif.ramstate),
    .\ccif.ramload(ccif.ramload),
    .\ccif.daddr(ccif.daddr),
    .\ccif.iaddr(ccif.iaddr),
    .\ccif.dstore(ccif.dstore),
    .\ccif.dWEN(ccif.dWEN),
    .\ccif.dREN(ccif.dREN),
    .\ccif.iREN(ccif.iREN),
    .\ccif.ccsnoopaddr(ccif.ccsnoopaddr),
    .\ccif.ccinv(ccif.ccinv),
    .\ccif.ccwait(ccif.ccwait),
    .\ccif.ramREN(ccif.ramREN),
    .\ccif.ramWEN(ccif.ramWEN),
    .\ccif.ramaddr(ccif.ramaddr),
    .\ccif.ramstore(ccif.ramstore),
    .\ccif.dload(ccif.dload),
    .\ccif.iload(ccif.iload),
    .\ccif.dwait(ccif.dwait),
    .\ccif.iwait(ccif.iwait),
    .\nRST (nRST),
    .\CLK (CLK)

  );
  ram RAM_MOD(
//  CLK, nRST, ramif
/*
    CLK,
    nRST,
    ramif.ramload,
    ramif.ramstate,
    ramif.ramWEN,
    ramif.ramREN,
    ramif.ramstore,
    ramif.ramaddr
*/

    .\ramif.ramload(ramif.ramload),
    .\ramif.ramstate(ramif.ramstate),
    .\ramif.ramWEN(ramif.ramWEN),
    .\ramif.ramREN(ramif.ramREN),
    .\ramif.ramstore(ramif.ramstore),
    .\ramif.ramaddr(ramif.ramaddr),
    .\nRST (nRST),
    .\CLK (CLK)

  );
`endif

endmodule

program test
(
  input logic CLK,
  output logic nRST,
  cache_control_if ccif
);
  integer print;
  integer k;
  integer i;

  task memory_wait;
  begin
      //both iwait and dwait are 1 until the memory is ready.
    i = 0;
    //$display("before: cif0.iwait = %d   cif0.dwait = %d", cif0.iwait, cif0.dwait);
    while (cif0.iwait && cif0.dwait) begin
      @(negedge CLK);
      //$display("cif0.iwait = %d   cif0.dwait = %d", cif0.iwait, cif0.dwait);
      i = i + 1;
      if (i > 10) break;
    end
    //either i or d request complete
    if (print == 1) begin
      if (cif0.iwait == 0) begin
        $display("ADDRESS[%h] = %h - iload", cif0.iaddr, cif0.iload);
      end else begin
        if (cif0.dREN == 1) begin
          $display("ADDRESS[%h] = %h - dload", cif0.daddr, cif0.dload);
        end
        else begin
          $display("ADDRESS[%h] = %h - dstore", cif0.daddr, cif0.dstore);
        end
      end
    end
  end
  endtask

  task read_memory;
  input integer address;
  begin
    cif0.iaddr = address;
    @(negedge CLK);
    memory_wait();
    @(negedge CLK);
  end
  endtask;

  task automatic dump_memory();
    string filename = "memcpu_dump.hex";
    int memfd;

    cif0.iaddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;
    cif0.iREN = 1;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

     // cif0.iaddr = i << 2;
      read_memory(i << 2);
      if (cif0.iload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.iload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.iload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif0.iREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask


  initial begin
    @(negedge CLK);
    nRST = 1;
    @(negedge CLK);
    nRST = 0;
    @(negedge CLK);
    nRST = 1;
    print = 1;
    cif0.iaddr = 0;
    cif0.daddr = 0;
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.iREN = 1;
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);

    $display("reading 10 instructions from address 0x'0");
    for (k = 0; k < 10; k++) begin
      read_memory(k*4);
    end
    @(negedge CLK);

    $display("writing 10 words from address 0x00A0");
    cif0.dREN = 0;
    for (k = 0; k < 10; k++ ) begin
      cif0.dWEN = 1;
      cif0.daddr = k*4 + 16'h00A0;
      cif0.dstore = k + 16'hAAA0;
      @(negedge CLK);
      memory_wait();
      @(negedge CLK);
      @(negedge CLK);
      cif0.dWEN = 0;
      @(negedge CLK);
    end
    @(negedge CLK);

    cif0.dWEN = 0;
    $display("load the values that were written to memory back:");
    for (k = 0; k < 10; k ++) begin
      cif0.dREN = 1;
      cif0.daddr = k*4 + 16'h00A0;
      @(negedge CLK);
      memory_wait();
      @(negedge CLK);
    end
    print = 0;
    dump_memory();
  end

endprogram

