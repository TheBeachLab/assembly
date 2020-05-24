# Assembly with arduino

## Connection

Connect the Arduino board to the usbtiny programmer as shown in the picture.


## Compile the program

`gavrasm hello.asm`

## Upload the `hex` file

`sudo avrdude -p m328p -P usb -c usbtiny -U flash:w:hello.hex`
