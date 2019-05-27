.686
.xmm
.model flat, C
.data
.code

MyDotProduct_SSE proc dest : DWORD, A : DWORD, B : DWORD, N : DWORD
mov eax, A
mov ebx, B
mov edi, dest
mov ecx, N
xorps xmm2, xmm2
@cycle:
movaps xmm0, [eax + 4 * ecx]
movaps xmm1, [ebx + 4 * ecx]
mulps xmm0, xmm1
haddps xmm0, xmm0
haddps xmm0, xmm0
addps xmm2, xmm0
sub ecx, 4
jge @cycle

movaps[edi], xmm2

ret
MyDotProduct_SSE endp

end

