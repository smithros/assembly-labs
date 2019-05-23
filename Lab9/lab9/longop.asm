.386
.model flat, c
.data 
	x dd 1
	n dd 0

	inner dd 5
	outer dd 5

	buf dd 0h
	remainder dd 0h
	number dd 0h
	Nbit dd 0h
	quotient dd 0h
	counter dd 0h

	num10 db 10
	num7 db 7
	minn db 0
	spacee db 3

.code

Mul_NxN_LONGO proc

	push ebp
	mov ebp, esp

	mov esi, dword ptr[ebp + 16]
	mov edi, dword ptr[ebp + 12]
	mov ebx, dword ptr[ebp + 8]
	xor ecx, ecx
	xor edx, edx
	mov outer, 5

	@cycle:
	mov eax, dword ptr[esi + edx]
	push edx

	push ebx
	mov ebx, ecx
	sub ebx, edx
	mul dword ptr[edi + ebx]
	pop ebx

	add dword ptr[ebx + ecx], eax
	adc dword ptr[ebx + ecx + 4], edx

	jnc @ncf
	xor eax, eax
	mov eax, ecx
	@cf:
	add eax, 4
	add dword ptr[ebx + eax + 4], 1
	jc @cf
	@ncf:

	pop edx
	add ecx, 4
	dec inner
	jnz @cycle
	add edx, 4
	mov ecx, edx
	mov inner, 5
	dec outer
	jnz @cycle

	pop ebp
	ret 12

Mul_NxN_LONGO endp

Mul_Nx32_LONGOP proc

	push ebp
	mov ebp, esp

	mov edi, [ebp + 12]
	mov ebx, [ebp + 8]
	mov x, ebx
	mov n, 14

	xor ebx, ebx
	xor ecx, ecx
	@mult32:
			
		mov eax, dword ptr[edi + ecx]
		mul x
		mov dword ptr[edi + ecx], eax
		clc
		adc dword ptr[edi + ecx], ebx
		mov ebx, edx

		add ecx, 4
		dec n

		jnz @mult32

	pop ebp
	ret 8

Mul_Nx32_LONGOP endp

StrDec proc
	  ;процедура StrHex_MY записуЇ текст ш≥стнадц€тькового коду
    ;перший параметр - адреса буфера результату (р€дка символ≥в)
	;другий параметр - адреса числа
	;трет≥й параметр - розр€дн≥сть числа у б≥тах (маЇ бути кратна 8)
	push ebp
	mov ebp,esp
	mov edx, [ebp+8]		;к≥льк≥сть б≥т≥в числа
	shr edx, 3				;к≥льк≥сть байт≥в числа
	mov esi, [ebp+12]		;адреса числа
	mov edi, [ebp+16]		;адреса буфера результату
	
	mov eax, edx
	shl eax, 2


	mov cl, byte ptr[esi + edx - 1]
	and cl, 128
	cmp cl, 128
	jnz @plus
	mov minn, 1
	push edx
	@minus:
	not byte ptr[esi + edx - 1]
	sub edx, 1
	jnz @minus
	inc byte ptr[esi + edx]
	pop edx
	@plus:
	

	@cycle:
	push edx
	call Div10_LONGOP
	pop edx
	add bh, 48
	mov byte ptr[edi + eax], bh
	dec eax
	cmp bl, 0
	jz @cycle
	dec edx
	jnz @cycle

	cmp minn, 1
	jc @nomin
	mov byte ptr[edi + eax + 1], 45
	dec eax
	@nomin:

	inc eax
	@space:
	mov byte ptr[edi + eax], 32
	sub eax, 1
	jnc @space

	
	pop ebp
	ret 12
StrDec endp


Div10_LONGOP proc
	xor ebx, ebx
	xor ecx, ecx

	dec edx
	cmp byte ptr[esi + edx], 0
	jnz @cycleout
	inc bl

	@cycleout:
	mov ch, byte ptr[esi + edx]
	@cycleinner:
	shl cl, 1
	shl bh, 1
	shl ch, 1
	jnc @zero
	inc bh
	@zero:
	cmp bh, num10
	jc @less
	inc cl
	sub bh, num10
	@less:
	inc inner
	cmp inner, 8
	jnz @cycleinner
	mov byte ptr[esi + edx], cl
	mov inner, 0
	sub edx, 1
	jnc @cycleout
	ret

Div10_LONGOP endp

End