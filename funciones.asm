;funciones.asm
;nombre: Mitzi Sanchez Cubedo
;Modificacion: 3 nov 2015
;aqui van nuestras funciones

sys_exit	equ 1
sys_read	equ 3
sys_write	equ 3
stdin		equ 0
stdout		equ 1
stderr  	equ 3

strlen:				;funcion strlen
	push EBX		;salvamos el valor de EBX en la pila/stack
	mov EBX, EAX	;copiamos la direccion del mensaje a EBX

sigcar: 
	cmp byte [EAX], 0 ;comparamos el byte que esta en la direccion 
					  ;a la que apunta EAX con 0 (estamos buscando el	
					  ;caracter de terminacion 0
	jz finalizar	  ;jump if zero, salta a finalizar si es cero
	inc EAX			  ;incrementamos en 1 el acumulador
	jmp sigcar		  ;salto incondicional al siguiente caracter

finalizar:
	sub EAX, EBX	    ;restamos al valor inicial de memoria 
						;el valor de final de memoria
	pop EBX				;restablecer EBX
	ret					;regresar al punto en que llamaron la funcion

sprint:
	push EDX		;salvamos valor de EDX
	push ECX		;salvamos valor de ECXX
	push EBX		;salvamos valor de EBXX
	push EAX 		;salvamos valor de EAX
	call strlen		;llamamos la funcion strlen
	
	mov EDX, EAX	;movemos la longitud de cadena a EDX
	pop EAX			;traemos del stack el valor de EAX
	mov ECX, EAX	;la direccion del mensaje a ECX
	mov EBX, 1 		;descriptor de archivo (stdout)
	mov EAX, 4		;sys_write
	int 80h			;sys_exit
	
	pop EBX			;re-establecemos EBX
	pop ECX			;re establecemos ECX
	pop EDX			;re-establecemos EDX
	ret
;Funcion sprintLF,	imprime con LineFeed (nueva linea)	
sprintLF:	
	call sprint		;llama e imprime el mensaje
	
	push EAX		;salvamos el valor del acumulador (EAX), vamos a utilizarlo en esta funcion
	mov EAX,0xA		;Hexadecimal para caracter de LineFeed
	push EAX		;salvamos el 0xA en el stack    trucoooo
	mov EAX, ESP	;pasamos direccion de0xA en el stack  // lo que apunta ESP(es la direccion del ultimo lugar de la pila) a EAX
	call sprint		;llama e imprime linefeed 
	pop EAX			;recuperamos el caracter 0xA
	pop EAX			;recuperamos el valor original de 0xA
	ret				;regresamos
;Funcion iprint (IntegerPrint) o impresion de enteros
iprint:
	push eax				;salvamos eax en el stack (acumulador)
	push ecx				;salvamos ecx en el stack (contador)   cuantos bytes echamos al stack
	push edx				;salvamos edx en el stack (data)
	push esi				;salvamos esi en el stack (source index)
	mov ecx, 0				;vamos a contar cuantos bytes necesitamos imprimir
	
dividirLoop:
	inc ecx					;incrementar en 1 ecx
	mov edx, 0 				;limpiamos edx
	mov esi, 10				;guardamos 10 en esi, vamos a dividir entre 10
	idiv esi				;divide eax entre esi, siempre divide a EAX lo que este en eax lo divide con el vqlor de esi	
	add EDX, 48				;agregamos el caracter 48 '0' 
	push EDX				;la representación en ASCII de nuestro numero, lo guarda en el stack como caracter
	cmp EAX, 0 				;se puede dividir mas el numero entero ?
	jnz dividirLoop			;jump if not zero (salta si no es cero)

imprimirLoop:
	dec ECX					;vamos a contar hacia abajo cada byte en el stack
	mov EAX, ESP			;apuntador del stack a EAX
	call sprint				;llamamos a la funcion sprint
	pop EAX					;removemos el ulitmo caracter del stack y lo mandamos a el registro EAX
	cmp ECX, 0 				;ya imprimimos todos los bytes del stack?
	jnz imprimirLoop		;todavia hay numero que imprimir
	
	pop ESI 				;re-establecemos el valor de ESI
	pop EDX					;re-establecemos el valor de EDX
	pop ECX                 ;re-establecemos el valor de ECX
	pop EAX 				;re-establecemos el valor de EAX
	ret

;funcion iprint (integer print) o impresion de enteros con line feed
iprintLF:
	call iprint 		;imprimimos el nuevo numero
	push EAX			;salvamos el dato que traemos en el acumulador
	mov EAX, 0xa 		;copiamos el código de linefeed a EAX
	push EAX			;salvamos el linefeed en el stack
	mov EAX, ESP		;copiamos el apuntador del stack a EAX
						;estamos apuntando a una dirección de memoria
	call sprint			;imprimimos el linefeed
	pop EAX				;removemos el linefeed del stack
	pop EAX				;restablecemos el dato que traiamos en el acumulador
	ret			

;-------------------------------
;int atoi (entero)
;convierte ascii a entero
;-------------------------------	

atoi:
	push EBX 		;preservamos EBX
	push ECX 		;preservamos ECX
	push EDX		;preservamos EDX
	push ESI		;preservamos ESI
	mov ESI,EAX		;nuestro numero a convertir va a EAX
	mov EAX, 0      ;inicializamos a cero EAX
	mov ECX, 0 		;inicializamos a cero ECX
	
ciclomult:			;ciclo de multiplicacion
	xor EBX, EBX	;reseteamos a 0 EBX, tanto BH como BL
	mov BL, [ESI+ECX] ;movemosun solo byte a la parte baja de EBX
	cmp BL, 48		;comparamos con ASCII '0'
	jl terminarP   ;si es menor, saltamos a finalizado
	cmp BL, 57      ;comparamos con ASCII '9'
	jg terminarP  ;si es mayor, saltamos a finalizado
	cmp BL, 10      ;comparamos con linefeed
	je terminarP  ;si es igual, saltamos a finalizado
	cmp BL, 0       ;comparamos con caracter null (fin de cadena)
	jz terminarP   ;si es cero saltamos a finalizado 
	
	sub BL, 48 		;convertimos el caracter en entero (restamos 48)
	add EAX, EBX	;agregamos el valor a EAX
	mov EBX, 10		; movemos el decimal a 10 a EBX
	mul EBX			;multiplicamos EAX por EBX para obtener el lugar decimal
	inc ECX			;incrementamos ECX (contador)
	jmp ciclomult   ;seguimos nuestro ciclo de multiplicacion		
	
terminarP:
	mov EBX, 10 	;movemos el valor decimal 10 a EBX
	div EBX			;dividimos EAX por 10
	pop ESI 		;re establecemos el valor de ESI
	pop EDX			;re-establecemos el valor de EDX
	pop ECX         ;re-establecemos el valor de ECX
	pop EBX			;re-establecemos el valor de EBX
	ret
;;-----------------
;;convierteftoc
;;convierte grados farenheit a grados centigrados
;; = f-32 * (5/9)
;;-----------------
convierteftoc:
;;;;;; tambien puede ser como se comentó 
	push EBX        ;salvamos EBX
	;Push EDX
	sub EAX, 32 	;le restamos 32 
	mov EBX, 5      ;preparamos para multiplicar por 5
	;move EDX, 5 
	mul EBX    ;lo multiplicamos por 5/9
	;mul EDX 
	mov EBX, 9		;preparamos para dividir entre 9
	div EBX	;lo dividimos
	;pop EDX    
	pop EBX 		;re-establecemos EBX
	
	ret

;;———————————————-
;;conviertectof
;;convierte grados farenheit a grados centígrados 
;;= [(c * 9)/5] + 32
conviertectof:
	push EBX 	;salvamos EBX
	push EDX	;salvamos EDX
	mov EDX, 9      ;preparamos para multiplicar
        mul EDX		;multiplicamos por 9
 	mov EBX, 5	;preparamos para dividir
	div EBX		;dividimos entre 5
	add EAX, 32	;sumamos 32
        pop EDX		;re-establecemos EDX
	pop EBX		;re-establecemos EDX

	ret

LeerTexto:
	mov EBX, stdin		;Leemos de Standard Input
	mov EAX, sys_read	;Funcion de Sistema Leer
	int 80h				;Pedir a sistema operativo realizar lectura
	ret	

quit:	
	mov EBX,0			;iniciamos secuencia de salida
	mov EAX,1			;sys_exit
	int 80h				;ejecuta
