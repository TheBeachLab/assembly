# Assembly with arduino board

## Get ready

- Install `avrdude` and get `avra` or `gavrasm` compiler
- Connect the Arduino board to the usbtiny programmer as shown in the picture below.
![isp](isp2.jpg)
- Compile the program `gavrasm hello.asm`
- Upload the `hex` file `sudo avrdude -p m328p -P usb -c usbtiny -U flash:w:hello.hex`

## Arduino pinout

![pinout](uno.jpg)
