.code16
.global start

start:

    movw $0x00, %ax
    movw $0x00, %bx
    movw $0x00, %cx
    movw $0x00, %dx 
    call print_new_line
    movw $op_one_msg, %si       #loads the first msg into %si
    call print_mes
    movb $0x00, %ah             #0x00 - set video mode
    movb $0x03, %al             #0x03 - 80x25 text mode
    int $0x10                   #Call into the BIOS
    
    
print_mes:
    lodsb                       #loads a single byte from [si] into al and increments si                      
    testb %al, %al              #checks to see if the byte is 0
    jz input1 
    movb $0x0E, %ah
    int $0x10
    jmp print_mes

input1:
    
    movb $0x00, %al     #clear 
    movb $0x00, %ah     #take input
    int $0x16 
    
    movb $0x0e, %ah     #display input
    int $0x10

    cmp $0x71, %al     #if input == q
    je done

    movb %al, %bl       #mov input 1 to bl
   
    call print_new_line

mes2:
    movw $op_two_msg, %si       #loads the first msg into %si
    call print_mes2
    movb $0x00, %ah             #0x00 - set video mode
    movb $0x03, %al             #0x03 - 80x25 text mode
    int $0x10                   #Call into the BIOS
    
    
print_mes2:
    lodsb                       #loads a single byte from [si] into al and increments si                      
    testb %al, %al              #checks to see if the byte is 0
    jz input2 
    movb $0x0E, %ah
    int $0x10
    jmp print_mes2

input2:
    
    movb $0x00, %al     #clear 
    movb $0x00, %ah     #take input
    int $0x16 
    
    movb $0x0e, %ah     #display input
    int $0x10

    cmp $0x71, %al     #if input == q
    je done

    movb %al, %cl       #mov input 2 to cl
   
    call print_new_line
    

mes3:
    movw $operator_msg, %si       #loads the first msg into %si
    call print_mes3
    movb $0x00, %ah             #0x00 - set video mode
    movb $0x03, %al             #0x03 - 80x25 text mode
    int $0x10                   #Call into the BIOS
    
    
print_mes3:
    lodsb                       #loads a single byte from [si] into al and increments si                      
    testb %al, %al              #checks to see if the byte is 0
    jz input3 
    movb $0x0E, %ah
    int $0x10
    jmp print_mes3

input3:
    movb $0x00, %al     #clear 
    movb $0x00, %ah     #take input
    int $0x16 
    
    movb $0x0e, %ah     #display input
    int $0x10

    cmp $0x71, %al     #if input == q
    je done

    movb %al, %dl       #mov input operand to dl

    

    call print_new_line
    
    cmp $0x2b, %dl    #if add
    je add

    cmp $0x2d, %dl    #sub
    je sub

    cmp $0x2A, %dl    #mult
    je mult

    cmp $0x2f, %dl    #div 
    je div


    call print_new_line

answer_mes:
    movw $ans_msg, %si       #loads the first msg into %si
    call print_answer_mes
    movb $0x00, %ah             #0x00 - set video mode
    movb $0x03, %al             #0x03 - 80x25 text mode
    int $0x10    

print_answer_mes:
    lodsb                       #loads a single byte from [si] into al and increments si                      
    testb %al, %al              #checks to see if the byte is 0
    jz print_value
    movb $0x0E, %ah
    int $0x10
    jmp print_answer_mes

print_value:
    #movb %dl, %al
    #movb $0x0e, %ah     #display input
    #int $0x10
    
    movw $0x00, %ax 
    movb $0x09, %al 
    cmp %al, %dl

    ja print_two_digits 


    movw $0x00, %ax 
    movb %dl, %al
    addb $0x30, %al
    movb $0x0e, %ah
    int $0x10


    
    call print_new_line
    jmp start



    

print_two_digits:
    mov %dx, %ax 
    movb $10, %cl
    idiv %cl

    movb %ah, %dl 
    add $0x30, %al
    movb $0x0e, %ah 
    int $0x10

    movb %dl, %al
    addb $0x30, %al 
    movb $0x0e, %ah 
    int $0x10

    call print_new_line
    jmp start 

next:
    jmp done 

 





print_new_line:
    movb $0x0d,%al      #new line
    movb $0x0e,%ah      # print character
    int $0x10           #Print newline character
    movb $0x0a, %al     #new line
    movb $0x0E, %ah     #Set bios interrupt to print
    int $0x10           #Print newline character
    ret

add:
    subb $0x30, %bl
    subb $0x30, %cl
    addb %bl, %cl        #first operand in bl second in cl
    
    

    movb %cl, %dl
    movw $0x00, %ax
    movw $0x00, %bx
    movw $0x00, %cx
    
    jmp answer_mes

sub:
    movw $0x00, %dx
    subb $0x30, %bl
    subb $0x30, %cl

    subb %cl, %bl
    
    movb %bl, %dl

    movw $0x00, %ax
    movw $0x00, %bx
    movw $0x00, %cx
    jmp answer_mes

mult:
    movw $0x00, %dx
    subb $0x30, %bl
    subb $0x30, %cl

    #movb $0x00, %ax
    #movb $0x00, %bx
    #movw %bx, %ax
    #movb $0x00, %bx
    #movw %cx, %bx
    #imul %ax, %bx
    
    imul %cx, %bx
    #addb $0x30, %bx 
    movb %bl, %dl

    movw $0x00, %ax
    movw $0x00, %bx
    movw $0x00, %cx
    jmp answer_mes

div:
    movw $0x00, %dx
                                 #first operand in bl second in c
    subb $0x30, %bl
    subb $0x30, %cl
    movw $0x00, %ax
    movw %bx, %ax                #    movw %bl, %ax
    
    
    idiv %cl                     #    idiv %cl
    movw $0x00, %bx
    movb %al, %dl                #    movb %cl, %dl

    movw $0x00, %ax
    movw $0x00, %bx
    movw $0x00, %cx
    jmp answer_mes



done:
    jmp done 

# Pre-defined strings
op_one_msg:
	.string		"Input operand1: "

op_two_msg:
	.string		"Input operand2: "

operator_msg:
	.string		"Input operator: "

ans_msg:
	.string		"The answer is: "



# Make sure the file is of the correct size
# What does a file of this end with?

.fill 510 -(. -start), 1, 0

.byte 0x55
.byte 0xAA


