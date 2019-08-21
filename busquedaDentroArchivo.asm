%macro escribe 2
	mov eax, 4 
	mov ebx, 1
	mov ecx, %1 
	mov edx, %2
	int 80h
%endmacro

segment .data 
	msg1 db 10,0x9,"INTRODUZCA UNA CADENA: "
	len1 equ $-msg1 
	msg db 10,0x9,"INTRODUZCA CARACTER A BUSCAR: "
	len equ $-msg
	msg4 db  10,0x9,"EL CARACTER NO EXISTE",10
	len4 equ $-msg4
	msg5 db  10,"EL CARACTER EXISTE EN LA POSISION: "
	len5 equ $-msg5

	archivo db "/home/ensamblador/Desktop/nasm/archivo.txt", 0	; 


segment .bss
	cadena resb 9
	idarchivo resd 1
	car resb 2
	pos resb 2

segment .text
	global _start  
_start:  

	mov eax,8         ; the number of the syscall 'open'
	mov ebx,archivo
	mov ecx, 2  		;lect
	mov edx,7777h     ; all file permissions flags
	int 80h              ; interrupt 80h

	test eax,eax
	jz salir
	mov dword[idarchivo] , eax

	escribe msg1,len1
	
	mov ecx, cadena  
	mov edx, 20
	call lee

	mov eax, 4
	mov ebx, [idarchivo]
	mov ecx, cadena
	mov edx, 20
	int 80h


	escribe msg,len
	mov ecx, car  
	mov edx, 2
	call lee


	cld
	mov edi, cadena
	mov ecx, 20
	mov eax, [car]

	repne scasb	; Al buscar un byte de destino, la cadena se atraviesa hasta que se encuentra una coincidencia 
			;o la cadena finaliza. SCASB establece las banderas según los resultados de la comparación.
			;repne scasb ( repetir mientras no es igual ) restará repetidamente cada byte de cadena de al , actualizará di y 				;disminuirá cx hasta que se encuentre el objetivo ( zf = 1) o cx = 0
	jne noesta	; 

	escribe msg5, len5

	;sub edi,'0'

	mov [pos], edi
	escribe pos, 1	; Tamaño de 1, ya que solo buscará 1 letra.
	jmp salir

lee:
	mov eax, 3 
	mov ebx, 0
	int 80h
	ret

noesta:
	escribe msg4, len4

salir:
	mov eax, 6
	mov ebx, [idarchivo]
	mov ecx, 0
	mov edx, 0
	int 80h

	mov eax, 1  
	xor ebx, ebx 
	int 80h
