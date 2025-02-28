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
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  wire  tx_clock; // @[Uart.scala 157:18]
  wire  tx_reset; // @[Uart.scala 157:18]
  wire  tx_io_txd; // @[Uart.scala 157:18]
  wire  tx_io_channel_ready; // @[Uart.scala 157:18]
  wire  tx_io_channel_valid; // @[Uart.scala 157:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 157:18]
  wire  buf__clock; // @[Uart.scala 158:19]
  wire  buf__reset; // @[Uart.scala 158:19]
  wire  buf__io_in_ready; // @[Uart.scala 158:19]
  wire  buf__io_in_valid; // @[Uart.scala 158:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 158:19]
  wire  buf__io_out_ready; // @[Uart.scala 158:19]
  wire  buf__io_out_valid; // @[Uart.scala 158:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 158:19]
  Tx tx ( // @[Uart.scala 157:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 158:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 162:10]
  assign io_channel_ready = buf__io_in_ready; // @[Uart.scala 160:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 161:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[Uart.scala 161:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[Uart.scala 160:13]
  assign buf__io_in_bits = io_channel_bits; // @[Uart.scala 160:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[Uart.scala 161:17]
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
module RegFifo(
  input        clock,
  input        reset,
  output       io_enq_ready,
  input        io_enq_valid,
  input  [7:0] io_enq_bits,
  input        io_deq_ready,
  output       io_deq_valid,
  output [7:0] io_deq_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] memReg_0; // @[RegFifo.scala 21:19]
  reg [7:0] memReg_1; // @[RegFifo.scala 21:19]
  reg [7:0] memReg_2; // @[RegFifo.scala 21:19]
  reg [7:0] memReg_3; // @[RegFifo.scala 21:19]
  reg [1:0] readPtr; // @[RegFifo.scala 12:25]
  wire [1:0] _nextVal_T_2 = readPtr + 2'h1; // @[RegFifo.scala 13:59]
  wire [1:0] nextRead = readPtr == 2'h3 ? 2'h0 : _nextVal_T_2; // @[RegFifo.scala 13:22]
  reg  emptyReg; // @[RegFifo.scala 28:25]
  reg  fullReg; // @[RegFifo.scala 29:24]
  wire  incrRead = io_deq_ready & ~emptyReg & fullReg; // @[RegFifo.scala 38:35]
  reg [1:0] writePtr; // @[RegFifo.scala 12:25]
  wire [1:0] _nextVal_T_5 = writePtr + 2'h1; // @[RegFifo.scala 13:59]
  wire [1:0] nextWrite = writePtr == 2'h3 ? 2'h0 : _nextVal_T_5; // @[RegFifo.scala 13:22]
  wire  incrWrite = io_enq_valid & ~fullReg; // @[RegFifo.scala 31:22]
  wire  _GEN_10 = incrWrite ? 1'h0 : emptyReg; // @[RegFifo.scala 31:35 33:14 28:25]
  wire  _GEN_14 = incrRead ? nextRead == writePtr : _GEN_10; // @[RegFifo.scala 38:47 40:14]
  wire [7:0] _GEN_17 = 2'h1 == readPtr ? memReg_1 : memReg_0; // @[RegFifo.scala 44:{15,15}]
  wire [7:0] _GEN_18 = 2'h2 == readPtr ? memReg_2 : _GEN_17; // @[RegFifo.scala 44:{15,15}]
  assign io_enq_ready = ~fullReg; // @[RegFifo.scala 45:19]
  assign io_deq_valid = ~emptyReg; // @[RegFifo.scala 46:19]
  assign io_deq_bits = 2'h3 == readPtr ? memReg_3 : _GEN_18; // @[RegFifo.scala 44:{15,15}]
  always @(posedge clock) begin
    if (incrWrite) begin // @[RegFifo.scala 31:35]
      if (2'h0 == writePtr) begin // @[RegFifo.scala 32:22]
        memReg_0 <= io_enq_bits; // @[RegFifo.scala 32:22]
      end
    end
    if (incrWrite) begin // @[RegFifo.scala 31:35]
      if (2'h1 == writePtr) begin // @[RegFifo.scala 32:22]
        memReg_1 <= io_enq_bits; // @[RegFifo.scala 32:22]
      end
    end
    if (incrWrite) begin // @[RegFifo.scala 31:35]
      if (2'h2 == writePtr) begin // @[RegFifo.scala 32:22]
        memReg_2 <= io_enq_bits; // @[RegFifo.scala 32:22]
      end
    end
    if (incrWrite) begin // @[RegFifo.scala 31:35]
      if (2'h3 == writePtr) begin // @[RegFifo.scala 32:22]
        memReg_3 <= io_enq_bits; // @[RegFifo.scala 32:22]
      end
    end
    if (reset) begin // @[RegFifo.scala 12:25]
      readPtr <= 2'h0; // @[RegFifo.scala 12:25]
    end else if (incrRead) begin // @[RegFifo.scala 14:17]
      if (readPtr == 2'h3) begin // @[RegFifo.scala 13:22]
        readPtr <= 2'h0;
      end else begin
        readPtr <= _nextVal_T_2;
      end
    end
    emptyReg <= reset | _GEN_14; // @[RegFifo.scala 28:{25,25}]
    if (reset) begin // @[RegFifo.scala 29:24]
      fullReg <= 1'h0; // @[RegFifo.scala 29:24]
    end else if (incrRead) begin // @[RegFifo.scala 38:47]
      fullReg <= 1'h0; // @[RegFifo.scala 39:13]
    end else if (incrWrite) begin // @[RegFifo.scala 31:35]
      fullReg <= nextWrite == readPtr; // @[RegFifo.scala 34:13]
    end
    if (reset) begin // @[RegFifo.scala 12:25]
      writePtr <= 2'h0; // @[RegFifo.scala 12:25]
    end else if (incrWrite) begin // @[RegFifo.scala 14:17]
      if (writePtr == 2'h3) begin // @[RegFifo.scala 13:22]
        writePtr <= 2'h0;
      end else begin
        writePtr <= _nextVal_T_5;
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
  memReg_0 = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  memReg_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  memReg_2 = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  memReg_3 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  readPtr = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  emptyReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  fullReg = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  writePtr = _RAND_7[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module UartFifo(
  input   clock,
  input   reset,
  input   io_rxd,
  output  io_txd,
  output  io_led_empty,
  output  io_led_full
);
  wire  tx_clock; // @[Uart.scala 234:18]
  wire  tx_reset; // @[Uart.scala 234:18]
  wire  tx_io_txd; // @[Uart.scala 234:18]
  wire  tx_io_channel_ready; // @[Uart.scala 234:18]
  wire  tx_io_channel_valid; // @[Uart.scala 234:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 234:18]
  wire  rx_clock; // @[Uart.scala 235:18]
  wire  rx_reset; // @[Uart.scala 235:18]
  wire  rx_io_rxd; // @[Uart.scala 235:18]
  wire  rx_io_channel_ready; // @[Uart.scala 235:18]
  wire  rx_io_channel_valid; // @[Uart.scala 235:18]
  wire [7:0] rx_io_channel_bits; // @[Uart.scala 235:18]
  wire  rfifo_clock; // @[Uart.scala 240:21]
  wire  rfifo_reset; // @[Uart.scala 240:21]
  wire  rfifo_io_enq_ready; // @[Uart.scala 240:21]
  wire  rfifo_io_enq_valid; // @[Uart.scala 240:21]
  wire [7:0] rfifo_io_enq_bits; // @[Uart.scala 240:21]
  wire  rfifo_io_deq_ready; // @[Uart.scala 240:21]
  wire  rfifo_io_deq_valid; // @[Uart.scala 240:21]
  wire [7:0] rfifo_io_deq_bits; // @[Uart.scala 240:21]
  BufferedTx tx ( // @[Uart.scala 234:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[Uart.scala 235:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  RegFifo rfifo ( // @[Uart.scala 240:21]
    .clock(rfifo_clock),
    .reset(rfifo_reset),
    .io_enq_ready(rfifo_io_enq_ready),
    .io_enq_valid(rfifo_io_enq_valid),
    .io_enq_bits(rfifo_io_enq_bits),
    .io_deq_ready(rfifo_io_deq_ready),
    .io_deq_valid(rfifo_io_deq_valid),
    .io_deq_bits(rfifo_io_deq_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 238:10]
  assign io_led_empty = ~rfifo_io_deq_valid; // @[Uart.scala 244:19]
  assign io_led_full = ~rfifo_io_enq_ready; // @[Uart.scala 243:18]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = rfifo_io_deq_valid; // @[Uart.scala 242:16]
  assign tx_io_channel_bits = rfifo_io_deq_bits; // @[Uart.scala 242:16]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd; // @[Uart.scala 237:13]
  assign rx_io_channel_ready = rfifo_io_enq_ready; // @[Uart.scala 241:16]
  assign rfifo_clock = clock;
  assign rfifo_reset = reset;
  assign rfifo_io_enq_valid = rx_io_channel_valid; // @[Uart.scala 241:16]
  assign rfifo_io_enq_bits = rx_io_channel_bits; // @[Uart.scala 241:16]
  assign rfifo_io_deq_ready = tx_io_channel_ready; // @[Uart.scala 242:16]
endmodule
