module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[Uart.scala 33:25]
  reg [19:0] cntReg; // @[Uart.scala 34:23]
  reg [3:0] bitsReg; // @[Uart.scala 35:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[Uart.scala 37:31]
  wire [9:0] shift = shiftReg[10:1]; // @[Uart.scala 45:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[Uart.scala 46:23]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 47:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[Uart.scala 51:44]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 59:22]
  assign io_txd = shiftReg[0]; // @[Uart.scala 39:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[Uart.scala 37:40]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 33:25]
      shiftReg <= 11'h7ff; // @[Uart.scala 33:25]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 41:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 44:27]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 46:16]
      end else if (io_channel_valid) begin // @[Uart.scala 49:30]
        shiftReg <= _shiftReg_T_3; // @[Uart.scala 51:18]
      end else begin
        shiftReg <= 11'h7ff; // @[Uart.scala 54:18]
      end
    end
    if (reset) begin // @[Uart.scala 34:23]
      cntReg <= 20'h0; // @[Uart.scala 34:23]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 41:24]
      cntReg <= 20'h1457; // @[Uart.scala 43:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Uart.scala 59:12]
    end
    if (reset) begin // @[Uart.scala 35:24]
      bitsReg <= 4'h0; // @[Uart.scala 35:24]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 41:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 44:27]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 47:15]
      end else if (io_channel_valid) begin // @[Uart.scala 49:30]
        bitsReg <= 4'hb; // @[Uart.scala 52:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Rx(
  input        clock,
  input        reset,
  input        io_rxd,
  input        io_channel_ready,
  output       io_channel_valid,
  output [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg  rxReg_REG; // @[Uart.scala 83:30]
  reg  rxReg; // @[Uart.scala 83:22]
  reg [7:0] shiftReg; // @[Uart.scala 85:25]
  reg [19:0] cntReg; // @[Uart.scala 86:23]
  reg [3:0] bitsReg; // @[Uart.scala 87:24]
  reg  validReg; // @[Uart.scala 88:25]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 91:22]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[Uart.scala 94:23]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 95:24]
  wire  _GEN_0 = bitsReg == 4'h1 | validReg; // @[Uart.scala 97:27 98:16 88:25]
  assign io_channel_valid = validReg; // @[Uart.scala 112:20]
  assign io_channel_bits = shiftReg; // @[Uart.scala 111:19]
  always @(posedge clock) begin
    rxReg_REG <= reset | io_rxd; // @[Uart.scala 83:{30,30,30}]
    rxReg <= reset | rxReg_REG; // @[Uart.scala 83:{22,22,22}]
    if (reset) begin // @[Uart.scala 85:25]
      shiftReg <= 8'h0; // @[Uart.scala 85:25]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 90:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 92:32]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 94:14]
      end
    end
    if (reset) begin // @[Uart.scala 86:23]
      cntReg <= 20'h0; // @[Uart.scala 86:23]
    end else if (cntReg != 20'h0) begin // @[Uart.scala 90:24]
      cntReg <= _cntReg_T_1; // @[Uart.scala 91:12]
    end else if (bitsReg != 4'h0) begin // @[Uart.scala 92:32]
      cntReg <= 20'h1457; // @[Uart.scala 93:12]
    end else if (~rxReg) begin // @[Uart.scala 100:30]
      cntReg <= 20'h1e84; // @[Uart.scala 102:12]
    end
    if (reset) begin // @[Uart.scala 87:24]
      bitsReg <= 4'h0; // @[Uart.scala 87:24]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 90:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 92:32]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 95:13]
      end else if (~rxReg) begin // @[Uart.scala 100:30]
        bitsReg <= 4'h8; // @[Uart.scala 103:13]
      end
    end
    if (reset) begin // @[Uart.scala 88:25]
      validReg <= 1'h0; // @[Uart.scala 88:25]
    end else if (validReg & io_channel_ready) begin // @[Uart.scala 106:38]
      validReg <= 1'h0; // @[Uart.scala 107:14]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 90:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 92:32]
        validReg <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rxReg_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rxReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  shiftReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  cntReg = _RAND_3[19:0];
  _RAND_4 = {1{`RANDOM}};
  bitsReg = _RAND_4[3:0];
  _RAND_5 = {1{`RANDOM}};
  validReg = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[Uart.scala 125:25]
  reg [7:0] dataReg; // @[Uart.scala 126:24]
  wire  _io_in_ready_T = ~stateReg; // @[Uart.scala 128:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[Uart.scala 132:23 134:16 125:25]
  assign io_in_ready = ~stateReg; // @[Uart.scala 128:27]
  assign io_out_valid = stateReg; // @[Uart.scala 129:28]
  assign io_out_bits = dataReg; // @[Uart.scala 141:15]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 125:25]
      stateReg <= 1'h0; // @[Uart.scala 125:25]
    end else if (_io_in_ready_T) begin // @[Uart.scala 131:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[Uart.scala 137:24]
      stateReg <= 1'h0; // @[Uart.scala 138:16]
    end
    if (reset) begin // @[Uart.scala 126:24]
      dataReg <= 8'h0; // @[Uart.scala 126:24]
    end else if (_io_in_ready_T) begin // @[Uart.scala 131:28]
      if (io_in_valid) begin // @[Uart.scala 132:23]
        dataReg <= io_in_bits; // @[Uart.scala 133:15]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Handle(
  input   clock,
  input   reset,
  output  io_txd,
  input   io_rxd,
  input   io_updateKey
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[Uart.scala 151:18]
  wire  tx_reset; // @[Uart.scala 151:18]
  wire  tx_io_txd; // @[Uart.scala 151:18]
  wire  tx_io_channel_ready; // @[Uart.scala 151:18]
  wire  tx_io_channel_valid; // @[Uart.scala 151:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 151:18]
  wire  rx_clock; // @[Uart.scala 152:18]
  wire  rx_reset; // @[Uart.scala 152:18]
  wire  rx_io_rxd; // @[Uart.scala 152:18]
  wire  rx_io_channel_ready; // @[Uart.scala 152:18]
  wire  rx_io_channel_valid; // @[Uart.scala 152:18]
  wire [7:0] rx_io_channel_bits; // @[Uart.scala 152:18]
  wire  buf__clock; // @[Uart.scala 157:19]
  wire  buf__reset; // @[Uart.scala 157:19]
  wire  buf__io_in_ready; // @[Uart.scala 157:19]
  wire  buf__io_in_valid; // @[Uart.scala 157:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 157:19]
  wire  buf__io_out_ready; // @[Uart.scala 157:19]
  wire  buf__io_out_valid; // @[Uart.scala 157:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 157:19]
  reg [7:0] key; // @[Uart.scala 153:20]
  reg  updateKey; // @[Uart.scala 154:26]
  wire  _GEN_0 = buf__io_out_valid | tx_io_channel_ready; // @[Uart.scala 161:20 165:29 166:24]
  wire  _GEN_2 = buf__io_out_valid ? 1'h0 : io_updateKey; // @[Uart.scala 155:13 165:29 168:17]
  wire  _GEN_5 = updateKey ? _GEN_2 : io_updateKey; // @[Uart.scala 155:13 164:20]
  Tx tx ( // @[Uart.scala 151:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[Uart.scala 152:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 157:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 172:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 160:23]
  assign tx_io_channel_bits = buf__io_out_bits ^ key; // @[Uart.scala 159:41]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[Uart.scala 173:13]
  assign rx_io_channel_ready = buf__io_in_ready; // @[Uart.scala 158:13]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = rx_io_channel_valid; // @[Uart.scala 158:13]
  assign buf__io_in_bits = rx_io_channel_bits; // @[Uart.scala 158:13]
  assign buf__io_out_ready = updateKey ? _GEN_0 : tx_io_channel_ready; // @[Uart.scala 161:20 164:20]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 153:20]
      key <= 8'h55; // @[Uart.scala 153:20]
    end else if (updateKey) begin // @[Uart.scala 164:20]
      if (buf__io_out_valid) begin // @[Uart.scala 165:29]
        key <= buf__io_out_bits; // @[Uart.scala 167:11]
      end
    end
    updateKey <= reset | _GEN_5; // @[Uart.scala 154:{26,26}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  key = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  updateKey = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module tt_um_XORCipher(
  input  [7:0] ui_in,
  output [7:0] uo_out,
  input  [7:0] uio_in,
  output [7:0] uio_out,
  output [7:0] uio_oe,
  input        ena,
  input        clk,
  input        rst_n
);
  wire  e_clock; // @[Uart.scala 197:48]
  wire  e_reset; // @[Uart.scala 197:48]
  wire  e_io_txd; // @[Uart.scala 197:48]
  wire  e_io_rxd; // @[Uart.scala 197:48]
  wire  e_io_updateKey; // @[Uart.scala 197:48]
  wire  txd = e_io_txd; // @[Uart.scala 193:17 199:7]
  Handle e ( // @[Uart.scala 197:48]
    .clock(e_clock),
    .reset(e_reset),
    .io_txd(e_io_txd),
    .io_rxd(e_io_rxd),
    .io_updateKey(e_io_updateKey)
  );
  wire _unused = &{ena, 1'b0};
  wire _unused2 = &{uio_in, ui_in, 8'b0};

  assign uo_out = {7'h0,txd}; // @[Cat.scala 31:58]
  assign uio_out = 8'h0; // @[Uart.scala 188:11]
  assign uio_oe = 8'h0; // @[Uart.scala 189:10]
  assign e_clock = clk;
  assign e_reset = rst_n;
  assign e_io_rxd = ui_in[7]; // @[Uart.scala 194:15]
  assign e_io_updateKey = ui_in[0]; // @[Uart.scala 200:26]
endmodule
