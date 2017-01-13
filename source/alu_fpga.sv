/*
  Eric Villasenor
  evillase@gmail.com

  register file fpga wrapper
*/

// interface
`include "register_file_if.vh"

module alu_fpga (
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR,
  output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);

  // interface
  alu_if aif();
  // rf
  alu ALU(aif);

logic [15:0] temp;
logic [15:0][7:0] hex;
genvar k, i;

always_ff @ (posedge CLOCK_50) begin
  if (SW[17]) begin
    temp <= aif.a;
  end
  else begin
    temp <= temp;
  end
end

assign aif.aluop = KEY[3:0];
assign aif.b = temp;

always_comb begin
    if (SW[16] == 1) begin
      aif.a = {16'hFFFF, SW[15:0]};
    end
    else begin
      aif.b = {16'h0000, SW[15:0]};
    end
end

generate
  for (k = 0; k < 8; k++) begin
    for (i = 0; i < 4; i++) begin
      case (aif.out[(4*k + 3):(4*k)])
        4'h0: hex[k] = 7'b1000000;
        4'h1: hex[k] = 7'b1111001;
        4'h2: hex[k] = 7'b0100100;
        4'h3: hex[k] = 7'b0110000;
        4'h4: hex[k] = 7'b0011001;
        4'h5: hex[k] = 7'b0010010;
        4'h6: hex[k] = 7'b0000010;
        4'h7: hex[k] = 7'b1111000;
        4'h8: hex[k] = 7'b0000000;
        4'h9: hex[k] = 7'b0010000;
        4'ha: hex[k] = 7'b0001000;
        4'hb: hex[k] = 7'b0000011;
        4'hc: hex[k] = 7'b0100111;
        4'hd: hex[k] = 7'b0100001;
        4'he: hex[k] = 7'b0000110;
        4'hf: hex[k] = 7'b0001110;
      endcase
    end
  end
endgenerate

assign HEX7 = hex[7];
assign HEX6 = hex[6];
assign HEX5 = hex[5];
assign HEX4 = hex[4];
assign HEX3 = hex[3];
assign HEX2 = hex[2];
assign HEX1 = hex[1];
assign HEX0 = hex[0];


/*
assign rfif.wsel = SW[4:0];
assign rfif.rsel1 = SW[9:5];
assign rfif.rsel2 = SW[14:10];
assign rfif.wdat = {29'b0,SW[17:15]};

assign rfif.WEN = ~KEY[3];

assign LEDR[8:5] = rfif.rdat1[3:0];
assign LEDR[13:10] = rfif.rdat2[3:0];
*/
endmodule
