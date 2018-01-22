# PseudoRandom
Proyecto de la asignatura Circuitos Electrónicos perteneciente al tercer curso del Grado en Ingeniería de Tecnologías y Servicios de Telecomunicación en la ETSIT de la UPM

Sistema de encriptación de señal mediante el procesamiento y control digital de los datos en la FPGA.

El sistema estará formado por dos subsistemas analógicos (entrada y salida) y un subsistema de control digital. A partir de un reproductor comercial (teléfono, mp3, etc.), el subsistema analógico de entrada se encarga de adaptar las impedancias de entrada y realizar un primer filtrado para atenuar o eliminar las frecuencias fuera de la banda de interés.

El subsistema digital captura el código numérico introducido por el usuario (mediante pulsadores) y comprueba si es igual al código predefinido de cifrado (seleccionado mediante interruptores). En caso afirmativo, entrega la señal a la al subsistema analógico de salida. En caso negativo, entrega una señal con valores aleatorios.

El subsistema analógico de salida filtra la señal que recibe del bloque digital y la amplifica para poder ser escuchada por los auriculares.

Tanto el código numérico generado por el usuario como el código predefinido de cifrado están comprendidos entre 0 y 63 (ambos se representan con 6 bits). El código predefinido se genera mediante los interruptores disponibles en la placa BASYS-2, mientras que el código del usuario se genera mediante los pulsadores y se visualiza en los displays.

Entre los subsistemas analógicos de entrada y de salida y el subsistema digital es necesario realizar la conversión Analógico-Digital (ADC) y Digital-Analógica (DAC). En nuestro caso utilizaremos los circuitos integrados MAX-1246 (ADC) y MAX-5352 (DAC) disponibles dentro de la placa entrenadora ENT2004CF, que permiten recibir o enviar 12 bits a la parte digital. En ambos casos, el control de los circuitos integrados se realiza por medio de la FPGA de la placa Basys-2 del laboratorio. La frecuencia de muestreo del ADC (y por tanto de procesamiento de las muestras en el subsistema digital) será fc = 8 kHz.
