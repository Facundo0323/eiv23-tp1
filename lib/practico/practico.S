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

    MOV R2,#0 //Acumulador parte baja = 0
    MOV R3,#0 // Acumulador parte alta = 0
    MOV R4,#0 //Indice = 0

0:
    CMP R4,R0 //Coparo R3 con R0 (o i con n)
    BGE 1f // Si R3 >= R0, salto a la etiqueta 1
    LDR R5,[R1,R4,LSL #2]  //Cargo en R5 el valor en la posicion "R1 + indice*4" (Cada elemento pesa 4 bits)
    CMP R5,#0
    BLT menor
    B mayor
menor:
    MOV R6,#0xFFFFFFFF
    B 2f
mayor:
    MOV R6,#0x00000000
    // R3:R2 = R3:R2  + R6:R5   
2:
    ADDS R2,R5 //Sumo el acumuador parte baja
    ADC R3,R6
    ADD R4,#1 //Sumo 1 al indice
    B 0b //Retorno a la etiqueta 0 mas cercana hacia arriba
1:
    //Saltar a la etiqueta 1 significa salir del bucle
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

 /*   MOV R2,#0 //k

    CMP R0,#1  // Comparo el valor de R0 con 1
    BLE 5f // Si R0<=1, salto a la etiqueta 5

    LDR R3,[R1,R2] // M = b[k]
    MOV R4,#1 // i = 1

    //Segundo Bucle
3:
    CMP R4,R0 //Comparo i con n
    BGE 5f // Si i>=n, salto a la etiqueta 5

    //If then
    LDR R5,[R1,R4]
    CMP R3 //Comparo M con b[i]
    BGE 4f // Si M>=b[i], salto a la etiqueta 4

    MOV R3,R1[R4] // M = b[i]
    MOV R2,R4 // k = i
4: 

    ADDC R4,#1 //i = i+1
5:
    //La etiqueta 5 representa salir del bucle */

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

    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
