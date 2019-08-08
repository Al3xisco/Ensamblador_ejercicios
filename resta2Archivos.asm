%macro escribir 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

section .data
	mensaje db "Leer archivos en memoria ", 10
	len_mensaje equ $-mensaje
	msj db "La suma es: ", 10
	len equ $-msj
	resta db ' '
	
	archivo1 db "/home/ensamblador/Desktop/nasm/archivo2.txt", 0	; ,0 -> fin del archivo1 478
	archivo2 db "/home/ensamblador/Desktop/nasm/archivo1.txt", 0	; ,0 -> fin del archivo2 343

section .bss
	texto resb 15			;variable que almacenara el contenido del archivo
        texto1 resb 15			;variable que almacenara el contenido del archivo
	idarchivo1 resd 1            ;identificador que se obtiene el archivo, es el archivo fisico
	idarchivo2 resd 1 

section .text
	global _start
_start:
;****abrir el archivo*****
	mov eax,5   ;servicio para abrir el archivo
	mov ebx,archivo1    ;la direccion del archivo
	mov ecx,0          ;Modo de acceso  0 = read only
	mov edx,0          ;permisos: permite leer si esta creado
	int 80h 
	test eax,eax
        mov dword[idarchivo1],eax
 	
	mov eax,5   ;servicio para abrir el archivo
	mov ebx,archivo2    ;la direccion del archivo
	mov ecx,0          ;Modo de acceso  0 = read only
	mov edx,0          ;permisos: permite leer si esta creado
	int 80h 
	test eax,eax
	
	mov dword[idarchivo2],eax
	escribir mensaje,len_mensaje

;****leer archivo****
	mov eax,3               ;servicio 3: letura
	mov ebx,[idarchivo1]     ;unidad de entrada
	mov ecx,texto           ;contenido
	mov edx,15
	int 80h
        
	mov eax,3               ;servicio 3: letura
	mov ebx,[idarchivo2]     ;unidad de entrada
	mov ecx,texto1           ;contenido
	mov edx,15
	int 80h

;*****imprimir el contenido***

	escribir texto,15
	escribir texto1,15

;*****cerrar el archivo****
	mov eax,6
	mov ebx,[idarchivo1]
	mov ecx,0
	mov edx,0
	int 80h
	
        mov eax,6
	mov ebx,[idarchivo2]
	mov ecx,0
	mov edx,0
	int 80h

;******resta de archivo********
	mov ecx, 3 
	mov esi, 2  
	clc         

ciclo_resta:
	;al ser cadena se empieza con 0
	mov al,[texto+esi]  ; 
	sbb al,[texto1+esi]  ;
        
	aas		 
	
	pushf		
	or al, 30h      
	popf		 

       	mov[resta+esi],al
        dec esi
        loop ciclo_resta
	escribir resta,3
	
salir:
	mov eax,1
	int 80h
