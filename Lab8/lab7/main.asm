.586
.model flat, stdcall

option casemap : none; розрізнювати великі та маленькі букви
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

include module.inc
include longop.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
CaptionHello db 'Лабораторна робота № 8', 0
TextHello db 'Автор: Коваль Ростислав Юрійович', 13, 10, 'Група: ІО-71', 13, 10, "Номер у списку: 8", 13, 10, "Рік: 2019", 0
Caption1 db "3488.3892999999994 ", 0
Caption1Hex db "40AB40C7525460A9", 0
Caption2 db "3410.6492999999996 ", 0
Caption2Hex db "40AAA54C710CB295", 0
Caption3 db "268.7707", 0
Caption3Hex db "4070CC54C985F06F", 0
valA0 dq 5.6
valB0 dq 2.4
valA1 dq 3.8
valB1 dq 10.3
valA2 dq 5.6
valB2 dq 2.4
valA3 dq - 10.5
valB3 dq 11.4
valA4 dq - 112.8
valB4 dq 31.9
valA5 dq 15.27
valB5 dq 11.41
valA6 dq - 9.2
valB6 dq - 3.1
valA7 dq - 3.8
valB7 dq 10.3
Res dq ?
HexBuf dd 100 dup(? )
DecBuf dd 100 dup(? )
HexBuf2 dd 100 dup(? )
DecBuf2 dd 100 dup(? )
HexBuf3 dd 100 dup(? )
DecBuf3 dd 100 dup(? )

.code

main :
invoke MessageBoxA, 0, ADDR TextHello, ADDR CaptionHello, 0
; Top of Stack Pointer == TOP
fld valA0; запис у вершину стека ST(0)
fmul valB0
fld valA1
fmul valB1
faddp st(1), st(0)
fld valA2
fmul valB2
faddp st(1), st(0)
fld valA3
fmul valB3
faddp st(1), st(0)
fld valA4
fmul valB4
faddp st(1), st(0)
fld valA5
fmul valB5
faddp st(1), st(0)
fld valA6
fmul valB6
faddp st(1), st(0); додавання
fld valA7
fmul valB7; множення
faddp st(1), st(0)
fabs; абсолютне значення 
fstp Res; читання з стеку 

push offset HexBuf
push offset Res
push 64
call StrHex_MY

invoke MessageBoxA, 0, ADDR HexBuf, ADDR Caption1Hex, 0

push offset DecBuf
push offset Res
call DecFloat64_LONGOP

invoke MessageBoxA, 0, ADDR DecBuf, ADDR Caption1, 0

fld valA1
fmul valB1
fld valA2
fmul valB2
faddp st(1), st(0)
fld valA4
fmul valB4
faddp st(1), st(0)
fld valA5
fmul valB5
faddp st(1), st(0)
fld valA7
fmul valB7
faddp st(1), st(0)
fabs
fstp Res

push offset HexBuf2
push offset Res
push 64
call StrHex_MY

invoke MessageBoxA, 0, ADDR HexBuf2, ADDR Caption2Hex, 0

push offset DecBuf2
push offset Res
call DecFloat64_LONGOP

invoke MessageBoxA, 0, ADDR DecBuf2, ADDR Caption2, 0

fld valA0
fmul valB0
fld valA1
fmul valB1
faddp st(1), st(0)
fld valA2
fmul valB2
faddp st(1), st(0)
fld valA5
fmul valB5
faddp st(1), st(0)
fld valA6
fmul valB6
faddp st(1), st(0)
fabs
fstp Res

push offset HexBuf3
push offset Res
push 64
call StrHex_MY

invoke MessageBoxA, 0, ADDR HexBuf3, ADDR Caption3Hex, 0

push offset DecBuf3
push offset Res
call DecFloat64_LONGOP

invoke MessageBoxA, 0, ADDR DecBuf3, ADDR Caption3, 0

invoke ExitProcess, 0
end main
