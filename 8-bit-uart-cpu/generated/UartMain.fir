circuit UartMain :
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

  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 127:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 128:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 130:27]
    io.in.ready <= _io_in_ready_T @[Uart.scala 130:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Uart.scala 131:28]
    io.out.valid <= _io_out_valid_T @[Uart.scala 131:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 133:17]
    when _T : @[Uart.scala 133:28]
      when io.in.valid : @[Uart.scala 134:23]
        dataReg <= io.in.bits @[Uart.scala 135:15]
        stateReg <= UInt<1>("h1") @[Uart.scala 136:16]
    else :
      when io.out.ready : @[Uart.scala 139:24]
        stateReg <= UInt<1>("h0") @[Uart.scala 140:16]
    io.out.bits <= dataReg @[Uart.scala 143:15]

  module BufferedTx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    inst tx of Tx @[Uart.scala 156:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[Uart.scala 157:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= io.channel @[Uart.scala 159:13]
    tx.io.channel <= buf.io.out @[Uart.scala 160:17]
    io.txd <= tx.io.txd @[Uart.scala 161:10]

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
    io.channel.bits <= shiftReg @[Uart.scala 111:19]
    io.channel.valid <= validReg @[Uart.scala 112:20]

  module Echo :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip rxd : UInt<1>}

    inst tx of BufferedTx @[Uart.scala 199:18]
    tx.clock <= clock
    tx.reset <= reset
    inst rx of Rx @[Uart.scala 200:18]
    rx.clock <= clock
    rx.reset <= reset
    io.txd <= tx.io.txd @[Uart.scala 201:10]
    rx.io.rxd <= io.rxd @[Uart.scala 202:13]
    tx.io.channel <= rx.io.channel @[Uart.scala 203:17]

  module UartMain :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip rxd : UInt<1>, txd : UInt<1>}

    inst e of Echo @[Uart.scala 219:19]
    e.clock <= clock
    e.reset <= reset
    e.io.rxd <= io.rxd @[Uart.scala 220:14]
    io.txd <= e.io.txd @[Uart.scala 221:12]

