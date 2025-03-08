circuit tt_um_UartMain :
  module Tx :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg shiftReg : UInt, clock with :
      reset => (reset, UInt<11>("h7ff")) @[Main.scala 33:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Main.scala 34:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Main.scala 35:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[Main.scala 37:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[Main.scala 37:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[Main.scala 37:40]
    io.channel.ready <= _io_channel_ready_T_2 @[Main.scala 37:20]
    node _io_txd_T = bits(shiftReg, 0, 0) @[Main.scala 39:21]
    io.txd <= _io_txd_T @[Main.scala 39:10]
    node _T = eq(cntReg, UInt<1>("h0")) @[Main.scala 41:15]
    when _T : @[Main.scala 41:24]
      cntReg <= UInt<13>("h1457") @[Main.scala 43:12]
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Main.scala 44:18]
      when _T_1 : @[Main.scala 44:27]
        node shift = shr(shiftReg, 1) @[Main.scala 45:28]
        node _shiftReg_T = bits(shift, 9, 0) @[Main.scala 46:31]
        node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[Main.scala 46:23]
        shiftReg <= _shiftReg_T_1 @[Main.scala 46:16]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Main.scala 47:26]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Main.scala 47:26]
        bitsReg <= _bitsReg_T_1 @[Main.scala 47:15]
      else :
        when io.channel.valid : @[Main.scala 49:30]
          node _shiftReg_T_2 = cat(UInt<2>("h3"), io.channel.bits) @[Main.scala 51:25]
          node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[Main.scala 51:44]
          shiftReg <= _shiftReg_T_3 @[Main.scala 51:18]
          bitsReg <= UInt<4>("hb") @[Main.scala 52:17]
        else :
          shiftReg <= UInt<11>("h7ff") @[Main.scala 54:18]
    else :
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Main.scala 59:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Main.scala 59:22]
      cntReg <= _cntReg_T_1 @[Main.scala 59:12]

  module Rx :
    input clock : Clock
    input reset : Reset
    output io : { flip rxd : UInt<1>, channel : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg rxReg_REG : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Main.scala 83:30]
    rxReg_REG <= io.rxd @[Main.scala 83:30]
    reg rxReg : UInt, clock with :
      reset => (reset, UInt<1>("h1")) @[Main.scala 83:22]
    rxReg <= rxReg_REG @[Main.scala 83:22]
    reg shiftReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Main.scala 85:25]
    reg cntReg : UInt<20>, clock with :
      reset => (reset, UInt<20>("h0")) @[Main.scala 86:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Main.scala 87:24]
    reg validReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Main.scala 88:25]
    node _T = neq(cntReg, UInt<1>("h0")) @[Main.scala 90:15]
    when _T : @[Main.scala 90:24]
      node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Main.scala 91:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[Main.scala 91:22]
      cntReg <= _cntReg_T_1 @[Main.scala 91:12]
    else :
      node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Main.scala 92:23]
      when _T_1 : @[Main.scala 92:32]
        cntReg <= UInt<13>("h1457") @[Main.scala 93:12]
        node _shiftReg_T = shr(shiftReg, 1) @[Main.scala 94:36]
        node _shiftReg_T_1 = cat(rxReg, _shiftReg_T) @[Main.scala 94:23]
        shiftReg <= _shiftReg_T_1 @[Main.scala 94:14]
        node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Main.scala 95:24]
        node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Main.scala 95:24]
        bitsReg <= _bitsReg_T_1 @[Main.scala 95:13]
        node _T_2 = eq(bitsReg, UInt<1>("h1")) @[Main.scala 97:18]
        when _T_2 : @[Main.scala 97:27]
          validReg <= UInt<1>("h1") @[Main.scala 98:16]
      else :
        node _T_3 = eq(rxReg, UInt<1>("h0")) @[Main.scala 100:21]
        when _T_3 : @[Main.scala 100:30]
          cntReg <= UInt<13>("h1e84") @[Main.scala 102:12]
          bitsReg <= UInt<4>("h8") @[Main.scala 103:13]
    node _T_4 = and(validReg, io.channel.ready) @[Main.scala 106:17]
    when _T_4 : @[Main.scala 106:38]
      validReg <= UInt<1>("h0") @[Main.scala 107:14]
    io.channel.bits <= shiftReg @[Main.scala 111:19]
    io.channel.valid <= validReg @[Main.scala 112:20]

  module Buffer :
    input clock : Clock
    input reset : Reset
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}

    reg stateReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Main.scala 125:25]
    reg dataReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Main.scala 126:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Main.scala 128:27]
    io.in.ready <= _io_in_ready_T @[Main.scala 128:15]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Main.scala 129:28]
    io.out.valid <= _io_out_valid_T @[Main.scala 129:16]
    node _T = eq(stateReg, UInt<1>("h0")) @[Main.scala 131:17]
    when _T : @[Main.scala 131:28]
      when io.in.valid : @[Main.scala 132:23]
        dataReg <= io.in.bits @[Main.scala 133:15]
        stateReg <= UInt<1>("h1") @[Main.scala 134:16]
    else :
      when io.out.ready : @[Main.scala 137:24]
        stateReg <= UInt<1>("h0") @[Main.scala 138:16]
    io.out.bits <= dataReg @[Main.scala 141:15]

  module Handle :
    input clock : Clock
    input reset : Reset
    output io : { txd : UInt<1>, flip rxd : UInt<1>, flip updateKey : UInt<1>}

    inst tx of Tx @[Main.scala 151:18]
    tx.clock <= clock
    tx.reset <= reset
    inst rx of Rx @[Main.scala 152:18]
    rx.clock <= clock
    rx.reset <= reset
    reg key : UInt<8>, clock with :
      reset => (reset, UInt<8>("h55")) @[Main.scala 153:20]
    reg updateKey : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Main.scala 154:26]
    node _T = eq(io.updateKey, UInt<1>("h1")) @[Main.scala 155:21]
    when _T : @[Main.scala 155:30]
      updateKey <= UInt<1>("h1") @[Main.scala 156:15]
    inst buf of Buffer @[Main.scala 159:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in <= rx.io.channel @[Main.scala 160:13]
    node _tx_io_channel_bits_T = xor(buf.io.out.bits, key) @[Main.scala 161:41]
    tx.io.channel.bits <= _tx_io_channel_bits_T @[Main.scala 161:22]
    tx.io.channel.valid <= buf.io.out.valid @[Main.scala 162:23]
    buf.io.out.ready <= tx.io.channel.ready @[Main.scala 163:20]
    when updateKey : @[Main.scala 166:20]
      when buf.io.out.valid : @[Main.scala 167:29]
        buf.io.out.ready <= UInt<1>("h1") @[Main.scala 168:24]
        key <= buf.io.out.bits @[Main.scala 169:11]
        updateKey <= UInt<1>("h0") @[Main.scala 170:17]
    io.txd <= tx.io.txd @[Main.scala 174:10]
    rx.io.rxd <= io.rxd @[Main.scala 175:13]

  module tt_um_UartMain :
    input ui_in : UInt<8>
    output uo_out : UInt<8>
    input uio_in : UInt<8>
    output uio_out : UInt<8>
    output uio_oe : UInt<8>
    input ena : UInt<1>
    input clk : Clock
    input rst_n : UInt<1>

    node ___T = and(uio_in, ui_in) @[Main.scala 189:18]
    node ___T_1 = and(___T, UInt<8>("h0")) @[Main.scala 189:26]
    node ___T_2 = cat(ena, UInt<7>("h0")) @[Main.scala 189:44]
    node _ = and(___T_1, ___T_2) @[Main.scala 189:37]
    uio_out <= UInt<1>("h0") @[Main.scala 190:11]
    uio_oe <= UInt<1>("h0") @[Main.scala 191:10]
    wire rxd : UInt<1> @[Main.scala 194:17]
    wire txd : UInt<1> @[Main.scala 195:17]
    node _rxd_T = bits(ui_in, 7, 7) @[Main.scala 196:15]
    rxd <= _rxd_T @[Main.scala 196:7]
    node _uo_out_T = bits(txd, 0, 0) @[Main.scala 197:31]
    node _uo_out_T_1 = cat(UInt<7>("h0"), _uo_out_T) @[Cat.scala 31:58]
    uo_out <= _uo_out_T_1 @[Main.scala 197:10]
    inst e of Handle @[Main.scala 199:48]
    e.clock <= clk
    e.reset <= rst_n
    e.io.rxd <= rxd @[Main.scala 200:12]
    txd <= e.io.txd @[Main.scala 201:7]
    node _e_io_updateKey_T = bits(ui_in, 0, 0) @[Main.scala 202:26]
    e.io.updateKey <= _e_io_updateKey_T @[Main.scala 202:18]

