/*
 * Copyright: 2014-2018, Technical University of Denmark, DTU Compute
 * Author: Martin Schoeberl (martin@jopdesign.com)
 * License: Simplified BSD License
 *
 * A UART is a serial port, also called an RS232 interface.
 * 
 * Was modified to incorporate XOR Cipher
 */

package XORCipher 

import chisel3._
import chisel3.util._

class UartIO extends DecoupledIO(UInt(8.W)) {
}

/**
  * Transmit part of the UART.
  * A minimal version without any additional buffering.
  * Use a ready/valid handshaking.
  */
//- start uart_tx
class Tx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = Flipped(new UartIO()) // used to load the message into a tx buffer
  })

  val BIT_CNT = ((frequency + baudRate / 2) / baudRate - 1).asUInt

  val shiftReg = RegInit(0x7ff.U)
  val cntReg = RegInit(0.U(20.W))
  val bitsReg = RegInit(0.U(4.W))

  io.channel.ready := (cntReg === 0.U) && (bitsReg === 0.U) // ready to receive when there is no bit left to send (bitsReg) and
  // everything happens only on cntReg==0, the local clock
  io.txd := shiftReg(0)

  when(cntReg === 0.U) {

    cntReg := BIT_CNT
    when(bitsReg =/= 0.U) {
      val shift = shiftReg >> 1
      shiftReg := 1.U ## shift(9, 0)
      bitsReg := bitsReg - 1.U
    } .otherwise {
      when(io.channel.valid) { // valid is external, comes from the unit that will give the data to fill into the buffer
        // two stop bits, data, one start bit
        shiftReg := 3.U ## io.channel.bits ## 0.U
        bitsReg := 11.U
      } .otherwise {
        shiftReg := 0x7ff.U
      }
    }

  } .otherwise {
    cntReg := cntReg - 1.U
  }
}
//- end

/**
  * Receive part of the UART.
  * A minimal version without any additional buffering.
  * Use a ready/valid handshaking.
  *
  * The following code is inspired by Tommy's receive code at:
  * https://github.com/tommythorn/yarvi
  */
//- start uart_rx
class Rx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val rxd = Input(UInt(1.W))
    val channel = new UartIO()
  })

  val BIT_CNT = ((frequency + baudRate / 2) / baudRate - 1).U
  val START_CNT = ((3 * frequency / 2 + baudRate / 2) / baudRate - 1).U

  // Sync in the asynchronous RX data, reset to 1 to not start reading after a reset
  val rxReg = RegNext(RegNext(io.rxd, 1.U), 1.U)

  val shiftReg = RegInit(0.U(8.W))
  val cntReg = RegInit(0.U(20.W))
  val bitsReg = RegInit(0.U(4.W))
  val validReg = RegInit(false.B)

  when(cntReg =/= 0.U) {
    cntReg := cntReg - 1.U
  } .elsewhen(bitsReg =/= 0.U) {
    cntReg := BIT_CNT
    shiftReg := rxReg ## (shiftReg >> 1)
    bitsReg := bitsReg - 1.U
    // the last bit shifted in
    when(bitsReg === 1.U) {
      validReg := true.B
    }
  } .elsewhen(rxReg === 0.U) {
    // wait 1.5 bits after falling edge of start
    cntReg := START_CNT
    bitsReg := 8.U
  }

  when(validReg && io.channel.ready) {
    validReg := false.B // when the the reg is valid to be read
    // it only stays valid for one clock cycle because, this is what i can use for my fifo
  }

  io.channel.bits := shiftReg
  io.channel.valid := validReg
}

/**
  * A single byte buffer with a ready/valid interface
  */
class Buffer extends Module {
  val io = IO(new Bundle {
    val in = Flipped(new UartIO())
    val out = new UartIO()
  })

  val empty :: full :: Nil = Enum(2)
  val stateReg = RegInit(empty)
  val dataReg = RegInit(0.U(8.W))

  io.in.ready := stateReg === empty
  io.out.valid := stateReg === full

  when(stateReg === empty) {
    when(io.in.valid) {
      dataReg := io.in.bits
      stateReg := full
    }
  } .otherwise { // full
    when(io.out.ready) {
      stateReg := empty
    }
  }
  io.out.bits := dataReg
}


class Handle(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val rxd = Input(UInt(1.W))
    val updateKey = Input(UInt(1.W))
  })
  val tx = Module(new Tx(frequency, baudRate))
  val rx = Module(new Rx(frequency, baudRate))
  val key = RegInit("b01010101".U(8.W))
  val updateKey = RegInit(false.B)
  when(io.updateKey === 1.U) {
    updateKey := true.B
  }

  val buf = Module(new Buffer())
  buf.io.in <> rx.io.channel
  tx.io.channel.bits := buf.io.out.bits ^ key
  tx.io.channel.valid := buf.io.out.valid
  buf.io.out.ready := tx.io.channel.ready
  

  when (updateKey) {
    when (buf.io.out.valid) {
      buf.io.out.ready := true.B
      key := buf.io.out.bits
      updateKey := false.B
    }
  }

  io.txd := tx.io.txd
  rx.io.rxd := io.rxd
}

class tt_um_UartMain(frequency: Int, baudRate: Int) extends RawModule {
  val ui_in = IO(Input(UInt(8.W)))
  val uo_out = IO(Output(UInt(8.W)))
  val uio_in = IO(Input(UInt(8.W)))
  val uio_out = IO(Output(UInt(8.W)))
  val uio_oe = IO(Output(UInt(8.W)))
  val ena = IO(Input(UInt(1.W)))
  val clk = IO(Input(Clock()))
  val rst_n = IO(Input(Bool()))

  // handle unused signals to remove warnings
  val _ = uio_in & ui_in & 0.U(8.W) & (ena ## 0.U(7.W))
  uio_out := 0.U
  uio_oe := 0.U

  // define rxd and txd for clarity
  val rxd = Wire(UInt(1.W))
  val txd = Wire(UInt(1.W))
  rxd := ui_in(7)
  uo_out := Cat(0.U(7.W), txd.asBool)

  val e = withClockAndReset(clk, rst_n){ Module(new Handle(frequency, baudRate)) }
  e.io.rxd := rxd
  txd := e.io.txd
  e.io.updateKey := ui_in(0)
}

// A wrapper to only expose used hardware pins
class Wrapper(frequency: Int, baudRate: Int) extends RawModule {
  val rxd = IO(Input(UInt(1.W)))
  val txd = IO(Output(UInt(1.W)))
  val clk = IO(Input(Clock()))
  val rst_n = IO(Input(Bool()))
  val updateKey = IO(Input(UInt(1.W)))
  val device = Module(new tt_um_UartMain(frequency, baudRate))
  device.clk := clk
  device.rst_n := rst_n
  device.ui_in := Cat(rxd, 0.U(6.W), updateKey)
  device.uio_in := 0.U
  device.ena := 0.U
  txd := device.uo_out(0)
}

object tt_um_UartMain extends App {
  val freq = 50000000 // 50MHz
  val baud = 9600
  emitVerilog(new tt_um_UartMain(freq, baud), Array("--target-dir", "generated"))
}

object Wrapper extends App {
  val freq = 100000000
  val baud = 9600
  emitVerilog(new Wrapper(freq, baud), Array("--target-dir", "generated"))
}