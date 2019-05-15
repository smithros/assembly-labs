.586
.model flat, c

.data
x dd 0
n dd 0
k dd 0
temp dd 0
innertemp dd 0
mult dd 0

shnum db 0
oldshnum db 0
bitnum db 0
dwordmask dd 4294967295
bytemask db 255
extramask db 255
cmpvar db 8

eldermask dd 11100000000000000000000000000000b
dwordcounter db 0
checkbit dd 1
sh_num db 0

signdigit dq 1
expmask dd 11111111111b
mantmask1 dd 0
mantmask2 dd 0
int_part dq 0
fract_part dq 0
counter dd 0
ten dd 10
digitcounter dd 0
accuracy db 0

.code

Add_800_LONGOP proc
push ebp
mov ebp, esp

mov esi, [ebp + 16]
mov ebx, [ebp + 12]
mov edi, [ebp + 8]

mov ecx, 25
mov edx, 0
clc
@cycle:
mov eax, dword ptr[esi + 4 * edx]
adc eax, dword ptr[ebx + 4 * edx]
mov dword ptr[edi + 4 * edx], eax

inc edx
dec ecx
jnz @cycle

pop ebp
ret 12
Add_800_LONGOP endp

Sub_320_LONGOP proc
push ebp
mov ebp, esp

mov esi, [ebp + 16]
mov ebx, [ebp + 12]
mov edi, [ebp + 8]

mov ecx, 10
mov edx, 0
clc
@cycle:
mov eax, dword ptr[esi + 4 * edx]
sbb eax, dword ptr[ebx + 4 * edx]
mov dword ptr[edi + 4 * edx], eax

inc edx
dec ecx
jnz @cycle

pop ebp
ret 12
Sub_320_LONGOP endp

Mul_Nx32_LONGOP proc
push ebp
mov ebp, esp

mov edi, [ebp + 16]
mov ebx, [ebp + 12]
mov ecx, [ebp + 8]
mov x, ebx
mov n, ecx

xor ebx, ebx
xor ecx, ecx

@mult32:
mov eax, dword ptr[edi + ecx]
mul x
mov dword ptr[edi + ecx], eax
add dword ptr[edi + ecx], ebx
mov ebx, edx

add ecx, 4
dec n

clc
cmp n, 0
jnz @mult32

pop ebp
ret 8

Mul_Nx32_LONGOP endp

Mul_NxN_LONGOP proc
push ebp
mov ebp, esp

mov esi, dword ptr[ebp + 16]
mov ebx, dword ptr[ebp + 12]
mov edi, dword ptr[ebp + 8]

mov ecx, 0
mov eax, 0
mov edx, 0

mov n, 12

@outer:
mov eax, dword ptr[ebx + ecx]
mov mult, eax
mov temp, ecx

mov ecx, 0
mov k, 12
@inner:
mov innertemp, 0
xor eax, eax
mov eax, dword ptr[esi + ecx]
mul mult

add ecx, temp
add dword ptr[edi + ecx], eax
adc dword ptr[edi + ecx + 4], edx
jc @addition
jnc @ordinary

@addition:
add ecx, 4
add innertemp, 4
add dword ptr[edi + ecx + 4], 1
jc @addition

@ordinary:
sub ecx, innertemp
sub ecx, temp
add ecx, 4
dec k

clc
cmp k, 0
jnz @inner

mov ecx, temp
add ecx, 4
dec n

clc
cmp n, 0
jnz @outer

pop ebp
ret 12

Mul_NxN_LONGOP endp

SHR_LONGOP proc
push ebp
mov ebp, esp

xor eax, eax
xor ebx, ebx
xor edx, edx
xor ecx, ecx

mov esi, dword ptr[ebp + 16]; Source
mov bl, byte ptr[ebp + 12]; N
mov cl, byte ptr[ebp + 8]; M

mov dl, bl
shr bl, 3

and dl, 07h
sub dl, 1
mov shnum, dl
mov oldshnum, dl
mov bitnum, cl
mov dwordmask, 4294967295
mov bytemask, 255

clc
cmp shnum, 0
jnz @cycle1
jz @extra
@cycle1:
shl bytemask, 1
dec dl
jnz @cycle1

@extra:
mov dl, cmpvar
sub dl, shnum
sub dl, bitnum
clc
cmp dl, 0
jg @extrmask
jle @other

@extrmask:
shr extramask, 1
dec dl
jnz @extrmask

@other:
mov al, byte ptr[esi + ebx]
mov dl, bytemask
and dl, extramask
and al, dl

mov dl, shnum
clc
cmp dl, 0
jnz @cycle2
jz @dwordop
@cycle2:
shr al, 1
dec dl
jnz @cycle2

