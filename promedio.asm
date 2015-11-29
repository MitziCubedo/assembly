;titulo: promedio.asm calcula el promedio de un alumno
;autores:  Samaniego Cristian
;          Sanchez Mitzi 
;fecha: 28 nov 2015

    sys_read equ 3
    stdin equ 0 

section .data
    msjNombre db "Nombre del Alumno: ",0x0      ;declaramos msjNombre
    msjCalificacion db "Calificacion ",0x0      ;declaramos msjCalificacion
    msjDosPuntos db ": ",0x0                    ;declaramos msjDosPuntos
    msjSeparador db "--------------------",0x0  ;declaramos msjSeparador
    msjPromedio db "Promedio: ",0x0             ;declaramos msjPromedio
    msjSemestre db "Semestre: ",0x0             ;declaramos msjSemestre
    msjAprobado db "Aprobado",0x0               ;declaramos msjAprobado
    msjReprobado db "Reprobado",0x0             ;declaramos msjReprobado   
section .bss 
    Buffer resb 45                              ;reserva 45b
    BufferNum resb 5                            ;reserva 5b
    Buffer_len  equ $-Buffer                    ;calcula longitud de Buffer
    BufferNum_len equ $-BufferNum               ;calcula longitud de BufferNum 
section .text
    global _start

_start:

    pop ECX                     ;obtenemos el numero de argumentos del stack
    pop EAX                     ;sacamos el nombre del programa del stack (el argumento 0)
    dec ECX                     ;le restamos 1 a ECX
    pop EAX                     ;sacamos del stack el siguiente argumento (el num califs)
    call atoi                   ;convertimos el argumento a entero (de caracter a numero)
    cmp EAX, 0                  ;checamos si hay califs a imprimir
    jz quit                     ;si no hay califs a imprimir, salimos
    mov EBX, EAX                ;compiamos el num de califs a EBX       
    push EBX                    ;salvamos el num de califs en el stack
    
    mov EAX, msjNombre          ;preparamos para imprimir
    call sprint                 ;imprimimos msjNombre
    mov ECX, Buffer             ;preparamos para leer el nombre (copiamos la direccion de buffer a ECX)
    mov EDX, Buffer_len         ;detectamos la longitud del mensaje
    call LeerTexto              ;leemos el mensaje 
    mov EAX, Buffer             ;copiamos el mensaje a EAX
    pop EBX                     ;sacamos el num de califs del stack
    mov ECX, 1                  ;movemos 1 a ECX 
    mov EDX, 0                  ;inicializamos en 0 EDX

sigCalif:
    cmp ECX, EBX                ;comparamos el num de califs actual con el total
    jg impReporte               ;si la calif actual es igual a la calif total a imprimir, saltamos a impReporte
    mov EAX, msjCalificacion    ;preparamos para imprimir
    call sprint                 ;imprimimos msjCalificacion (primera parte del mensaje)
    mov EAX, ECX                ;preparamos para imprimir num de calif 
    call iprint                 ;imprimimos num de calif actual (segunda parte del programa)
    mov EAX, msjDosPuntos       ;preparamos para imprimir 
    call sprint                 ;imprimimos msjDosPuntos (ultima parte del mensaje)
    push EBX                    ;salvamos en el stack EBX (num total de califs a imprimir)
    push ECX                    ;salvamos en el stack ECX (num de calif actual)
    push EDX                    ;salvamos en el stack EDX (suma de las califs)
    mov ECX, BufferNum          ;preparamos para leer la calif (copiamos la direccion de buffernum a ECX)
    mov EDX, BufferNum_len      ;detectamos longitud del mensaje
    call LeerTexto              ;leemos el mensaje 
    mov EAX, BufferNum          ;copiamos el mensaje a EAX
    call atoi                   ;convertimos a numero 
    pop EDX                     ;sacamos del stack la suma de la califs
    pop ECX                     ;sacamos del stack el num de calif actual
    pop EBX                     ;sacamos del stack el num total de califs a imprimir
    add EDX, EAX                ;sumamos la calif ingresada a EDX
    inc ECX                     ;aumentamos en 1 a ECX (la calif actual)
    
    jmp sigCalif                ;iteramos
    
