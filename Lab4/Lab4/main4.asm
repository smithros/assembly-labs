.586
.model flat, stdcall

option casemap : none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

include longop.inc
include module.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib


.data
Caption0 db "Лаб. роб. №4", 0
Text db "Виконав Коваль Ростислав", 0
Caption1 db "A + B", 0
Caption12 db "A + B", 0
Caption2 db "A - B", 0

; 800 / 32  320 / 32
; ЗМІННІ ЯКІ ЗБЕРІГАЮТЬ В СОБІ МАСИВИ ЧИСЕЛ 
Arr1 db 10 dup(?)
Arr12 db 10 dup(?)
Arr2 db 25 dup(?)

A1 dd 10 dup(?)
B1 dd 10 dup(?)
A12 dd 10 dup(?)
B12 dd 10 dup(?)
A2 dd 25 dup(?)
B2 dd 25 dup(?)

Res1 dd 10 dup(?)
Res12 dd 10 dup(?)
Res2 dd 25 dup(?)


.code

main:
invoke MessageBoxA, 0, ADDR Text, ADDR Caption0, 0

mov eax, 80010001h
mov ecx, 10; 320/32
mov edx, 0
cycle1:
mov dword ptr[A1 + 4 * edx], eax
add eax, 10000h
mov dword ptr[B1 + 4 * edx], 80000001h
inc edx
dec ecx
jnz cycle1

push offset A1
push offset B1
push offset Res1
call Add_320_LONGOP
push offset Arr1
push offset Res1
push 320
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr1, ADDR Caption1, 0

mov eax, 8h; вар
mov ecx, 10; 320/32
mov edx, 0
cycle2:
mov dword ptr[A12 + 4 * edx], eax
add eax, 1h
mov dword ptr[B12 + 4 * edx], 00000001h
inc edx
dec ecx
jnz cycle2

push offset A12
push offset B12
push offset Res12
call Add_320_LONGOP
push offset Arr12
push offset Res12
push 320
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr12, ADDR Caption12, 0

;ЗАПОВНЕННЯ МАСИВІВ А Б
mov eax, 8h; вар
mov ecx, 25; 800/32
mov edx, 0
cycle3:
mov dword ptr[A2+4*edx], 0
add eax, 1h
mov dword ptr[B2+4*edx], eax
inc edx
dec ecx
jnz cycle3

push offset A2
push offset B2
push offset Res2
call Sub_800_LONGOP
push offset Arr2
push offset Res2
push 800
call StrHex_MY
invoke MessageBoxA, 0, ADDR Arr2, ADDR Caption2, 0

invoke ExitProcess, 0
end main