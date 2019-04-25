.386
.model flat, stdcall
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

include module.inc
include longop.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

option casemap :none

.data

varA dd 1h, 13 dup(0h)
	factorial dd 1h
	temp dd 14 dup(0h)
	result dd 0h
	count dd 0h

	Caption1 db "46! в шістнадцятковій", 0
	Caption2 db "46! в десятковій", 0
	Caption3 db "Значення функції за варіантом", 0
	
	TextBuff1 db 448 dup(?)
	TextBuff2 db 448 dup(?)	
	TextBuff3 db ?
 
.code
main:
	; Факторіал в шістнадцятковій

	@cycle:
		push offset varA
		push factorial
		push offset temp
		call Mul_N32_LONGOP
		inc factorial
		inc count
		cmp count, 46

		mov ecx, 14
		@swap: 
			mov ebx, dword ptr[temp+4*ecx-4]
			mov dword ptr[varA+4*ecx-4], ebx
			mov dword ptr[temp+4*ecx-4], 0 
			dec ecx
		jnz @swap
	jb @cycle

	push offset TextBuff1
	push offset varA
	push 195
	call StrHex_MY
	invoke MessageBoxA, 0, ADDR TextBuff1, ADDR Caption1, 0

	; Факторіал в десятковій формі
	push offset TextBuff1
	push offset varA
	push 228
	call StrDec
	invoke MessageBoxA, 0, ADDR TextBuff1, ADDR Caption2, 0

	;Обчислення функції
	push offset result
	push 250     ; x
	push 4    ; m
	call Function_LONGOP

	push offset TextBuff3
	push offset result
	push 32
	call StrDec
	invoke MessageBoxA, 0, ADDR TextBuff3, ADDR Caption3, 0

	invoke ExitProcess, 0

end main

