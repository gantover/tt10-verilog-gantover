circuit tt_um_gantover_XORCipher :
  module Tx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg shiftReg : UInt, clock with :
      reset => (reset, UInt<11>("h7ff")) @[Uart.scala 33:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Uart.scala 34:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Uart.scala 35:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 37:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[Uart.scala 37:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[Uart.scala 37:40]
    io.channel.ready <= _io_channel_ready_T_2 @[Uart.scala 37:20]
    node _io_txd_T = bits(shiftReg, 0, 0) @[Uart.scala 39:21]
    io.txd <= _io_txd_T @[Uart.scala 39:10]
    node _T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 41:15]
    when _T : @[Uart.scala 41:24]
      cntReg <= UInt<13>("h1457") @[Uart.scala 43:12]
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 44:18]
      when _T_1 : @[Uart.scala 44:27]
        node shift = shr(shiftReg, 1) @[Uart.scala 45:28]
        node _shiftReg_T = bits(shift, 9, 0) @[Uart.scala 46:31]
        node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[Uart.scala 46:23]
        shiftReg <= _shiftReg_T_1 @[Uart.scala 46:16]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 47:26]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 47:26]
        bitsReg <= _bitsReg_T_1 @[Uart.scala 47:15]
      else :
        when io.channel.valid : @[Uart.scala 49:30]
          node _shiftReg_T_2 = cat(UInt<2>("h3"), io.channel.bits) @[Uart.scala 51:25]
          node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[Uart.scala 51:44]
          shiftReg <= _shiftReg_T_3 @[Uart.scala 51:18]
          bitsReg <= UInt<4>("hb") @[Uart.scala 52:17]
        else :
          shiftReg <= UInt<11>("h7ff") @[Uart.scala 54:18]
    else :
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 59:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 59:22]
      cntReg <= _cntReg_T_1 @[Uart.scala 59:12]

  module Rx :
    input clock : Clock
    input reset : Reset
    output io : { flip rxd : UInt<1>, channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg rxReg_REG : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 83:30]
    rxReg_REG <= io.rxd @[Uart.scala 83:30]
    reg rxReg : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 83:22]
    rxReg <= rxReg_REG @[Uart.scala 83:22]
    reg shiftReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 85:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Uart.scala 86:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Uart.scala 87:24]
    reg validReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 88:25]
    node _T = neq(cntReg, UInt<1>("h0")) @[Uart.scala 90:15]
    when _T : @[Uart.scala 90:24]
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 91:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 91:22]
      cntReg <= _cntReg_T_1 @[Uart.scala 91:12]
    else :
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 92:23]
      when _T_1 : @[Uart.scala 92:32]
        cntReg <= UInt<13>("h1457") @[Uart.scala 93:12]
        node _shiftReg_T = shr(shiftReg, 1) @[Uart.scala 94:36]
        node _shiftReg_T_1 = cat(rxReg, _shiftReg_T) @[Uart.scala 94:23]
        shiftReg <= _shiftReg_T_1 @[Uart.scala 94:14]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 95:24]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 95:24]
        bitsReg <= _bitsReg_T_1 @[Uart.scala 95:13]
        node _T_2 = eq(bitsReg, UInt<1>("h1")) @[Uart.scala 97:18]
        when _T_2 : @[Uart.scala 97:27]
          validReg <= UInt<1>("h1") @[Uart.scala 98:16]
      else :
        node _T_3 = eq(rxReg, UInt<1>("h0")) @[Uart.scala 100:21]
        when _T_3 : @[Uart.scala 100:30]
          cntReg <= UInt<13>("h1e84") @[Uart.scala 102:12]
          bitsReg <= UInt<4>("h8") @[Uart.scala 103:13]
    node _T_4 = and(validReg, io.channel.ready) @[Uart.scala 106:17]
    when _T_4 : @[Uart.scala 106:38]
      validReg <= UInt<1>("h0") @[Uart.scala 107:14]
    io.channel.bits <= shiftReg @[Uart.scala 111:19]
    io.channel.valid <= validReg @[Uart.scala 112:20]

  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Uart.scala 125:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Uart.scala 126:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 128:27]
    io.in.ready <= _io_in_ready_T @[Uart.scala 128:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Uart.scala 129:28]
    io.out.valid <= _io_out_valid_T @[Uart.scala 129:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 131:17]
    when _T : @[Uart.scala 131:28]
      when io.in.valid : @[Uart.scala 132:23]
        dataReg <= io.in.bits @[Uart.scala 133:15]
        stateReg <= UInt<1>("h1") @[Uart.scala 134:16]
    else :
      when io.out.ready : @[Uart.scala 137:24]
        stateReg <= UInt<1>("h0") @[Uart.scala 138:16]
    io.out.bits <= dataReg @[Uart.scala 141:15]

  module Handle :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip rxd : UInt<1>, flip updateKey : UInt<1>}

    inst tx of Tx @[Uart.scala 151:18]
    tx.clock <= clock
    tx.reset <= reset
    inst rx of Rx @[Uart.scala 152:18]
    rx.clock <= clock
    rx.reset <= reset
    reg key : UInt<8>, clock with :
      reset => (reset, UInt<8>("h55")) @[Uart.scala 153:20]
    reg updateKey : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[Uart.scala 154:26]
    updateKey <= io.updateKey @[Uart.scala 155:13]
    inst buf of Buffer @[Uart.scala 157:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= rx.io.channel @[Uart.scala 158:13]
    node _tx_io_channel_bits_T = xor(buf.io.out.bits, key) @[Uart.scala 159:41]
    tx.io.channel.bits <= _tx_io_channel_bits_T @[Uart.scala 159:22]
    tx.io.channel.valid <= buf.io.out.valid @[Uart.scala 160:23]
    buf.io.out.ready <= tx.io.channel.ready @[Uart.scala 161:20]
    when updateKey : @[Uart.scala 164:20]
      when buf.io.out.valid : @[Uart.scala 165:29]
        buf.io.out.ready <= UInt<1>("h1") @[Uart.scala 166:24]
        key <= buf.io.out.bits @[Uart.scala 167:11]
        updateKey <= UInt<1>("h0") @[Uart.scala 168:17]
    io.txd <= tx.io.txd @[Uart.scala 172:10]
    rx.io.rxd <= io.rxd @[Uart.scala 173:13]

  module tt_um_gantover_XORCipher :
    input ui_in : UInt<8>
    output uo_out : UInt<8>
    input uio_in : UInt<8>
    output uio_out : UInt<8>
    output uio_oe : UInt<8>
    input ena : UInt<1>
    input clk : Clock
    input rst_n : UInt<1>

    node ___T = and(uio_in, ui_in) @[Uart.scala 187:18]
    node ___T_1 = and(___T, UInt<8>("h0")) @[Uart.scala 187:26]
    node ___T_2 = cat(ena, UInt<7>("h0")) @[Uart.scala 187:44]
    node _ = and(___T_1, ___T_2) @[Uart.scala 187:37]
    uio_out <= UInt<1>("h0") @[Uart.scala 188:11]
    uio_oe <= UInt<1>("h0") @[Uart.scala 189:10]
    wire rxd : UInt<1> @[Uart.scala 192:17]
    wire txd : UInt<1> @[Uart.scala 193:17]
    node _rxd_T = bits(ui_in, 7, 7) @[Uart.scala 194:15]
    rxd <= _rxd_T @[Uart.scala 194:7]
    node _uo_out_T = bits(txd, 0, 0) @[Uart.scala 195:31]
    node _uo_out_T_1 = cat(UInt<7>("h0"), _uo_out_T) @[Cat.scala 31:58]
    uo_out <= _uo_out_T_1 @[Uart.scala 195:10]
    inst e of Handle @[Uart.scala 197:48]
    e.clock <= clk
    e.reset <= rst_n
    e.io.rxd <= rxd @[Uart.scala 198:12]
    txd <= e.io.txd @[Uart.scala 199:7]
    node _e_io_updateKey_T = bits(ui_in, 0, 0) @[Uart.scala 200:26]
    e.io.updateKey <= _e_io_updateKey_T @[Uart.scala 200:18]

