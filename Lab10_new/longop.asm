.586
.model flat, c
.data
cote dd 0
x dd 1
n dd 0

num10 db 10
inner dd 0
num7 db 7
minn db 0
spacee db 3
three dd 3
.code

Mul_LONGOP proc bytes : DWORD, dest : DWORD, pB : DWORD, pA : DWORD

mov esi, pA; ESI = ������ ���������
mov ebx, pB; EBX = ������ ��������
mov edi, dest; EDI = ������ ����������
mov ecx, bytes; ������� �����
shr ecx, 2
mov cote, ecx

xor ecx, ecx
cycle :
push ebx
push ecx
push edi

shl ecx, 2
add ebx, ecx
add edi, ecx
shr ecx, 2
xor ecx, ecx

cycle_p : ; ��� ������ �������
	mov eax, [esi + 4 * ecx]
	mul dword ptr[ebx]
	add[edi + 4 * ecx], eax
	adc[edi + 4 * ecx + 4], edx
	adc byte ptr[edi + 4 * ecx + 8], 0
	inc ecx
	inc ecx
	cmp ecx, cote
	jl cycle_p

	xor ecx, ecx
	inc ecx
	cycle_np : ; ��� �������� �������
	mov eax, [esi + 4 * ecx]
	mul dword ptr[ebx]
	add[edi + 4 * ecx], eax
	adc[edi + 4 * ecx + 4], edx
	adc byte ptr[edi + 4 * ecx + 8], 0
	inc ecx
	inc ecx
	cmp ecx, cote
	jl cycle_np

	pop edi
	pop ecx
	pop ebx

	inc ecx
	cmp ecx, cote
	jl cycle

	ret
	Mul_LONGOP endp

Add_LONGOP proc bytes : DWORD, dest : DWORD, pB : DWORD, pA : DWORD
mov esi, pA; ESI = ������ A
mov ebx, pB; EBX = ������ B
mov edi, dest; EDI = ������ ����������
mov ecx, bytes; ECX = ������� ������� ���������
shr ecx, 2
xor edx, edx
clc; ������� �� CF ������� EFLAGS
cycle :
mov eax, dword ptr[esi + 4 * edx]
adc eax, dword ptr[ebx + 4 * edx]; ��������� ����� � 32 ���
mov dword ptr[edi + 4 * edx], eax
inc edx
cmp edx, ecx
jl cycle

ret
Add_LONGOP endp

Sub_LONGOP proc bytes : DWORD, dest : DWORD, pB : DWORD, pA : DWORD
mov esi, pA; ESI = ������ A
mov ebx, pB; EBX = ������ B
mov edi, dest; EDI = ������ ����������
mov ecx, bytes; ECX = ������� ������� ���������
shr ecx, 2
xor edx, edx
clc; ������� �� CF ������� EFLAGS
cycle :
mov eax, dword ptr[esi + 4 * edx]
sbb eax, dword ptr[ebx + 4 * edx]; �������� ����� � 32 ���
mov dword ptr[edi + 4 * edx], eax
inc edx
cmp edx, ecx
jl cycle

ret
Sub_LONGOP endp

Div_Column_LONGOP proc

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
Div_Column_LONGOP endp


Str_Dec proc bits : DWORD, src : DWORD, dest : DWORD

; ��������� StrHex_MY ������ ����� ����������������� ����
; ������ �������� - ������ ������ ����������(����� �������)
; ������ �������� - ������ �����
; ����� �������� - ���������� ����� � ����(�� ���� ������ 8)

mov edx, bits; ������� ��� �����
shr edx, 3; ������� ����� �����
mov esi, src; ������ �����
mov edi, dest; ������ ������ ����������

mov eax, edx
mul three


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
call Div_Column_LONGOP
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

ret
Str_Dec endp

End
