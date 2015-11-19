;archivo: salario.asm - Calcula el impuesto del salario y el sueldo neto
;autor: Mitzi Sánchez Cubedo
;fecha: 17 nov 2015

%include 'funciones.asm'		;incluir archivo funciones
section .data
	msjSalario	db	"Salario: ", 0x0	;declaramos msj salario
	msjImpuesto db "Impuesto: ", 0x0	;declaramos msj impuesto
	msjNeto		db "Sueldo Neto: ", 0x0	;declaramos msj sueldo neto

section .text
	global _start
_start:

	pop ECX 		;obtenemos el numero de argumentos del stack
	pop EAX 		;sacamos del nombre del programa del stack (el argumento 0)
	dec ECX 		;le restamos 1 a ECX

  ;mov EDX, 100	;guardas 100 en el registro que servirá para calcular el sueldo neto
	;push EDX		;guardamos el 100 en el stack

sigArg:
	cmp ECX, 0	   		;checamos si todavia hay argumentos
	jz noMasArgs   		;si cero, ya no hay mas argumentos

	pop EAX		   		;sacamos del stack el siguiente argumento (el salario)
  call atoi	   		;convertimos el argumento a entero
  push EAX
  cmp EAX,10000	;compara el valor de EAX con 10,000
	jl ceroImp		;si EAX es menor salta a ceroImp
	cmp EAX,25000	;compara el valor de EAX con 25000
	jl veinteImp	;si EAX es menor salta a vienteImp

ceroImp:
 	pop EAX 			;saco el valor de salario
	push EAX			;guardo el valor
	mov EBX, 0		;capturamos el  impuesto en EBX
	push EBX			;guardamos el valor 0 del impuesto en el stack
	push EAX			;guargamos el valor del sueldo neto
	
	jmp imprimir	;salta a la etiqueta imprimir

veinteImp:
	mov EAX, 20				;preparamos para imprimir impuesto
	push EAX				;guardamos el valor 20 del impuesto en el stack
	
	jmp calculo				;salta a la etiqueta calculo
calculo:
	pop EBX					;sacamos el valor del Impuesto
	pop ECX					;sacamos el valor del salario
 
	mov EAX, ECX			;movemos el salario a EAX
	mul EBX				;multiplicamos por el impuesto
  mov EDX, 100			;pasamos el 100 a EDX
	;div EDX				;dividimos entre 100 	
	push EAX				;guardamos el valor del sueldo neto

imprimir: 
	pop EBX				;llamamos al sueldo neto
	pop ECX				;llamamos al impuesto
	pop EDX				;llamamos al salario

	mov EAX, msjSalario  ;preparamos para imprimir mensaje
	call sprint		   		;imprimimos mensaje
	mov EAX, EDX			;preparamos para imprimir mensaje
	call iprintLF			;imprimimos salario

	mov EAX, msjImpuesto;preparamos para imprimir mensaje
	call sprint		   		;imprimimos mensaje
	mov EAX, ECX		    ;preparamos para imprimir mensaje
	call iprintLF			  ;imprimimos impuesto

	mov EAX, msjNeto;preparamos para imprimir mensaje
	call sprint		  ;imprimimos mensaje
	mov EAX, EBX		;preparamos para imprimir mensaje
	call iprintLF   ;imprimimos sueldo neto

	dec ECX			;le restamos 1 a ECX
	jmp sigArg	;saltamos a sigArg para obtener otro argumento

noMasArgs:
	call quit    ;salida
