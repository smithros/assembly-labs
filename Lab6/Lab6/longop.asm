.586
.model flat, c

.data
    MyMask dd 2147483648;
	counter db 32

.code

Count_1 proc
    push ebp
	mov ebp, esp
	xor edi, edi
	xor eax, eax
	xor edx, edx
	xor ecx, ecx
	mov ebx, 56
	mov edi, dword ptr [ebp + 12]
	mov esi, [ebp+8]
	mov edx, 0

cycle:
   mov eax, dword ptr[edi + ebx]
   mov counter, 32
   a1:
	dec counter
	cmp counter, 0
	jl exit

	 mov ecx, eax
	 and ecx, MyMask
	 cmp ecx, 80000000h  ;2147483648
	 jne sh
	 je finish
	 sh:
     shl eax,1 
     add edx,1 ;
     jmp a1
	 
exit:
	sub ebx, 4
	cmp ebx, 0
	jge cycle
	
finish:
	mov dword ptr[esi], edx
	pop ebp
	ret 8
	Count_1 endp

end
