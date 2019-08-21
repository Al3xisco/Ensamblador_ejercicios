%macro escribir 2 	;numero de parametros que va a recibir
	mov eax,4
	mov ebx,1
	mov ecx,%1      ; etiqueta de memoria donde se va imprimir 
	mov edx,%2      ; catidad de digitos a imprimir
	int 80h
%endmacro

section .data

	espacio db "",10
	len1 equ $ -espacio
	cero db "0 "
	len2 equ $ -cero
	salto db "",10
	lsalto equ $-salto
	 

section .text
	global _start
_start:
 
  mov ecx,6
  mov ebx,6 

fila:
  push ebx
  mov eax,6
  push eax
  escribir espacio, len1
  pop ecx

columna:
  push ecx
  escribir cero, len2
  pop ecx
  loop columna
  pop ecx
  mov ebx,ecx
  dec ebx
  loop fila

salir:
  escribir salto, lsalto
  mov eax,1
  mov ebx,0 
  int 80h
