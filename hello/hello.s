.code16
.globl start

start:
    movw $message, %si
    movb $0x00, %ah
    movb $0x03, %al
    int $0x10

print_char:
    lodsb
    testb %al, %al
    jz done 
    movb $0x0E, %ah
    int $0x10
    jmp print_char
     

done:
    jmp done 

message:
    .string      "Hello World"

.fill 510 -(. -start), 1, 0

.byte 0x55
.byte 0xAA


