.386

.model flat, stdcall

option CASEMAP : none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\\lib\kernel32.lib

includelib \masm32\lib\user32.lib

include \masm32\include\windows.inc
.const
Caption db 'First Assembly Program', 0
Text db 'Hello!', 13, 10, 'I'm Koval Rostislav, IO-71, 0
.data

.code
start :

invoke MessageBoxA, 0, ADDR Text, ADDR Caption, MB_ICONINFORMATION
invoke ExitProcess, 0
end start
