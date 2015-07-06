# TFG
Libreria de efectos de procesamiento de audio.
Andrés González Fornell
v1.0 (6 de julio de 2015)
https://github.com/andresgonzalezfornell/TFG/archive/master.zip

# Requisitos del sistema
La librería está garantizada y probada bajo los requerimientos indicados. Aunque es probable que funcione bajo circunstancias diferentes, es posible que su funcionamiento no sea completo y por tanto no se recomienda.
## Sistema operativo
    Linux Ubuntu 14.04 LTS o superior
    Mac OS X 10.9.5 (Mavericks) o superior
    Windows XP o superior
## Mathworks Matlab
    Desarrollado en R2015a (aunque funciona a partir de la versión R2012b no se garantiza para versiones anteriores)
## Plug-ins de Matlab
    Signal Processing Toolbox
## Archivos de entrada
    Formato .mp3 o .wav, a cualquier frecuencia de muestreo

# Ejecución de efectos
Para una ejecución simple teclee en la ventana de comandos de Matlab el nombre del efecto que desea lanzar. Ejemplo:
delay
Se ofrece también la posibilidad de iniciar la librería mediante una interfaz índice dónde aparecen todos los efectos disponibles.
index
## Paso de salida a variables
Es posible guardar como variables la señal de salida del procesamiento que se va a realizar. Para ello, a la hora de ejecutar el efecto deseado habría que igualar una variable nueva al efecto que se ejecutará. Esto se debe a que los programas de cada efecto están definidos como funciones de Matlab. Ejemplo:
y = delay;
La variable igualada se corresponderá con un array de longitud N5, siendo N el número de muestras de la señal de salida. Las señales devueltas correspondientes se describen a continuación.
y(:,1)
## Señal de salida del canal L
y(:,2)
## Señal de salida del canal R
y(:,3)
## Espectro de la señal de salida del canal L
y(:,4)
## Espectro de la señal de salida del canal R
y(:,5)
## Espectro de la señal media aritmética de ambos canales
Para obtener ayuda de como tratar el paso de salida a variables teclee en matlab el comando help seguido del programa. Ejemplo:
help delay
