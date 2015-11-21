;titulo: salario.asm calcula el salario con impuestos c:
;autor: Mitzi Sanchez Cubedo
;fecha: 17 nov 2015

%include 'funciones.asm'		;incluir archivo funciones
section .data
	msjSalario	db	"Salario: ", 0x0	;declaramos msj salario
	msjImpuesto db "Impuesto: ", 0x0	;declaramos msj impuesto
	msjNeto		db "Sueldo Neto: ", 0x0	;declaramos msj sueldo neto
	msjSeparador db "_______________________________", 0x0 	;declaramos msj Separador

section .text
	global _start

_start:

	pop ECX 		;obtenemos el numero de argumentos del stack
	pop EAX 		;sacamos del nombre del programa del stack (el argumento 0)
	dec ECX 		;le restamos 1 a ECX

sigArg:

	cmp ECX, 0	   	;checamos si todavia hay argumentos
	jz noMasArgs   		;si cero, ya no hay mas argumentos

	pop EAX		   		;sacamos del stack el siguiente argumento (el salario)
	call atoi	   		;convertimos el argumento a entero
    	push ECX			;salvamos el valor de num de argumentos en el stack

    	mov EBX, 10000		;movemos 10000 al registro EBX
    	cmp EAX, EBX		;compara el valor de EAX con 10,000
	jl ceroImp		;si EAX es menor salta a ceroImp
	mov EBX, 25000          ;movemos 25000 al registro EBX
	cmp EAX, EBX		;compara el valor de EAX con 25000
	jl veinteImp		;si EAX es menor salta a vienteImp
	mov EBX, 50000      	;movemos 25000 al registro EBX
	cmp EAX, EBX		;compara el valor de EAX con 25000
	jl treintaImp		;si EAX es menor salta a vienteImp
	
	mov EDX, EAX		;copia el valor del salario a EDX
	push EAX		;salva el valor del salario

	mov EBX, 35 		;mueve el 20% de impuestos a EBX
	push EBX		;salva el valor del impuesto

	jmp calculo		;salta a calculo

ceroImp:
	
	mov EDX, EAX		;copia el valor del salario a EDX
	push EAX		;salva el valor del sueldo neto

	mov EBX, 0 		;muevo 0% de impuestos a EBX
	push EBX		;salva el valor del impuesto
	push EDX		;salva el valor del salario

	jmp imprimir		;salta a imprimir

veinteImp:
	
	mov EDX, EAX		;copia el valor del salario a EDX
	push EAX		;salva el valor del salario

	mov EBX, 20 		;mueve el 20% de impuestos a EBX
	push EBX		;salva el valor del impuesto

	jmp calculo		;salta a calculo

treintaImp:
	
	mov EDX, EAX		;copia el valor del salario a EDX
	push EAX		;salva el valor del salario

	mov EBX, 30 		;mueve el 20% de impuestos a EBX
	push EBX		;salva el valor del impuesto

	jmp calculo		;salta a calculo


calculo:
	
	pop EAX			;sacamos el impuesto del stack
	pop EDX 		;sacamos el salario del stack
	mov ECX, EDX		;copiamos el salario a ECX
	push ECX		;guardamos el salario en el stack

	mov EBX, 100 		;movemos el 100 a EAX
	push EBX		;guardamos 100 en el stack
  

	mul EDX			;multiplicar: impuesto * salario
	pop EBX			;sacamos el 100 del stack 
	div EBX			;dividir entre 100
	
	pop EBX			;sacamos el salario del stack 
	mov ECX, EBX		;copiamos el salario a ECX
	mov EDX, EAX		;copiamos el impuesto a EDX
	sub EBX, EAX		;restar: EAX - EBX (sueldo - impuesto)

	push EBX 		;salvamos la cantidad del sueldo neto
	push EDX		;salvamos la cantidad de impuesto
	push ECX		;salvamos la cantidad de salario  
imprimir: 
	
	mov EAX, msjSalario  	;preparamos para imprimir mensaje
	call sprint	   	 ;imprimimos mensaje
	pop EAX			 ;sacamos del stack al salario 
	call iprintLF		 ;imprimimos salario

	mov EAX, msjImpuesto	;preparamos para imprimir mensaje
	call sprint		;imprimimos mensaje
	pop EAX			;sacamos del stack al impuesto
	call iprintLF		;imprimimos impuesto

	mov EAX, msjNeto	;preparamos para imprimir mensaje
	call sprint		;imprimimos mensaje
	pop EAX			;sacamos del stack al sueldo neto
	call iprintLF      	;imprimimos sueldo neto

	mov EAX, msjSeparador	;preparamos para imprimir mensaje
	call sprintLF		;imprimimos Separador

	pop ECX			;sacamos del stack los argumentos
	dec ECX			;le restamos 1 a ECX
	jmp sigArg		;saltamos a sigArg para obtener otro argumento

noMasArgs:
	call quit 		;llamamos a salida
