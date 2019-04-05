.586
.model flat, c

.code

Add_320_LONGOP proc

push ebp
mov ebp, esp
mov esi, [ebp + 16]; ESI = адреса A
mov ebx, [ebp + 12]; EBX = адреса B
mov edi, [ebp + 8]; EDI = адреса результату

mov ecx, 10; 320/32 ЛІЧИЛЬНИК ЦИКЛУ 
mov edx, 0
clc
cycle1:
mov eax, dword ptr[esi + 4 * edx]
adc eax, dword ptr[ebx + 4 * edx]; додавання групи з 32 бітів
mov dword ptr[edi + 4 * edx], eax
inc edx
dec ecx
jnz cycle1

pop ebp; відновлення стеку
ret 12
Add_320_LONGOP endp


Sub_800_LONGOP proc

push ebp
mov ebp, esp
mov esi, [ebp + 16]; ESI = адреса A
mov ebx, [ebp + 12]; EBX = адреса B
mov edi, [ebp + 8]; EDI = адреса результату

mov ecx, 25; 800/32
mov edx, 0
clc
cycle2:
mov eax, dword ptr[esi+4*edx]
sbb eax, dword ptr[ebx+4*edx] ; віднімання групи з 32 бітів
mov dword ptr[edi+4*edx], eax
inc edx
dec ecx
jnz cycle2

pop ebp ;відновлення стеку
ret 12
Sub_800_LONGOP endp

end