impReporte: 
    push EBX                    ;salvamos en el stack EBX (el num total de califs)
    push EDX                    ;salvamos en el stack EDX (la suma de todas las califs)
    mov EAX, msjSeparador       ;preparamos para imprmir 
    call sprintLF               ;imprimimos msjSeparador
    mov EAX, msjNombre          ;preparamos para imprmir
    call sprint                 ;imprimimos msjNombre
    mov EAX, Buffer             ;preparamos para imprimir nombre
    call sprint                 ;imprimimos nombre del alumno
    
    mov EAX, msjPromedio        ;preparamos para imprimir
    call sprint                 ;imprimimos msjPromedio

    pop EAX                     ;sacamos EAX del stack (la suma de todas las califs)
    mov EDX, 1                  ;movemos 1 a EDX
    mul EDX                     ;multiplicamos por 1 
    pop EBX                     ;sacamos el numero de califs totales
    div EBX                     ;dividimos la suma entre EBX
    mov EDX, EAX                ;copiamos el promedio de EAX a EDX
    push EDX                    ;salvamos el promedio en el stack
    call iprintLF               ;imprimimos el promedio

    mov EAX, msjSemestre        ;preparamos para imprimir el mensaje
    call sprint                 ;imprimimos msjSemestre
    cmp EDX, 60                 ;comparamos el promedio con 60
    jl impReprobado             ;si es el promedio es menor a 60, salta a impReprobado
    mov EAX, msjAprobado        ;preparamos para imprimir
    call sprintLF               ;imprimimos msjAprobado
    call quit                   ;salimos

impReprobado:
    mov EAX, msjReprobado       ;preparamos para imprimir
    call sprintLF               ;imprimimos msjReprobado
    call quit                   ;salimos

    
    

strlen:                         ;funcion strlen
    push EBX                    ;salvamos el valor de EBX en la pila/stack
    mov EBX, EAX                ;copiamos la direccion del mensaje a EBX

