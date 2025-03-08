<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

You send a char via a uart port (8bit data, no partity bit) and it sends an "encrypted" char back

You will have to maintain an up signal on the updateKey port while sending the 8 bit char that will be used as key.
The default key is b10101010.

## How to test

A python file containing a code to communicate with the serial port may be transformed to work with the TT board.

## External hardware

It requires an input clock of 50Mhz

It has two inputs :
ui[0]: "updateKey"
ui[7]: "rx"

and one output
uo[0]: "tx"