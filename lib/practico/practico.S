/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación

    ADD R0,R1

    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación

// Declaro las variables contador y acumulador

    MOV R2,#0 //Acumulador parte baja (32 bits)= 0
    MOV R3,#0 //Acumulador parte alta (32 bits)= 0
    MOV R4,#0 //Indice = 0

0:
    CMP R4,R0 //Coparo R3 con R0 (o i con n)
    BGE 1f // Si R3 >= R0, salto a la etiqueta 1, de lo contrario continua el codigo
    LDR R5,[R1,R4,LSL #2]  //Cargo en R5 (parte baja) el valor en la posicion "R1 + indice*4" (Desplazarse "4" equivale a pasar al siguiente elemento)
    CMP R5,#0 //Comparo el número cargado con 0
    BLT menor
    B mayor
menor:
    MOV R6,#0xFFFFFFFF //Si el numero es menor a cero, los 32 bits de la parte alta seran "1" (signo negativo)
    B 2f
mayor:
    MOV R6,#0x00000000   //Si el numero es mayor o igual a cero, la parte alta seran "0" (signo positivo)
    // R3:R2 = R3:R2  + R6:R5   
2:
    ADDS R2,R5 //Sumo el acumuador parte baja
    ADC R3,R6 //Sumo las partes altas
    ADD R4,#1 //Sumo 1 al indice
    B 0b //Retorno a la etiqueta 0 mas cercana hacia arriba
1:
    //Saltar a la etiqueta 1 significa salir del bucle
    //Al terminar muevo los resultados a R1 como parte alta, y R0 como parte baja
    MOV R0,R2 
    MOV R1,R3
    // Retorno, antes R1:R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */


defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación

    MOV R2,#0 //k = 0

    CMP R0,#1  // Comparo el valor de R0 con 1
    BLE 2f // Si R0<=1, salto a la etiqueta 2

    LDR R3,[R1] // Cargo en R3 (M) el valor en primera posición
    MOV R4,#1 // indice = 1

0:
    CMP R4,R0 //Comparo i con n
    BGE 2f // Si i>=n, salto a la etiqueta 2

    LDR R5,[R1,#4]! //Carga en R5 el elemento en la posición R1+4, luego guarda en R1 el valor "R1+4"
    CMP R3,R5 //Comparo M con b[i]
    BGE 1f // Si M>=b[i], salto a la etiqueta 1

    MOV R3,R5 // M = b[i]
    MOV R2,R4 // k = i
1: 

    ADD R4,#1 //i = i+1
    B 0b //Retorno a la etiqueta 0 mas cercana hacia arriba
2:
    //La etiqueta 2 representa salir del bucle 

    MOV R0,R2 //Copio en R0 la posición actual

    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
    SUB R5,R0,#1 // R5 = k = n-1 (Variable local)
    MOV R4,R1 // R4 = R1 (Variable local)
0:
    CMP R5,#0 // Comparo k con 0 
    BLE 1f // Si k<=0, salto a la etiqueta 1 

    ADD R0,R5,#1 // R0 = k+1, cargo el valor necesario antes del salto
    MOV R1,R4 // R1 = R4, cargo el valor necesario antes del salto
    BL posicion_maximo //Llamo a posicion_maximo (Ahora R0 = j)
    /*Como R1 no almacena ningun resultado, puede usarse para almacenar
    variables temporales*/
    LDR R1,[R4,R5,LSL #2] // Cargo en R1 (x) el valor en la posicion "R4+R5*4" (b[k])
    LDR R6,[R4,R0,LSL #2] // Cargo en R6 el valor en la posición "R4+R0*4" (b[j])
    STR R6,[R4,R5,LSL #2] // Guardo b[j] en la posición "R4+R5*4" (b[k])
    STR R1,[R4,R0,LSL #2] // Guardo R6 (x) en la posición "R4+R0*4" (b[j])
    SUB R5,#1             // k = k-1
    B 0b                  // Salto a la etiqueta 0

1:
    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