@dwordop:
mov edx, dword ptr[esi + ebx + 1]
mov ecx, 32
sub cl, bitnum
add cl, 8
sub cl, shnum
mov shnum, cl

@cycle3:
shl dwordmask, 1
dec cl
jnz @cycle3

mov cl, shnum
@cycle4:
shr dwordmask, 1
dec cl
jnz @cycle4

and edx, dwordmask
mov cl, 8
sub cl, oldshnum

@cycle5:
shl edx, 1
dec cl
jnz @cycle5

or eax, edx

pop ebp
ret 12

SHR_LONGOP endp

DecFloat64_LONGOP proc
push ebp
mov ebp, esp

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

mov dword ptr[signdigit], 1
mov dword ptr[signdigit + 4], 0
mov expmask, 11111111111b
mov mantmask1, 0
mov mantmask2, 0
mov dword ptr[int_part], 0
mov dword ptr[int_part + 4], 0
mov dword ptr[fract_part], 0
mov dword ptr[fract_part + 4], 0
mov counter, 0
mov ten, 10
mov digitcounter, 0
mov accuracy, 0

mov esi, [ebp + 8]; адреса числа
mov ebx, [ebp + 12]; адреса буфера результату

; З'ясовуємо знак числа
mov eax, 1
shl eax, 31
and eax, dword ptr[esi + 4]
cmp eax, 0
jz @plus

@minus:
mov byte ptr[ebx], 45
jmp @exponent
@plus:
mov byte ptr[ebx], 43

@exponent:; Знаходимо порядок
shl expmask, 20
mov edx, expmask
and edx, dword ptr[esi + 4]
shr edx, 20
sub edx, 1023

@mantissa:; Знаходимо цілу та дробову частину мантиси
mov counter, edx
cmp counter, 20
jg @more

@less:
shl mantmask1, 1
inc mantmask1
dec edx
jnz @less
mov cl, 20
sub ecx, counter
shl mantmask1, cl

mov eax, mantmask1
mov edx, 0
and eax, dword ptr[esi + 4]
shr eax, cl

mov dword ptr[int_part], eax
xor mantmask1, 4294967295
shl mantmask1, 12
shr mantmask1, 12
xor mantmask2, 4294967295
mov eax, mantmask2
and eax, dword ptr[esi]
mov dword ptr[fract_part], eax
mov eax, mantmask1
and eax, dword ptr[esi + 4]
mov dword ptr[fract_part + 4], eax

jmp @final


@more:
add mantmask1, 1048575
sub edx, 20
mov counter, edx
@loop:
shl mantmask2, 1
inc mantmask2
dec edx
jnz @loop
mov edx, 32
sub edx, counter
@loop2:
shl mantmask2, 1
dec edx
jnz @loop2

mov edx, mantmask1
mov eax, mantmask2
and edx, dword ptr[esi + 4]
and eax, dword ptr[esi]
jmp @final

@final:
mov eax, dword ptr[int_part]; Оброблюємо цілу частину
mov ecx, counter
mov edx, 1
shl edx, cl
add eax, edx
mov edx, dword ptr[int_part + 4]
xor ecx, ecx

@checkdigitnum:
div ten
inc digitcounter
mov edx, 0
cmp eax, 0
jnz @checkdigitnum

mov eax, dword ptr[int_part]
mov ecx, counter
mov edx, 1
shl edx, cl
add eax, edx
mov edx, dword ptr[int_part + 4]
mov ecx, digitcounter

@loop3:
div ten
add edx, 48
mov byte ptr[ebx + ecx], dl
dec ecx
mov edx, 0
cmp eax, 0
jnz @loop3

inc digitcounter
mov ecx, digitcounter
mov byte ptr[ebx + ecx], "."

; Оброблюємо дробову частину
mov edx, dword ptr[fract_part + 4]
mov eax, dword ptr[fract_part]
mov expmask, 1111b
mov ecx, 20
sub ecx, counter
shl expmask, cl

mov counter, ecx
mov accuracy, 6
mov edi, 0
@loop4:
shl edx, 1; Множення на 2
shl eax, 1
adc edx, 0
mov dword ptr[fract_part + 4], edx
mov dword ptr[fract_part], eax

shl edx, 1; Множення на 4
shl eax, 1
adc edx, 0
shl edx, 1
shl eax, 1
adc edx, 0

add eax, dword ptr[fract_part]
adc edx, dword ptr[fract_part + 4]
mov edi, expmask
and edi, edx
mov ecx, counter
shr edi, cl
add edi, 48
mov ecx, digitcounter
mov word ptr[ebx + ecx + 1], di
inc digitcounter
dec accuracy
not expmask
and edx, expmask
not expmask
cmp accuracy, 0
jnz @loop4


@exitp:
pop ebp
ret 8
DecFloat64_LONGOP endp
end