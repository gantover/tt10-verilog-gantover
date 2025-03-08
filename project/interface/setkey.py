from serial import Serial

uart = Serial("/dev/ttyUSB1", 9600) 

uart.write("U".encode('utf-8'))