sigcar: 
    cmp byte [EAX], 0           ;comparamos el byte que esta en la direccion 
                                ;a la que apunta EAX con 0 (estamos buscando el 
                                ;caracter de terminacion 0
    jz finalizar                ;jump if zero, salta a finalizar si es cero
    inc EAX                     ;incrementamos en 1 el acumulador
    jmp sigcar                  ;salto incondicional al siguiente caracter

finalizar:
    sub EAX, EBX                ;restamos al valor inicial de memoria 
                                ;el valor de final de memoria
    pop EBX                     ;restablecer EBX
    ret                         ;regresar al punto en que llamaron la funcion

sprint:
    push EDX                    ;salvamos valor de EDX
    push ECX                    ;salvamos valor de ECXX
    push EBX                    ;salvamos valor de EBXX
    push EAX                    ;salvamos valor de EAX
    call strlen                 ;llamamos la funcion strlen
    
    mov EDX, EAX                ;movemos la longitud de cadena a EDX
    pop EAX                     ;traemos del stack el valor de EAX
    mov ECX, EAX                ;la direccion del mensaje a ECX
    mov EBX, 1                  ;descriptor de archivo (stdout)
    mov EAX, 4                  ;sys_write
    int 80h                     ;sys_exit
    
    pop EBX                     ;re-establecemos EBX
    pop ECX                     ;re establecemos ECX
    pop EDX                     ;re-establecemos EDX
    ret
    
;Funcion sprintLF,  imprime con LineFeed (nueva linea)  
sprintLF:   
    call sprint                 ;llama e imprime el mensaje
    
    push EAX                    ;salvamos el valor del acumulador (EAX), vamos a utilizarlo en esta funcion
    mov EAX,0xA                 ;Hexadecimal para caracter de LineFeed
    push EAX                    ;salvamos el 0xA en el stack    trucoooo
    mov EAX, ESP                ;pasamos direccion de0xA en el stack  // lo que apunta ESP(es la direccion del ultimo lugar de la pila) a EAX
    call sprint                 ;llama e imprime linefeed 
    pop EAX                     ;recuperamos el caracter 0xA
    pop EAX                     ;recuperamos el valor original de 0xA
    ret                         ;regresamos

;Funcion iprint (IntegerPrint) o impresion de enteros
iprint:
    push eax                ;salvamos eax en el stack (acumulador)
    push ecx                ;salvamos ecx en el stack (contador)   cuantos bytes echamos al stack
    push edx                ;salvamos edx en el stack (data)
    push esi                ;salvamos esi en el stack (source index)
    mov ecx, 0              ;vamos a contar cuantos bytes necesitamos imprimir
    
dividirLoop:
    inc ecx                 ;incrementar en 1 ecx
    mov edx, 0              ;limpiamos edx
    mov esi, 10             ;guardamos 10 en esi, vamos a dividir entre 10
    idiv esi                ;divide eax entre esi, siempre divide a EAX lo que este en eax lo divide con el vqlor de esi    
    add EDX, 48             ;agregamos el caracter 48 '0' 
    push EDX                ;la representación en ASCII de nuestro numero, lo guarda en el stack como caracter
    cmp EAX, 0              ;se puede dividir mas el numero entero ?
    jnz dividirLoop         ;jump if not zero (salta si no es cero)

imprimirLoop:
    dec ECX                 ;vamos a contar hacia abajo cada byte en el stack
    mov EAX, ESP            ;apuntador del stack a EAX
    call sprint             ;llamamos a la funcion sprint
    pop EAX                 ;removemos el ulitmo caracter del stack y lo mandamos a el registro EAX
    cmp ECX, 0              ;ya imprimimos todos los bytes del stack?
    jnz imprimirLoop        ;todavia hay numero que imprimir
    
    pop ESI                 ;re-establecemos el valor de ESI
    pop EDX                 ;re-establecemos el valor de EDX
    pop ECX                 ;re-establecemos el valor de ECX
    pop EAX                 ;re-establecemos el valor de EAX
    ret

;funcion iprint (integer print) o impresion de enteros con line feed
iprintLF:
    call iprint             ;imprimimos el nuevo numero
    push EAX                ;salvamos el dato que traemos en el acumulador
    mov EAX, 0xa            ;copiamos el código de linefeed a EAX
    push EAX                ;salvamos el linefeed en el stack
    mov EAX, ESP            ;copiamos el apuntador del stack a EAX
                            ;estamos apuntando a una dirección de memoria
    call sprint             ;imprimimos el linefeed
    pop EAX                 ;removemos el linefeed del stack
    pop EAX                 ;restablecemos el dato que traiamos en el acumulador
    ret         

atoi:
    push EBX                ;preservamos EBX
    push ECX                ;preservamos ECX
    push EDX                ;preservamos EDX
    push ESI                ;preservamos ESI
    mov ESI,EAX             ;nuestro numero a convertir va a EAX
    mov EAX, 0              ;inicializamos a cero EAX
    mov ECX, 0              ;inicializamos a cero ECX
    
ciclomult:                  ;ciclo de multiplicacion
    xor EBX, EBX            ;reseteamos a 0 EBX, tanto BH como BL
    mov BL, [ESI+ECX]       ;movemosun solo byte a la parte baja de EBX
    cmp BL, 48              ;comparamos con ASCII '0'
    jl terminarP            ;si es menor, saltamos a finalizado
    cmp BL, 57              ;comparamos con ASCII '9'
    jg terminarP            ;si es mayor, saltamos a finalizado
    cmp BL, 10              ;comparamos con linefeed
    je terminarP            ;si es igual, saltamos a finalizado
    cmp BL, 0               ;comparamos con caracter null (fin de cadena)
    jz terminarP            ;si es cero saltamos a finalizado 
    
    sub BL, 48              ;convertimos el caracter en entero (restamos 48)
    add EAX, EBX            ;agregamos el valor a EAX
    mov EBX, 10             ; movemos el decimal a 10 a EBX
    mul EBX                 ;multiplicamos EAX por EBX para obtener el lugar decimal
    inc ECX                 ;incrementamos ECX (contador)
    jmp ciclomult           ;seguimos nuestro ciclo de multiplicacion     
    
terminarP:
    mov EBX, 10             ;movemos el valor decimal 10 a EBX
    div EBX                 ;dividimos EAX por 10
    pop ESI                 ;re establecemos el valor de ESI
    pop EDX                 ;re-establecemos el valor de EDX
    pop ECX                 ;re-establecemos el valor de ECX
    pop EBX                 ;re-establecemos el valor de EBX
    ret

LeerTexto:
    mov EBX, stdin          ;Leemos de Standard Input
    mov EAX, sys_read       ;Funcion de Sistema Leer
    int 80h                 ;Pedir a sistema operativo realizar lectura
    ret     

quit:   
    mov EBX,0               ;iniciamos secuencia de salida
    mov EAX,1               ;sys_exit
    int 80h                 ;ejecuta
