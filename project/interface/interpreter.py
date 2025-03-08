from serial import Serial

uart = Serial("/dev/ttyUSB1", 9600) 

while True:
    c = input()
    uart.write(c.encode('utf-8'))
    print(uart.read(1).decode('utf-8'))
