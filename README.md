# Assembly with arduino board

## Get the tools

Install `avrdude` and get `gavrasm` from [here](http://www.avr-asm-tutorial.net/gavrasm/index_en.html)

## Install vim avr syntax

Copy avr.vim to `~/.vim/syntax/`

## Connection

Connect the Arduino board to the usbtiny programmer as shown in the picture.


## Compile the program

`gavrasm hello.asm`

## Upload the `hex` file

`sudo avrdude -p m328p -P usb -c usbtiny -U flash:w:hello.hex`
