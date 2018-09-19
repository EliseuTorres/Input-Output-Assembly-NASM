;-------------------------------------------------------
; INPUT/OUTPUT FUNCTIONS
;-------------------------------------------------------

;-------------------------------------------------------
; GET SIGNED NUMBER
;-------------------------------------------------------
section .data

input_signed       db  0

section .text

get_signed_number:

    ; RESULT STORED IN RAX

    ;save contents of registers that are going to be used on the stack
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r10

    mov rax, 0                      ; read syscall
    mov rdi, 0                      ; stdin
    mov rsi, input_signed           ; holds address to store string version of number
    mov rdx, 22                     ; no. of bytes to read from stdout
    syscall

    mov rax, 0                      ; counter
    mov rcx, rdx                    ; rcx = rdx
    sub rcx, 1                      ; rcx <- rcx - 1 (1 less than number of bytes to read)

    call remove_new_line

    mov rax, 0                      ; where each character is stored
    mov rbx, 0                      ; counter - how many digits in number

    call atoi

    cmp r10, 1                      ; if '-'
    jnz exit_signed                 ; not '-'
    neg rax                         ; 2's complement

exit_signed:

    ;retrive contents of registers that were used from the stack
    pop r10
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx

    ret

;-------------------------------------------------------
; GET UNSIGNED NUMBER
;-------------------------------------------------------
section .data

input_unsigned       db  0

section .text

get_unsigned_number:

    ; RESULT STORED IN RAX

    ;save contents of registers that are going to be used on the stack
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx

    mov rax, 0                      ; read syscall
    mov rdi, 0                      ; stdin
    mov rsi, input_unsigned         ; holds address to store string version of number
    mov rdx, 21                     ; no. of bytes to read from stdout
    syscall

    mov rax, 0                      ; counter
    mov rcx, rdx                    ; rcx = rdx
    sub rcx, 1                      ; rcx <- rcx - 1 (1 less than number of bytes to read)

    call remove_new_line

    mov rax, 0                      ; where each character is stored
    mov rbx, 0                      ; counter - how many digits in number

    call atoi

    ;retrive contents of registers that were used from the stack
    pop rbx
    pop rcx
    pop rdx
    pop rsi
    pop rdi

    ret

;-------------------------------------------------------
; PRINT SIGNED NUMBER
;-------------------------------------------------------
section .data

output_int      db  0

section .text

    ; NUMBER TO BE PRINTED NEED TO BE STORED IN RAX

print_signed_number:

    ;save contents of registers that are going to be used on the stack
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r15

    rol rax, 1
    jc negative
    jmp positive

negative:
    mov r15, rax                ; save to r15(temp)
    mov rbx, 45                 ; ASCII value for '-'
    mov [output_int], bl        ; store in address pointed by output
    mov rax, 1                  ; write to terminal
    mov rdi, 1                  ; stdout
    mov rsi, output_int         ; holds address of result to be displayed
    mov rdx, 1                  ; number of bytes to be written
    syscall

    mov rax, r15                ; recall value
    ror rax, 1
    neg rax                     ; make value positive
    jmp inital

positive:
    ror rax, 1

inital:
    mov rbx, 0
    mov rcx, 0x0A
string:
    xor rdx, rdx                ; clear rdx
    div rcx                     ; rdx:rax / 10
    add rdx, 48                 ; convert to allow it to be printed
    push rdx                    ; move remainder into stack
    inc rbx                     ; increase counter
    cmp rax, 0                  ; is quotient is 0
    jnz string                  ; if not 0

print:
    pop rax                     ; get latest number pushed
    mov [output_int], al        ; store in address pointed by output
    mov rax, 1                  ; write to terminal
    mov rdi, 1                  ; stdout
    mov rsi, output_int         ; holds address of result to be displayed
    mov rdx, 1                  ; number of bytes to be written
    syscall
    dec rbx                     ; decrease counter
    cmp rbx, 0                  ; is counter is zero
    jnz print                   ; no -> continue printing

    ;retrive contents of registers that were used from the stack
    pop r15
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx

    ret

;-------------------------------------------------------
; PRINT UNSIGNED NUMBER
;-------------------------------------------------------
section .text

    ; NUMBER TO BE PRINTED NEED TO BE STORED IN RAX

print_unsigned_number:

    ;save contents of registers that are going to be used on the stack
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rbx, 0
    mov rcx, 0x0A
unsigned_string:
    xor rdx, rdx                ; clear rdx
    div rcx                     ; rdx:rax / 10
    add rdx, 48                 ; convert to allow it to be printed
    push rdx                    ; move remainder into stack
    inc rbx                     ; increase counter
    cmp rax, 0                  ; is quotient is 0
    jnz unsigned_string         ; if not 0

