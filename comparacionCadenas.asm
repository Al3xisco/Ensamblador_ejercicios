%macro escribir 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

segment .data 
	msg db 10,0x9,0x9,0x9,"COMPARADOR DE CADENAS (TAM Y LONG)",10
	len equ $- msg
	msg1 db  10,"Escriba una cadena",10
	len1 equ $- msg1

	msg2 db  10,"Escriba una cadena",10
	len2 equ $- msg2

	msg3 db  10,"Las cadenas NO son iguales",10
	len3 equ $- msg3
	msg4 db  10,"Las cadenas Son iguales",10
	len4 equ $- msg4

	espacio db  10
	lespacio equ $- espacio

	;res db "         "
	;lenr equ $- res

	;res2 db "         "
	;lenr2 equ $- res2 

segment .bss
	res resb 10
	res2 resb 10

segment .text

	global _start  
_start: 
	
	escribir msg,len
	escribir msg1,len1

	mov ecx, res 
	mov edx, 10
	call lee	

	escribir msg2,len2

	mov ecx, res2 
	mov edx, 10
	call lee

	cld		;Incrementa DI despues de cada caracter		;std
	mov esi, res
	mov edi, res2
	mov ecx, 10

	repe CMPSB	;compara el byte señalado por el registro del índice de origen 					
			;con el byte, señalado por el registro del índice de destino
	jne noiguales
	
 iguales:   
	escribir msg4, len4

    jmp salir
;___________________________________________
noiguales:
	escribir msg3, len3
	jmp salir

lee:
	mov eax, 3	; lectura
	mov ebx, 0
	int 80h
	ret

salir:
	
	mov esi, res
	mov edi, res2
	mov ecx, 10

	repe MOVSB	; repe-> repetición mientras iguales
				;Mueve el byte en la dirección DS: (E) SI a la 					;dirección ES: (E) DI
	
	mov eax, 1  
	xor ebx, ebx 
	int 80h

