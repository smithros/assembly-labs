.586
.model flat, c

.data 
	x dd 1
	n dd 0
	a dd 9
	b dd 9

.code

Mul_Nx32_LONGOP proc

	push ebp
	mov ebp, esp
	
	mov edi, [ebp + 12]
	mov ebx, [ebp + 8]
	mov x, ebx
	mov n, 7; ������� ������ ��� ��� ������� 

	xor ebx, ebx; �������� ������� 
	xor ecx, ecx
	; ������� ���� ����� �� 32 ��� �������� ����� �� 32 ��� 
	@multiply32:
			
		mov eax, dword ptr[edi + ecx]
		mul x
		mov dword ptr[edi + ecx], eax
		clc
		adc dword ptr[edi + ecx], ebx
		mov ebx, edx

		add ecx, 4
		dec n

		jnz @multiply32

	pop ebp
	ret 8

Mul_Nx32_LONGOP endp

Mul_NxN_LONGOP proc

	push ebp
	mov ebp, esp

	mov esi, dword ptr[ebp + 16]; ����� �-�������� ����� 
	mov edi, dword ptr[ebp + 12]; ����� 
	mov ebx, dword ptr[ebp + 8]; ���������
	xor ecx, ecx
	xor edx, edx
	mov b, 7

	
	@main_cycle:
	mov eax, dword ptr[esi + edx]
	push edx

	push ebx
	mov ebx, ecx
	sub ebx, edx
	mul dword ptr[edi + ebx]
	pop ebx

	add dword ptr[ebx + ecx], eax
	adc dword ptr[ebx + ecx + 4], edx

	jnc @first
	xor eax, eax
	mov eax, ecx
	@second:
	add eax, 4
	add dword ptr[ebx + eax + 4], 1
	jc @second
	@first:

	; first - ���� ��������, ���� ����� �� 2 ������ ����� ��� �������� �� ������ 
	; second - � �������  


	pop edx
	add ecx, 4
	dec a
	jnz @main_cycle
	add edx, 4
	mov ecx, edx
	mov a, 7
	dec b
	jnz @main_cycle


	pop ebp
	ret 12


Mul_NxN_LONGOP endp

end
