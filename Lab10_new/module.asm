.586
.model flat, c
.data
Nbit dd 0
counter dd 0
.code
; ��������� StrHex_MY ������ ����� ����������������� ����
; ������ �������� - ������ ������ ����������(����� �������)
; ������ �������� - ������ �����
; ����� �������� - ���������� ����� � ����(�� ���� ������ 8)

StrHex_MY proc bits : DWORD, src : DWORD, dest : DWORD
mov ecx, bits; ������� ��� �����
cmp ecx, 0
jle @exitp
shr ecx, 3; ������� ����� �����
mov esi, src; ������ �����
mov ebx, dest; ������ ������ ����������
@cycle:
mov dl, byte ptr[esi + ecx - 1]; ���� ����� - �� �� hex - �����

mov al, dl
shr al, 4
call HexSymbol_MY
mov byte ptr[ebx], al
mov al, dl
call HexSymbol_MY
mov byte ptr[ebx + 1], al

mov eax, ecx
cmp eax, 4
jle @next
dec eax
and eax, 3
cmp al, 0
jne @next
mov byte ptr[ebx + 2], 32
inc ebx

@next:
add ebx, 2
dec ecx
jnz @cycle
mov byte ptr[ebx], 0
@exitp:
ret
StrHex_MY endp


; �� ��������� �������� ��� hex - �����
; �������� - �������� AL
; ���������->AL
HexSymbol_MY proc
and al, 0Fh
add al, 48; ��� ����� ����� ��� ���� 0 - 9
cmp al, 58
jl @exitp
add al, 7; ��� ���� A, B, C, D, E, F
@exitp:
ret

HexSymbol_MY endp

Div10_LONGOP proc
push ebp
mov ebp, esp

mov esi, [ebp + 24]; �����
mov eax, [ebp + 20]; ������
mov ebx, [ebp + 16]; ���������� �������
mov edi, [ebp + 12]; ������
mov ecx, [ebp + 8]; ������

buf dd 0
mov buf, eax
shr ebx, 3
dec ebx

xor eax, eax
@cycle:
mov al, byte ptr[esi + ebx]
div byte ptr[buf]
mov byte ptr[edi + ebx], al
dec ebx
cmp ebx, 0
jge @cycle
mov byte ptr[ecx], ah

mov esp, ebp
pop ebp
ret 20
Div10_LONGOP endp


StrDec proc bits : DWORD, src : DWORD, dest : DWORD


mov esi, dest
mov edi, src
mov ebx, bits


mov Nbit, ebx
shr ebx, 5; ������� 32 - ������ ��������
dec ebx

mov ecx, ebx
@copy:
number dw 0
mov eax, dword ptr[edi + 4 * ecx]
mov dword ptr[number + 4 * ecx], eax

dec ecx
cmp ecx, 0
jge @copy

@cycle:
push ebx
push esi
push edi

push offset number
push 10
push Nbit
push offset quotient
push offset remainder
call Div10_LONGOP

pop edi
pop esi
pop ebx

mov al, byte ptr[remainder]
add al, 48
mov byte ptr[esi], al
inc counter

mov ecx, counter
@lshift:
mov dl, byte ptr[esi + ecx - 1]
mov byte ptr[esi + ecx - 1], 48
mov byte ptr[esi + ecx], dl

dec ecx
cmp ecx, 0
jne @lshift

mov ecx, ebx
@swap:
quotient dw 0
mov eax, dword ptr[quotient + 4 * ecx]
mov dword ptr[number + 4 * ecx], eax
mov dword ptr[quotient + 4 * ecx], 0

dec ecx
cmp ecx, 0
jge @swap

remainder dw 0
mov dword ptr[remainder], 0

mov ecx, ebx
@check:
mov eax, dword ptr[number + 4 * ecx]

cmp eax, 0
jne @cycle

dec ecx
cmp ecx, 0
jge @check


ret
StrDec endp




end
