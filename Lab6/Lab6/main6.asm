.586
.model flat, stdcall

option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include module.inc

include longop.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    TextBuf dd 32 dup(?)
    Caption db "Лабораторна робота №6",0
	Text db "Група ІО-71",13,10, "Коваль Ростислав", 0

	ValueA dd 15 dup(7)
	Result dd 0

.code
main:
    invoke MessageBoxA, 0, ADDR Text, ADDR Caption, 0

	push offset ValueA
	push offset Result
	call Count_1

	push offset TextBuf
	push offset Result
	push 32
	call StrHex_MY

	invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

	invoke ExitProcess, 0
end main