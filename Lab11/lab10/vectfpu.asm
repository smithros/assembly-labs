.586
.model flat, c
.data
.code

MyDotProduct_FPU proc dest : DWORD, A : DWORD, B : DWORD, N : DWORD
mov eax, A
mov ebx, B
mov edx, dest
mov ecx, N
dec ecx

fldz

@cycle:
fld dword ptr[eax + 4 * ecx]
fmul dword ptr[ebx + 4 * ecx]
faddp st(1), st(0)
dec ecx
jge @cycle

fstp dword ptr[edx]
ret
MyDotProduct_FPU endp

End
