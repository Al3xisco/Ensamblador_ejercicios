%macro escribir 2 	;numero de parametros que va a recibir
	mov eax,4
	mov ebx,1
	mov ecx,%1      ; etiqueta de memoria donde se va imprimir 
	mov edx,%2      ; catidad de digitos a imprimir
	int 80h
%endmacro

%macro leer 2 		;numero de parametros que va a recibir
	mov eax,3
	mov ebx,2
	mov ecx,%1      ; etiqueta de memoria donde se va imprimir 
	mov edx,%2      ; catidad de digitos a imprimir
	int 80h
%endmacro

section .data
  msj db 0x9,"Ingrese un Número y pulse saltoer 5 veces: ",10
  len equ $ -msj
  msj1 db "El número menor del arreglo es: "
  len1 equ $ -msj1
  salto db "",10
  lensalto equ $ -salto
  arreglo db 0,0,0,0,0
  lgArray equ $ -arreglo

section .bss
   res resb 2

section .text
global _start
_start:
    escribir msj,len

    mov esi,arreglo      ; primer elemento del arreglo				
    mov edi,0            ;  posicion respecto al tamaño del arreglo

leer_arreglo:
	leer res,2
	mov al,[res]      
	sub al,'0'       
	mov [esi],al      
		            
	add esi,1        ; + salto esi en 1
	add edi,1        ; + salto edi a 1

	cmp edi,lgArray  ;contiene la longitud del arreglo
		             ; si edi es menor que TamArre
	jb leer_arreglo   ; se ejecutal la etiqueta leer

; //// Recorrido del arreglo /// 
	mov ecx,0          ; se obtiene el valor de cada registro del arreglo 
	mov bl,9           ; almacena el numero mas pequeño del arreglo
	comparar2:
	mov al, [arreglo + ecx]  ;almacenamo el valor de larreglo en la posocion 0 ...a=1
	cmp al,bl                ;comparamo si al es mayor que bl
	ja bucle2                 ;se ejecuta blucle si al es menor que bl
	mov bl,al                ;caso contratio bl es igual al  ...bl contendrá el numeor menor 
	bucle2:
	inc ecx                ; cx se incrmsaltoa en 1 hasta 5
	cmp ecx, lgArray      ; si cx es menor que el tamaño de arreglo
	jb comparar2          ; se ejecuta la etiqueta comparar

 imprimir2:
    add bl,'0'
    mov [res],bl
    escribir salto,lensalto
    escribir msj1,len1
    escribir res,1
	escribir salto,lensalto

salir:
    mov eax,1
    mov ebx,0
	int 80h
