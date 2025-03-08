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
  reg [10:0] shiftReg; // @[Uart.scala 34:25]
  reg [19:0] cntReg; // @[Uart.scala 35:23]
  reg [3:0] bitsReg; // @[Uart.scala 36:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[Uart.scala 38:31]
  wire [9:0] shift = shiftReg[10:1]; // @[Uart.scala 46:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[Uart.scala 47:23]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 48:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[Uart.scala 52:44]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 60:22]
  assign io_txd = shiftReg[0]; // @[Uart.scala 40:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[Uart.scala 38:40]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 34:25]
      shiftReg <= 11'h7ff; // @[Uart.scala 34:25]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 42:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 45:27]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 47:16]
      end else if (io_channel_valid) begin // @[Uart.scala 50:30]
        shiftReg <= _shiftReg_T_3; // @[Uart.scala 52:18]
      end else begin
        shiftReg <= 11'h7ff; // @[Uart.scala 55:18]
      end
    end
    if (reset) begin // @[Uart.scala 35:23]
      cntReg <= 20'h0; // @[Uart.scala 35:23]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 42:24]
      cntReg <= 20'h28b0; // @[Uart.scala 44:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Uart.scala 60:12]
    end
    if (reset) begin // @[Uart.scala 36:24]
      bitsReg <= 4'h0; // @[Uart.scala 36:24]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 42:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 45:27]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 48:15]
      end else if (io_channel_valid) begin // @[Uart.scala 50:30]
        bitsReg <= 4'hb; // @[Uart.scala 53:17]
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
  reg  rxReg_REG; // @[Uart.scala 84:30]
  reg  rxReg; // @[Uart.scala 84:22]
  reg [7:0] shiftReg; // @[Uart.scala 86:25]
  reg [19:0] cntReg; // @[Uart.scala 87:23]
  reg [3:0] bitsReg; // @[Uart.scala 88:24]
  reg  validReg; // @[Uart.scala 89:25]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 92:22]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[Uart.scala 95:23]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 96:24]
  wire  _GEN_0 = bitsReg == 4'h1 | validReg; // @[Uart.scala 98:27 99:16 89:25]
  assign io_channel_valid = validReg; // @[Uart.scala 113:20]
  assign io_channel_bits = shiftReg; // @[Uart.scala 112:19]
  always @(posedge clock) begin
    rxReg_REG <= reset | io_rxd; // @[Uart.scala 84:{30,30,30}]
    rxReg <= reset | rxReg_REG; // @[Uart.scala 84:{22,22,22}]
    if (reset) begin // @[Uart.scala 86:25]
      shiftReg <= 8'h0; // @[Uart.scala 86:25]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 91:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 93:32]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 95:14]
      end
    end
    if (reset) begin // @[Uart.scala 87:23]
      cntReg <= 20'h0; // @[Uart.scala 87:23]
    end else if (cntReg != 20'h0) begin // @[Uart.scala 91:24]
      cntReg <= _cntReg_T_1; // @[Uart.scala 92:12]
    end else if (bitsReg != 4'h0) begin // @[Uart.scala 93:32]
      cntReg <= 20'h28b0; // @[Uart.scala 94:12]
    end else if (~rxReg) begin // @[Uart.scala 101:30]
      cntReg <= 20'h3d08; // @[Uart.scala 103:12]
    end
    if (reset) begin // @[Uart.scala 88:24]
      bitsReg <= 4'h0; // @[Uart.scala 88:24]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 91:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 93:32]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 96:13]
      end else if (~rxReg) begin // @[Uart.scala 101:30]
        bitsReg <= 4'h8; // @[Uart.scala 104:13]
      end
    end
    if (reset) begin // @[Uart.scala 89:25]
      validReg <= 1'h0; // @[Uart.scala 89:25]
    end else if (validReg & io_channel_ready) begin // @[Uart.scala 107:38]
      validReg <= 1'h0; // @[Uart.scala 108:14]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 91:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 93:32]
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
  reg  stateReg; // @[Uart.scala 128:25]
  reg [7:0] dataReg; // @[Uart.scala 129:24]
  wire  _io_in_ready_T = ~stateReg; // @[Uart.scala 131:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[Uart.scala 135:23 137:16 128:25]
  assign io_in_ready = ~stateReg; // @[Uart.scala 131:27]
  assign io_out_valid = stateReg; // @[Uart.scala 132:28]
  assign io_out_bits = dataReg; // @[Uart.scala 144:15]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 128:25]
      stateReg <= 1'h0; // @[Uart.scala 128:25]
    end else if (_io_in_ready_T) begin // @[Uart.scala 134:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[Uart.scala 140:24]
      stateReg <= 1'h0; // @[Uart.scala 141:16]
    end
    if (reset) begin // @[Uart.scala 129:24]
      dataReg <= 8'h0; // @[Uart.scala 129:24]
    end else if (_io_in_ready_T) begin // @[Uart.scala 134:28]
      if (io_in_valid) begin // @[Uart.scala 135:23]
        dataReg <= io_in_bits; // @[Uart.scala 136:15]
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
  wire  tx_clock; // @[Uart.scala 218:18]
  wire  tx_reset; // @[Uart.scala 218:18]
  wire  tx_io_txd; // @[Uart.scala 218:18]
  wire  tx_io_channel_ready; // @[Uart.scala 218:18]
  wire  tx_io_channel_valid; // @[Uart.scala 218:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 218:18]
  wire  rx_clock; // @[Uart.scala 219:18]
  wire  rx_reset; // @[Uart.scala 219:18]
  wire  rx_io_rxd; // @[Uart.scala 219:18]
  wire  rx_io_channel_ready; // @[Uart.scala 219:18]
  wire  rx_io_channel_valid; // @[Uart.scala 219:18]
  wire [7:0] rx_io_channel_bits; // @[Uart.scala 219:18]
  wire  buf__clock; // @[Uart.scala 224:19]
  wire  buf__reset; // @[Uart.scala 224:19]
  wire  buf__io_in_ready; // @[Uart.scala 224:19]
  wire  buf__io_in_valid; // @[Uart.scala 224:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 224:19]
  wire  buf__io_out_ready; // @[Uart.scala 224:19]
  wire  buf__io_out_valid; // @[Uart.scala 224:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 224:19]
  reg [7:0] key; // @[Uart.scala 220:20]
  reg  updateKey; // @[Uart.scala 221:26]
  wire  _GEN_0 = buf__io_out_valid | tx_io_channel_ready; // @[Uart.scala 228:20 232:29 233:24]
  wire  _GEN_2 = buf__io_out_valid ? 1'h0 : io_updateKey; // @[Uart.scala 222:13 232:29 235:17]
  wire  _GEN_5 = updateKey ? _GEN_2 : io_updateKey; // @[Uart.scala 222:13 231:20]
  Tx tx ( // @[Uart.scala 218:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[Uart.scala 219:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 224:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 238:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 227:23]
  assign tx_io_channel_bits = buf__io_out_bits ^ key; // @[Uart.scala 226:41]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[Uart.scala 239:13]
  assign rx_io_channel_ready = buf__io_in_ready; // @[Uart.scala 225:13]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = rx_io_channel_valid; // @[Uart.scala 225:13]
  assign buf__io_in_bits = rx_io_channel_bits; // @[Uart.scala 225:13]
  assign buf__io_out_ready = updateKey ? _GEN_0 : tx_io_channel_ready; // @[Uart.scala 228:20 231:20]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 220:20]
      key <= 8'h55; // @[Uart.scala 220:20]
    end else if (updateKey) begin // @[Uart.scala 231:20]
      if (buf__io_out_valid) begin // @[Uart.scala 232:29]
        key <= buf__io_out_bits; // @[Uart.scala 234:11]
      end
    end
    updateKey <= reset | _GEN_5; // @[Uart.scala 221:{26,26}]
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
module tt_XORCipher(
  input  [7:0] ui_in,
  output [7:0] uo_out,
  input        clk,
  input        rst_n
);
  wire  e_clock; // @[Uart.scala 282:48]
  wire  e_reset; // @[Uart.scala 282:48]
  wire  e_io_txd; // @[Uart.scala 282:48]
  wire  e_io_rxd; // @[Uart.scala 282:48]
  wire  e_io_updateKey; // @[Uart.scala 282:48]
  wire  txd = e_io_txd; // @[Uart.scala 278:17 284:7]
  Handle e ( // @[Uart.scala 282:48]
    .clock(e_clock),
    .reset(e_reset),
    .io_txd(e_io_txd),
    .io_rxd(e_io_rxd),
    .io_updateKey(e_io_updateKey)
  );
  assign uo_out = {7'h0,txd}; // @[Cat.scala 31:58]
  assign e_clock = clk;
  assign e_reset = rst_n;
  assign e_io_rxd = ui_in[7]; // @[Uart.scala 279:15]
  assign e_io_updateKey = ui_in[0]; // @[Uart.scala 285:26]
endmodule
module Wrapper(
  input   rxd,
  output  txd,
  input   clk,
  input   rst_n,
  input   updateKey
);
  wire [7:0] device_ui_in; // @[Uart.scala 294:22]
  wire [7:0] device_uo_out; // @[Uart.scala 294:22]
  wire  device_clk; // @[Uart.scala 294:22]
  wire  device_rst_n; // @[Uart.scala 294:22]
  wire [6:0] device_ui_in_hi = {rxd,6'h0}; // @[Cat.scala 31:58]
  tt_XORCipher device ( // @[Uart.scala 294:22]
    .ui_in(device_ui_in),
    .uo_out(device_uo_out),
    .clk(device_clk),
    .rst_n(device_rst_n)
  );
  assign txd = device_uo_out[0]; // @[Uart.scala 300:23]
  assign device_ui_in = {device_ui_in_hi,updateKey}; // @[Cat.scala 31:58]
  assign device_clk = clk; // @[Uart.scala 295:14]
  assign device_rst_n = rst_n; // @[Uart.scala 296:16]
endmodule
