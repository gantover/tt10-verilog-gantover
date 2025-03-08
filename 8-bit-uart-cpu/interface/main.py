from serial import Serial

uart = Serial("/dev/ttyUSB1", 9600) 

phrase = "hello world"
encrypted_phrase = ""

for letter in phrase:
    uart.write(letter.encode('utf-8'))
    encrypted_phrase += uart.read(1).decode('utf-8')

print(encrypted_phrase)

decrypted_phrase = ""
for letter in encrypted_phrase:
    uart.write(letter.encode('utf-8'))
    decrypted_phrase += uart.read(1).decode('utf-8')

print(decrypted_phrase)

