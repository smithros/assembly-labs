// lab11.cpp: определяет точку входа для приложения.
//

#include "stdafx.h"
#include "lab10.h"
#include "vectsse.h" 
#include "vectfpu.h"


#define MAX_LOADSTRING 100

// Глобальные переменные:
HINSTANCE hInst;								// текущий экземпляр
TCHAR szTitle[MAX_LOADSTRING];					// Текст строки заголовка
TCHAR szWindowClass[MAX_LOADSTRING];			// имя класса главного окна

// Отправить объявления функций, включенных в этот модуль кода:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	About(HWND, UINT, WPARAM, LPARAM);
int APIENTRY _tWinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPTSTR    lpCmdLine,
	int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	// TODO: разместите код здесь.
	MSG msg;
	HACCEL hAccelTable;

	// Инициализация глобальных строк
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_LAB10, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Выполнить инициализацию приложения:
	if (!InitInstance(hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB10));

	// Цикл основного сообщения:
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	return (int)msg.wParam;
}



//
//  ФУНКЦИЯ: MyRegisterClass()
//
//  НАЗНАЧЕНИЕ: регистрирует класс окна.
//
//  КОММЕНТАРИИ:
//
//    Эта функция и ее использование необходимы только в случае, если нужно, чтобы данный код
//    был совместим с системами Win32, не имеющими функции RegisterClassEx'
//    которая была добавлена в Windows 95. Вызов этой функции важен для того,
//    чтобы приложение получило "качественные" мелкие значки и установило связь
//    с ними.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB10));
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = MAKEINTRESOURCE(IDC_LAB10);
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

//
//   ФУНКЦИЯ: InitInstance(HINSTANCE, int)
//
//   НАЗНАЧЕНИЕ: сохраняет обработку экземпляра и создает главное окно.
//
//   КОММЕНТАРИИ:
//
//        В данной функции дескриптор экземпляра сохраняется в глобальной переменной, а также
//        создается и выводится на экран главное окно программы.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	HWND hWnd;

	hInst = hInstance; // Сохранить дескриптор экземпляра в глобальной переменной

	hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

	if (!hWnd)
	{
		return FALSE;
	}

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	return TRUE;
}

__declspec(align(16)) float oA[320];
__declspec(align(16)) float oB[320];
__declspec(align(16)) float res;
__declspec(align(16)) char TextBuf[100];

//float oA[8] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0 };
//float oB[8] = { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 };

void prepare() {
	for (long i = 0; i < 320; i++)
	{
		oA[i] = 1.0 + i;
		oB[i] = pow(-1.0, i);
	}
}

void vectorSSE(HWND hWnd) {

	prepare();

	SYSTEMTIME st;
	long tst, ten;

	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;

	for (long i = 0; i < 1000000; i++)
	{
		MyDotProduct_SSE(&res, oA, oB, 320);
	}

	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;

	sprintf_s(TextBuf, "Скалярний добуток = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "SSE", MB_OK);
}

void vectorFPU(HWND hWnd) {

	prepare();

	SYSTEMTIME st;
	long tst, ten;

	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;
	for (long i = 0; i < 1000000; i++)
	{
		MyDotProduct_FPU(&res, oA, oB, 320);
	}
	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;
	sprintf_s(TextBuf, "Скалярний добуток = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "FPU", MB_OK);
}
float MyDotProduct(float *A, float *B, long N) {
	float r = 0;
	for (long i = 0; i < N; i++) {
		r += A[i] * B[i];
	}
	return r;
}
void vectorCPP(HWND hWnd) {

	prepare();

	SYSTEMTIME st;
	long tst, ten;

	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;

	for (long i = 0; i < 1000000; i++)
	{
		res = MyDotProduct(oA, oB, 320);
	}

	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;
	sprintf_s(TextBuf, "Скалярний добуток = %f\nЧас виконання = %ld мс", res, ten);
	MessageBox(hWnd, TextBuf, "C++", MB_OK);
}




//
//  ФУНКЦИЯ: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  НАЗНАЧЕНИЕ:  обрабатывает сообщения в главном окне.
//
//  WM_COMMAND	- обработка меню приложения
//  WM_PAINT	-Закрасить главное окно
//  WM_DESTROY	 - ввести сообщение о выходе и вернуться.
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	PAINTSTRUCT ps;
	HDC hdc;

	switch (message)
	{
	case WM_COMMAND:
		wmId = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// Разобрать выбор в меню:
		switch (wmId)
		{
		case ID_32771:
			vectorCPP(hWnd);
			break;
		case ID_32772:
			vectorSSE(hWnd);
			break;
		case ID_32773:
			vectorFPU(hWnd);
			break;
		case IDM_ABOUT:
			DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
			break;
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
		break;
	case WM_PAINT:
		hdc = BeginPaint(hWnd, &ps);
		// TODO: добавьте любой код отрисовки...
		EndPaint(hWnd, &ps);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// Обработчик сообщений для окна "О программе".
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}
