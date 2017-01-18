/*
  Eric Villasenor
  evillase@gmail.com

  register file fpga wrapper
*/

// interface
`include "register_file_if.vh"
`include "alu_if.vh"

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

logic [31:0] temp;
genvar k, i;

always_ff @ (posedge CLOCK_50) begin
  if (SW[17]) begin
    temp <= aif.a;
  end
  else begin
    temp <= temp;
  end
end

assign aif.b = temp;
assign aif.aluop[3:0] = ~KEY[3:0];

always_comb begin
    if (SW[16] == 1) begin
      aif.a = {16'hFFFF, SW[15:0]};
    end
    else begin
      aif.a = {16'h0000, SW[15:0]};
    end

case (aif.out[3:0])
  4'h0: HEX0 = 7'b1000000;
  4'h1: HEX0 = 7'b1111001;
  4'h2: HEX0 = 7'b0100100;
  4'h3: HEX0 = 7'b0110000;
  4'h4: HEX0 = 7'b0011001;
  4'h5: HEX0 = 7'b0010010;
  4'h6: HEX0 = 7'b0000010;
  4'h7: HEX0 = 7'b1111000;
  4'h8: HEX0 = 7'b0000000;
  4'h9: HEX0 = 7'b0010000;
  4'ha: HEX0 = 7'b0001000;
  4'hb: HEX0 = 7'b0000011;
  4'hc: HEX0 = 7'b0100111;
  4'hd: HEX0 = 7'b0100001;
  4'he: HEX0 = 7'b0000110;
  4'hf: HEX0 = 7'b0001110;
endcase

case (aif.out[7:4])
  4'h0: HEX1 = 7'b1000000;
  4'h1: HEX1 = 7'b1111001;
  4'h2: HEX1 = 7'b0100100;
  4'h3: HEX1 = 7'b0110000;
  4'h4: HEX1 = 7'b0011001;
  4'h5: HEX1 = 7'b0010010;
  4'h6: HEX1 = 7'b0000010;
  4'h7: HEX1 = 7'b1111000;
  4'h8: HEX1 = 7'b0000000;
  4'h9: HEX1 = 7'b0010000;
  4'ha: HEX1 = 7'b0001000;
  4'hb: HEX1 = 7'b0000011;
  4'hc: HEX1 = 7'b0100111;
  4'hd: HEX1 = 7'b0100001;
  4'he: HEX1 = 7'b0000110;
  4'hf: HEX1 = 7'b0001110;
endcase

case (aif.out[11:8])
  4'h0: HEX2 = 7'b1000000;
  4'h1: HEX2 = 7'b1111001;
  4'h2: HEX2 = 7'b0100100;
  4'h3: HEX2 = 7'b0110000;
  4'h4: HEX2 = 7'b0011001;
  4'h5: HEX2 = 7'b0010010;
  4'h6: HEX2 = 7'b0000010;
  4'h7: HEX2 = 7'b1111000;
  4'h8: HEX2 = 7'b0000000;
  4'h9: HEX2 = 7'b0010000;
  4'ha: HEX2 = 7'b0001000;
  4'hb: HEX2 = 7'b0000011;
  4'hc: HEX2 = 7'b0100111;
  4'hd: HEX2 = 7'b0100001;
  4'he: HEX2 = 7'b0000110;
  4'hf: HEX2 = 7'b0001110;
endcase

case (aif.out[15:12])
  4'h0: HEX3 = 7'b1000000;
  4'h1: HEX3 = 7'b1111001;
  4'h2: HEX3 = 7'b0100100;
  4'h3: HEX3 = 7'b0110000;
  4'h4: HEX3 = 7'b0011001;
  4'h5: HEX3 = 7'b0010010;
  4'h6: HEX3 = 7'b0000010;
  4'h7: HEX3 = 7'b1111000;
  4'h8: HEX3 = 7'b0000000;
  4'h9: HEX3 = 7'b0010000;
  4'ha: HEX3 = 7'b0001000;
  4'hb: HEX3 = 7'b0000011;
  4'hc: HEX3 = 7'b0100111;
  4'hd: HEX3 = 7'b0100001;
  4'he: HEX3 = 7'b0000110;
  4'hf: HEX3 = 7'b0001110;
endcase

case (aif.out[19:16])
  4'h0: HEX4 = 7'b1000000;
  4'h1: HEX4 = 7'b1111001;
  4'h2: HEX4 = 7'b0100100;
  4'h3: HEX4 = 7'b0110000;
  4'h4: HEX4 = 7'b0011001;
  4'h5: HEX4 = 7'b0010010;
  4'h6: HEX4 = 7'b0000010;
  4'h7: HEX4 = 7'b1111000;
  4'h8: HEX4 = 7'b0000000;
  4'h9: HEX4 = 7'b0010000;
  4'ha: HEX4 = 7'b0001000;
  4'hb: HEX4 = 7'b0000011;
  4'hc: HEX4 = 7'b0100111;
  4'hd: HEX4 = 7'b0100001;
  4'he: HEX4 = 7'b0000110;
  4'hf: HEX4 = 7'b0001110;
endcase

case (aif.out[23:20])
  4'h0: HEX5 = 7'b1000000;
  4'h1: HEX5 = 7'b1111001;
  4'h2: HEX5 = 7'b0100100;
  4'h3: HEX5 = 7'b0110000;
  4'h4: HEX5 = 7'b0011001;
  4'h5: HEX5 = 7'b0010010;
  4'h6: HEX5 = 7'b0000010;
  4'h7: HEX5 = 7'b1111000;
  4'h8: HEX5 = 7'b0000000;
  4'h9: HEX5 = 7'b0010000;
  4'ha: HEX5 = 7'b0001000;
  4'hb: HEX5 = 7'b0000011;
  4'hc: HEX5 = 7'b0100111;
  4'hd: HEX5 = 7'b0100001;
  4'he: HEX5 = 7'b0000110;
  4'hf: HEX5 = 7'b0001110;
endcase

case (aif.out[27:24])
  4'h0: HEX6 = 7'b1000000;
  4'h1: HEX6 = 7'b1111001;
  4'h2: HEX6 = 7'b0100100;
  4'h3: HEX6 = 7'b0110000;
  4'h4: HEX6 = 7'b0011001;
  4'h5: HEX6 = 7'b0010010;
  4'h6: HEX6 = 7'b0000010;
  4'h7: HEX6 = 7'b1111000;
  4'h8: HEX6 = 7'b0000000;
  4'h9: HEX6 = 7'b0010000;
  4'ha: HEX6 = 7'b0001000;
  4'hb: HEX6 = 7'b0000011;
  4'hc: HEX6 = 7'b0100111;
  4'hd: HEX6 = 7'b0100001;
  4'he: HEX6 = 7'b0000110;
  4'hf: HEX6 = 7'b0001110;
endcase

case (aif.out[31:28])
  4'h0: HEX7 = 7'b1000000;
  4'h1: HEX7 = 7'b1111001;
  4'h2: HEX7 = 7'b0100100;
  4'h3: HEX7 = 7'b0110000;
  4'h4: HEX7 = 7'b0011001;
  4'h5: HEX7 = 7'b0010010;
  4'h6: HEX7 = 7'b0000010;
  4'h7: HEX7 = 7'b1111000;
  4'h8: HEX7 = 7'b0000000;
  4'h9: HEX7 = 7'b0010000;
  4'ha: HEX7 = 7'b0001000;
  4'hb: HEX7 = 7'b0000011;
  4'hc: HEX7 = 7'b0100111;
  4'hd: HEX7 = 7'b0100001;
  4'he: HEX7 = 7'b0000110;
  4'hf: HEX7 = 7'b0001110;
endcase
end

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