unsigned_print:
    pop rax                     ; get latest number pushed
    mov [output_int], al        ; store in address pointed by output
    mov rax, 1                  ; write to terminal
    mov rdi, 1                  ; stdout
    mov rsi, output_int         ; holds address of result to be displayed
    mov rdx, 1                  ; number of bytes to be written
    syscall
    dec rbx                     ; decrease counter
    cmp rbx, 0                  ; is counter is zero
    jnz unsigned_print          ; no -> continue printing

    ;retrive contents of registers that were used from the stack
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx

    ret

;-------------------------------------------------------
; GET STRING
;-------------------------------------------------------
section .text

get_string:

    ; PUSH NUMBER OF BYTES TO READ
    ; PUSH ADDRESS IN MEMORY THAT STORES THE STRING

    ;save contents of registers that are going to be used on the stack
    push rax
    push rdi
    push rsi
    push rdx
    push rcx

    mov rax, 0                          ; read syscall
    mov rdi, 0                          ; stdin
    mov rsi, [rsp + 48]                  ; holds address to store string
    mov rdx, [rsp + 56]                  ; no. of bytes to read from stdout
    syscall

    mov rax, 0                          ; counter
    mov rcx, rdx                        ; rcx = rdx
    sub rcx, 1                          ; rcx <- rcx - 1 (1 less than number of bytes to read)

    call remove_new_line

    ;retrive contents of registers that were used from the stack
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax

    ret 16                              ; clear stack

;-------------------------------------------------------
; PRINT STRING
;-------------------------------------------------------
print_string:

    ; PUSH NUMBER OF BYTES TO WRITE
    ; PUSH ADDRESS IN MEMORY THAT HAS THE STRING

    ;save contents of registers that are going to be used on the stack
    push rax
    push rcx
    push rdi
    push rsi
    push rdx

    mov rax, 1                          ; write syscall
    mov rdi, 1                          ; stdout
    mov rsi, [rsp + 48]                  ; holds address of result to be displayed
    mov rdx, [rsp + 56]                 ; number of bytes to be written
    syscall

    ;retrive contents of registers that were used from the stack
    pop rdx
    pop rsi
    pop rdi
    pop rcx
    pop rax

    ret 16                              ; clear stack

;-------------------------------------------------------
; PRINT NEW LINE
;-------------------------------------------------------
section .data

new_line    db  10

section .text

print_new_line:

    ;save contents of registers that are going to be used on the stack
    push rax
    push rdi
    push rsi
    push rdx
    push rcx

    mov [new_line], byte 10
    mov rax, 1                  ; write to terminal
    mov rdi, 1                  ; stdout
    mov rsi, new_line           ; holds address of result to be displayed
    mov rdx, 1                  ; number of bytes to be written
    syscall

    ;retrive contents of registers that were used from the stack
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax

    ret

;-------------------------------------------------------
; REMOVE NEW LINE
;-------------------------------------------------------

remove_new_line:

find_new_line:

    cmp byte [rsi + rax], 10            ; if \n
    jz  replace_with_null               ; jump and replace with \0
    inc rax                             ; increment counter
    cmp rax, rcx                        ; if rax = rcx
    jz replace_with_null                ; jump and replace with \0 for 30
    jmp find_new_line                   ; continue otherwise

replace_with_null:
    mov byte [rsi + rax], 0             ; replace with \0
    inc rax                             ; increment counter
    cmp rax, rdx                        ; if coutner == 30
    jz  exit                            ; exit function
    jmp replace_with_null               ; continue otherwise

exit:
    ret

;-------------------------------------------------------
; ATOI
;-------------------------------------------------------

atoi:

check_sign:
    mov al, [rsi]                   ; store ASCII character
    cmp al, 43                      ; +
    jz  next                        ; if '+'
    cmp al, 45                      ; -
    jnz seperate                    ; if not '+' or '-'
    ; '-'
    mov r10, 1                      ; signed

next:
    inc rsi                         ; point to next charcter

seperate:
    mov al, [rsi]                   ; store ASCII character
    cmp al, 0                       ; if \0
    jz units                        ; jump units_signed
    sub al, 48                      ; convert to integer
    push rax                        ; store this value in stack
    inc rsi                         ; point to next charcter
    inc rbx                         ; increment counter
    jmp seperate

units:
    mov r15, 0                      ; final value
    mov rax, 0                      ;
    pop rax                         ; get value from stack
    dec rbx                         ; decrease counter
    mov r15, rax                    ; move unit into r15 which is stored into rax
    mov rcx, 10                     ; used to
    mov r8, 10                      ; constant

make_number:
    cmp rbx, 0                      ; if counter is 0
    jz  exit_atoi                   ; string to number conversion is complete
    mov rax, 0                      ; clear rax
    pop rax                         ; get value from stack and out it into rax
    mul rcx                         ; multiply rax by 10^power where power is changed
    add r15, rax                    ; add to the contents
    mov rax, rcx                    ; move current 10^power into rax
    mul r8                          ; multiply by 10
    mov rcx, rax                    ; move back into rcx for next time
    dec rbx                         ; decrease counter
    jmp make_number

exit_atoi:
    mov rax, r15
    ret
