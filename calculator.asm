.model small        ; small memory model: code and data fit in one segment
.stack 100h         ; 256 bytes of stack space
.data 
    ; db - defines a byte 
    ; 0dh, 0ah - Carriage Return and Line Feed for new lines in DOS (Disk Operating System)
    menu    db 0dh, 0ah, '=== Calculator Menu ==='
            db 0dh, 0ah, '1. Addition'
            db 0dh, 0ah, '2. Subtraction'
            db 0dh, 0ah, '3. Multiplication'
            db 0dh, 0ah, '4. Division'
            db 0dh, 0ah, '5. Exit'
            db 0dh, 0ah, 'Choose option: $'
    prompt1 db 0dh, 0ah, 'Enter first number: $'
    prompt2 db 0dh, 0ah, 'Enter second number: $'
    resMsg  db 0dh, 0ah, 'The Result is: $'
    errMsg  db 0dh, 0ah, 'Error: Division by zero! $'
    num1    dw 0        ; dw - defines a word (2 bytes, up to 65535)
    num2    dw 0


.code
main proc               ; main procedure - entry point of the program
    mov ax, @data       ; load the data segment address into AX
    mov ds, ax          ; initialize the data segment register with the address of the data
    jmp do_menu


do_menu:
    ; Display Menu
    mov ah, 09h         ; DOS function to display a string
    lea dx, menu        ; Load the address of the menu string into DX
    int 21h             ; Call DOS interrupt to display the menu

    ; Get Menu Choice
    mov ah, 01h         ; DOS function to read a single character from the keyboard
    int 21h
    mov bl, al          ; Save choice ('1', '2', or '3') in BL

    cmp bl, '5'
    je exit              ; If user chooses '5', exit the program

    ; getting the first number from the user and storing it in num1
    mov ah, 09h
    lea dx, prompt1
    int 21h
    call read_number
    mov num1, ax        ; Store the result in num1

    ; getting the second number from the user and storing it in num2
    mov ah, 09h
    lea dx, prompt2
    int 21h
    call read_number
    mov num2, ax        ; Store the result in num2
    
    ; Determine which operation to perform based on the user's choice
    cmp bl, '1' 
    je do_add
    cmp bl, '2'
    je do_sub
    cmp bl, '3'
    je do_mul
    cmp bl, '4'
    je do_div
    cmp bl, '5'
    je exit

    
do_add:
    mov ax, num1
    add ax, num2
    jmp display_result

do_sub:
    mov ax, num1
    sub ax, num2
    jmp display_result

do_mul:
    mov ax, num1
    mul num2            ; Multiply AX by num2 (Result in AX)
    jmp display_result

do_div:
    mov ax, num1        ; Move first number to AX
    mov dx, 0           ; Clear DX for 16-bit division
    mov bx, num2        ; Move second number to BX
    
    cmp bx, 0           ; Check for division by zero
    je error_exit       ; If num2 is 0, jump to an error message
    
    div bx              ; AX / BX -> quotient in AX and remainder in DX
    jmp display_result

display_result:
    push ax             ; Save answer
    mov ah, 09h 
    lea dx, resMsg      ; Load the address of the result message into DX
    int 21h
    pop ax              ; Restore answer
    call print_number
    jmp do_menu

error_exit:
    ; Display an error message for division by zero
    mov ah, 09h
    lea dx, errMsg
    int 21h
    jmp do_menu

exit:
    mov ax, 4C00h       ; Terminate program with return code 0
    int 21h 
main endp

read_number proc        ; Reads a number from the user and returns it in AX
    push bx             ; Save BX and CX on the stack as we will use them
    push cx
    mov bx, 0           ; BX will hold our running total
    
input_loop:
    mov ah, 01h         ; Read a character
    int 21h
    
    cmp al, 13          ; Is it the 'Enter' key (ASCII 13)?
    je input_done       ; If yes, we are finished
    
    sub al, 48          ; Convert ASCII to digit
    mov ah, 0           ; Clear AH so AX is just the digit
    mov cx, ax          ; Save digit in CX
    
    ; Total = (Total * 10) + NewDigit
    mov ax, bx
    mov dx, 10
    mul dx              ; Multiply current total by 10 (Result in AX)
    add ax, cx          ; Add the new digit
    mov bx, ax          ; Move result back to BX
    jmp input_loop

input_done:
    mov ax, bx          ; Return the final total in AX
    pop cx
    pop bx
    ret
read_number endp


print_number proc
    mov cx, 0
    mov bx, 10
split_digits:
    mov dx, 0           ; Clear DX for 16-bit division
    div bx              ; AX / 10 -> AX=Quotient, DX=Remainder
    push dx             ; Push remainder to stack
    inc cx
    cmp ax, 0
    jne split_digits
print_loop:
    pop dx
    add dl, 48
    mov ah, 02h
    int 21h
    loop print_loop
    ret
print_number endp

end main