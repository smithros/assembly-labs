.386
.model flat, stdcall
option casemap : none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include \masm32\include\comdlg32.inc

include module.inc
include longop.inc

; comdlg32.lib - діалогове вікно вказування імені файлу

includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\user32.lib

.data
	fact dd 1
	crlf db 13, 10 ; перенос строки
	hFile dd 0
	dymRes dd ? ; вказівник для динамічної памяті
	szFileName dd 64 dup(0) ; буфер імені файлу 
	pFileName db "laboratory_work9.txt", 0
	TextBuf db 448 dup(0)
	
.code

SaveFileName proc
	LOCAL ofn : OPENFILENAME
	invoke RtlZeroMemory, ADDR ofn, SIZEOF ofn ; обнулення полів
	mov ofn.lStructSize, SIZEOF ofn
	mov ofn.lpstrFile, offset szFileName
	mov ofn.nMaxFile, SIZEOF szFileName
	invoke GetSaveFileName, ADDR ofn ; виклик вікна File Save As
	ret
	SaveFileName endp

main:
	invoke GlobalAlloc, GPTR, 1024; динамічний масив до 2 ГБ з 1024 байт
	mov dymRes, eax ; беремо вказівник з EAX - результат GlobalAlloc
	mov dword ptr[eax], 1h

	call SaveFileName
	cmp eax, 0; перевірка якщо у вікні FileSaveAs було натиснуто Cancel, то EAX = 0
	jz @exit
	; відкриття або створення файлу якщо немає - CreateFile
	; handle - ідентифікатор , запис хендлу файлу йде в EAX
	invoke CreateFile, ADDR szFileName,
						GENERIC_WRITE,
						FILE_SHARE_WRITE,
						0, CREATE_ALWAYS,
						FILE_ATTRIBUTE_NORMAL,
						0
	; GENERIC_WRITE і тд - константи з windows.inc
	cmp eax, INVALID_HANDLE_VALUE ; INVALID_HANDLE_VALUE - якщо значення не дорівніє цьому то доступ дозволено
	je @exit; доступ до файлу неможливий
	mov hFile, eax
	
	; обчислення факторіала
	@loop1:

	; Рахуємо факторіал починаючи з 1! до 46!
		push dymRes
		push fact
		call Mul_Nx32_LONGOP
		inc fact
			push offset TextBuf
			push dymRes
			push 400
			call StrHex_MY
			
			invoke WriteFile, hFile, ADDR TextBuf, 112, NULL, 0 ; WriteFile - запис у файл
			invoke WriteFile, hFile, ADDR crlf, 2, NULL, 0

	cmp fact,46
	jle @loop1
	; файл обовязково треба закрити 
	invoke CloseHandle, hFile
@exit:
	invoke GlobalFree, dymRes; знищуємо динамічний масив - звільняємо пам'ять 
	invoke ExitProcess, 0
end main

