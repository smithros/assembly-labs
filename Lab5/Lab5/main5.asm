.model flat, stdcall
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

include module.inc
include longop.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

option casemap :none

.data
	Capt db "46!" ,0
	Capt1 db "46! x 46!" ,0
	Capttest1 db "test N*N (111..1*111..1)" ,0
	Capttest2 db "test N*32 (111..1*111..1)" ,0
	Capttest3 db "test N*N (111..1*11..100..0)" ,0
	textBuf dd 100 dup(?)
	textBuf1 dd 100 dup(?)
	textBuftest1 dd 100 dup(?)
	textBuftest2 dd 100 dup(?)
	textBuftest3 dd 100 dup(?)

	var dd 7 dup(0); 7*32
	bigger_var dd 14 dup(0)
	x dd 46

	test1 dd 7 dup(4294967295)
	test1res dd 14 dup(0)

	test2 dd 7 dup(4294967295)

	test31 dd 7 dup(4294967295)
	test32 dd 7 dup(0)
	test3res dd 14 dup(0)

	
.code	
	main:
	mov [var], 1
	@factorial:
	
		push offset var
		push x
		call Mul_Nx32_LONGOP 
	
	dec x
	jne @factorial
		

	push offset textBuf
	push offset var
	push 195
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR textBuf, ADDR Capt, 0

	push offset var
	push offset var
	push offset bigger_var
	call Mul_NxN_LONGOP

	push offset textBuf1
	push offset bigger_var
	push 384
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR textBuf1, ADDR Capt1, 0

	push offset test1
	push offset test1
	push offset test1res
	call Mul_NxN_LONGOP

	push offset textBuftest1
	push offset test1res
	push 448
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR textBuftest1, ADDR Capttest1, 0

	mov dword ptr [test2 + 16] , 0

	push offset test2
	push 4294967295
	call Mul_Nx32_LONGOP

	push offset textBuftest2
	push offset test2
	push 160
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR textBuftest2, ADDR Capttest2, 0

	mov [test32 + 19], 192
	push offset test31
	push offset test32
	push offset test3res
	call Mul_NxN_LONGOP

	push offset textBuftest3
	push offset test3res
	push 384
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR textBuftest3, ADDR Capttest3, 0
	invoke ExitProcess,0
end main
