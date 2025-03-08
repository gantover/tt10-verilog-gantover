circuit Wrapper :
  module Tx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg shiftReg : UInt, clock with :
      reset => (reset, UInt<11>("h7ff")) @[Uart.scala 34:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Uart.scala 35:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Uart.scala 36:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 38:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[Uart.scala 38:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[Uart.scala 38:40]
    io.channel.ready <= _io_channel_ready_T_2 @[Uart.scala 38:20]
    node _io_txd_T = bits(shiftReg, 0, 0) @[Uart.scala 40:21]
    io.txd <= _io_txd_T @[Uart.scala 40:10]
    node _T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 42:15]
    when _T : @[Uart.scala 42:24]
      cntReg <= UInt<14>("h28b0") @[Uart.scala 44:12]
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 45:18]
      when _T_1 : @[Uart.scala 45:27]
        node shift = shr(shiftReg, 1) @[Uart.scala 46:28]
        node _shiftReg_T = bits(shift, 9, 0) @[Uart.scala 47:31]
        node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[Uart.scala 47:23]
        shiftReg <= _shiftReg_T_1 @[Uart.scala 47:16]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 48:26]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 48:26]
        bitsReg <= _bitsReg_T_1 @[Uart.scala 48:15]
      else :
        when io.channel.valid : @[Uart.scala 50:30]
          node _shiftReg_T_2 = cat(UInt<2>("h3"), io.channel.bits) @[Uart.scala 52:25]
          node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[Uart.scala 52:44]
          shiftReg <= _shiftReg_T_3 @[Uart.scala 52:18]
          bitsReg <= UInt<4>("hb") @[Uart.scala 53:17]
        else :
          shiftReg <= UInt<11>("h7ff") @[Uart.scala 55:18]
    else :
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 60:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 60:22]
      cntReg <= _cntReg_T_1 @[Uart.scala 60:12]

  module Rx :
    input clock : Clock
    input reset : Reset
    output io : { flip rxd : UInt<1>, channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg rxReg_REG : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 84:30]
    rxReg_REG <= io.rxd @[Uart.scala 84:30]
    reg rxReg : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 84:22]
    rxReg <= rxReg_REG @[Uart.scala 84:22]
    reg shiftReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 86:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Uart.scala 87:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Uart.scala 88:24]
    reg validReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 89:25]
    node _T = neq(cntReg, UInt<1>("h0")) @[Uart.scala 91:15]
    when _T : @[Uart.scala 91:24]
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 92:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 92:22]
      cntReg <= _cntReg_T_1 @[Uart.scala 92:12]
    else :
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 93:23]
      when _T_1 : @[Uart.scala 93:32]
        cntReg <= UInt<14>("h28b0") @[Uart.scala 94:12]
        node _shiftReg_T = shr(shiftReg, 1) @[Uart.scala 95:36]
        node _shiftReg_T_1 = cat(rxReg, _shiftReg_T) @[Uart.scala 95:23]
        shiftReg <= _shiftReg_T_1 @[Uart.scala 95:14]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 96:24]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 96:24]
        bitsReg <= _bitsReg_T_1 @[Uart.scala 96:13]
        node _T_2 = eq(bitsReg, UInt<1>("h1")) @[Uart.scala 98:18]
        when _T_2 : @[Uart.scala 98:27]
          validReg <= UInt<1>("h1") @[Uart.scala 99:16]
      else :
        node _T_3 = eq(rxReg, UInt<1>("h0")) @[Uart.scala 101:21]
        when _T_3 : @[Uart.scala 101:30]
          cntReg <= UInt<14>("h3d08") @[Uart.scala 103:12]
          bitsReg <= UInt<4>("h8") @[Uart.scala 104:13]
    node _T_4 = and(validReg, io.channel.ready) @[Uart.scala 107:17]
    when _T_4 : @[Uart.scala 107:38]
      validReg <= UInt<1>("h0") @[Uart.scala 108:14]
    io.channel.bits <= shiftReg @[Uart.scala 112:19]
    io.channel.valid <= validReg @[Uart.scala 113:20]

  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 128:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 129:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 131:27]
    io.in.ready <= _io_in_ready_T @[Uart.scala 131:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Uart.scala 132:28]
    io.out.valid <= _io_out_valid_T @[Uart.scala 132:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 134:17]
    when _T : @[Uart.scala 134:28]
      when io.in.valid : @[Uart.scala 135:23]
        dataReg <= io.in.bits @[Uart.scala 136:15]
        stateReg <= UInt<1>("h1") @[Uart.scala 137:16]
    else :
      when io.out.ready : @[Uart.scala 140:24]
        stateReg <= UInt<1>("h0") @[Uart.scala 141:16]
    io.out.bits <= dataReg @[Uart.scala 144:15]

  module Handle :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip rxd : UInt<1>, flip updateKey : UInt<1>}

    inst tx of Tx @[Uart.scala 218:18]
    tx.clock <= clock
    tx.reset <= reset
    inst rx of Rx @[Uart.scala 219:18]
    rx.clock <= clock
    rx.reset <= reset
    reg key : UInt<8>, clock with :
      reset => (reset, UInt<8>("h55")) @[Uart.scala 220:20]
    reg updateKey : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 221:26]
    updateKey <= io.updateKey @[Uart.scala 222:13]
    inst buf of Buffer @[Uart.scala 224:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= rx.io.channel @[Uart.scala 225:13]
    node _tx_io_channel_bits_T = xor(buf.io.out.bits, key) @[Uart.scala 226:41]
    tx.io.channel.bits <= _tx_io_channel_bits_T @[Uart.scala 226:22]
    tx.io.channel.valid <= buf.io.out.valid @[Uart.scala 227:23]
    buf.io.out.ready <= tx.io.channel.ready @[Uart.scala 228:20]
    when updateKey : @[Uart.scala 231:20]
      when buf.io.out.valid : @[Uart.scala 232:29]
        buf.io.out.ready <= UInt<1>("h1") @[Uart.scala 233:24]
        key <= buf.io.out.bits @[Uart.scala 234:11]
        updateKey <= UInt<1>("h0") @[Uart.scala 235:17]
    io.txd <= tx.io.txd @[Uart.scala 238:10]
    rx.io.rxd <= io.rxd @[Uart.scala 239:13]

  module tt_XORCipher :
    input ui_in : UInt<8>
    output uo_out : UInt<8>
    input uio_in : UInt<8>
    output uio_out : UInt<8>
    output uio_oe : UInt<8>
    input ena : UInt<1>
    input clk : Clock
    input rst_n : UInt<1>

    node ___T = and(uio_in, ui_in) @[Uart.scala 272:18]
    node ___T_1 = and(___T, UInt<8>("h0")) @[Uart.scala 272:26]
    node ___T_2 = cat(ena, UInt<7>("h0")) @[Uart.scala 272:44]
    node _ = and(___T_1, ___T_2) @[Uart.scala 272:37]
    uio_out <= UInt<1>("h0") @[Uart.scala 273:11]
    uio_oe <= UInt<1>("h0") @[Uart.scala 274:10]
    wire rxd : UInt<1> @[Uart.scala 277:17]
    wire txd : UInt<1> @[Uart.scala 278:17]
    node _rxd_T = bits(ui_in, 7, 7) @[Uart.scala 279:15]
    rxd <= _rxd_T @[Uart.scala 279:7]
    node _uo_out_T = bits(txd, 0, 0) @[Uart.scala 280:31]
    node _uo_out_T_1 = cat(UInt<7>("h0"), _uo_out_T) @[Cat.scala 31:58]
    uo_out <= _uo_out_T_1 @[Uart.scala 280:10]
    inst e of Handle @[Uart.scala 282:48]
    e.clock <= clk
    e.reset <= rst_n
    e.io.rxd <= rxd @[Uart.scala 283:12]
    txd <= e.io.txd @[Uart.scala 284:7]
    node _e_io_updateKey_T = bits(ui_in, 0, 0) @[Uart.scala 285:26]
    e.io.updateKey <= _e_io_updateKey_T @[Uart.scala 285:18]

  module Wrapper :
    input rxd : UInt<1>
    output txd : UInt<1>
    input clk : Clock
    input rst_n : UInt<1>
    input updateKey : UInt<1>

    inst device of tt_XORCipher @[Uart.scala 294:22]
    device.clk <= clk @[Uart.scala 295:14]
    device.rst_n <= rst_n @[Uart.scala 296:16]
    node device_ui_in_hi = cat(rxd, UInt<6>("h0")) @[Cat.scala 31:58]
    node _device_ui_in_T = cat(device_ui_in_hi, updateKey) @[Cat.scala 31:58]
    device.ui_in <= _device_ui_in_T @[Uart.scala 297:16]
    device.uio_in <= UInt<1>("h0") @[Uart.scala 298:17]
    device.ena <= UInt<1>("h0") @[Uart.scala 299:14]
    node _txd_T = bits(device.uo_out, 0, 0) @[Uart.scala 300:23]
    txd <= _txd_T @[Uart.scala 300:7]

