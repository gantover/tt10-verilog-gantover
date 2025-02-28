circuit UartFifo :
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

  module BufferedTx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    inst tx of Tx @[Uart.scala 157:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[Uart.scala 158:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= io.channel @[Uart.scala 160:13]
    tx.io.channel <= buf.io.out @[Uart.scala 161:17]
    io.txd <= tx.io.txd @[Uart.scala 162:10]

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

  module RegFifo :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg memReg : UInt<8>[4], clock with :
      reset => (UInt<1>("h0"), memReg) @[RegFifo.scala 21:19]
    wire incrRead : UInt<1>
    incrRead <= UInt<1>("h0")
    wire incrWrite : UInt<1>
    incrWrite <= UInt<1>("h0")
    reg readPtr : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[RegFifo.scala 12:25]
    node _nextVal_T = eq(readPtr, UInt<2>("h3")) @[RegFifo.scala 13:30]
    node _nextVal_T_1 = add(readPtr, UInt<1>("h1")) @[RegFifo.scala 13:59]
    node _nextVal_T_2 = tail(_nextVal_T_1, 1) @[RegFifo.scala 13:59]
    node nextRead = mux(_nextVal_T, UInt<1>("h0"), _nextVal_T_2) @[RegFifo.scala 13:22]
    when incrRead : @[RegFifo.scala 14:17]
      readPtr <= nextRead @[RegFifo.scala 15:14]
    reg writePtr : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[RegFifo.scala 12:25]
    node _nextVal_T_3 = eq(writePtr, UInt<2>("h3")) @[RegFifo.scala 13:30]
    node _nextVal_T_4 = add(writePtr, UInt<1>("h1")) @[RegFifo.scala 13:59]
    node _nextVal_T_5 = tail(_nextVal_T_4, 1) @[RegFifo.scala 13:59]
    node nextWrite = mux(_nextVal_T_3, UInt<1>("h0"), _nextVal_T_5) @[RegFifo.scala 13:22]
    when incrWrite : @[RegFifo.scala 14:17]
      writePtr <= nextWrite @[RegFifo.scala 15:14]
    reg emptyReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[RegFifo.scala 28:25]
    reg fullReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[RegFifo.scala 29:24]
    node _T = eq(fullReg, UInt<1>("h0")) @[RegFifo.scala 31:25]
    node _T_1 = and(io.enq.valid, _T) @[RegFifo.scala 31:22]
    when _T_1 : @[RegFifo.scala 31:35]
      memReg[writePtr] <= io.enq.bits @[RegFifo.scala 32:22]
      emptyReg <= UInt<1>("h0") @[RegFifo.scala 33:14]
      node _fullReg_T = eq(nextWrite, readPtr) @[RegFifo.scala 34:26]
      fullReg <= _fullReg_T @[RegFifo.scala 34:13]
      incrWrite <= UInt<1>("h1") @[RegFifo.scala 35:15]
    node _T_2 = eq(emptyReg, UInt<1>("h0")) @[RegFifo.scala 38:25]
    node _T_3 = and(io.deq.ready, _T_2) @[RegFifo.scala 38:22]
    node _T_4 = and(_T_3, fullReg) @[RegFifo.scala 38:35]
    when _T_4 : @[RegFifo.scala 38:47]
      fullReg <= UInt<1>("h0") @[RegFifo.scala 39:13]
      node _emptyReg_T = eq(nextRead, writePtr) @[RegFifo.scala 40:26]
      emptyReg <= _emptyReg_T @[RegFifo.scala 40:14]
      incrRead <= UInt<1>("h1") @[RegFifo.scala 41:14]
    io.deq.bits <= memReg[readPtr] @[RegFifo.scala 44:15]
    node _io_enq_ready_T = eq(fullReg, UInt<1>("h0")) @[RegFifo.scala 45:19]
    io.enq.ready <= _io_enq_ready_T @[RegFifo.scala 45:16]
    node _io_deq_valid_T = eq(emptyReg, UInt<1>("h0")) @[RegFifo.scala 46:19]
    io.deq.valid <= _io_deq_valid_T @[RegFifo.scala 46:16]

  module UartFifo :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip rxd : UInt<1>, txd : UInt<1>, led_empty : UInt<1>, led_full : UInt<1>}

    inst tx of BufferedTx @[Uart.scala 234:18]
    tx.clock <= clock
    tx.reset <= reset
    inst rx of Rx @[Uart.scala 235:18]
    rx.clock <= clock
    rx.reset <= reset
    rx.io.rxd <= io.rxd @[Uart.scala 237:13]
    io.txd <= tx.io.txd @[Uart.scala 238:10]
    inst rfifo of RegFifo @[Uart.scala 240:21]
    rfifo.clock <= clock
    rfifo.reset <= reset
    rfifo.io.enq <= rx.io.channel @[Uart.scala 241:16]
    tx.io.channel <= rfifo.io.deq @[Uart.scala 242:16]
    node _io_led_full_T = eq(rfifo.io.enq.ready, UInt<1>("h0")) @[Uart.scala 243:18]
    io.led_full <= _io_led_full_T @[Uart.scala 243:15]
    node _io_led_empty_T = eq(rfifo.io.deq.valid, UInt<1>("h0")) @[Uart.scala 244:19]
    io.led_empty <= _io_led_empty_T @[Uart.scala 244:16]

