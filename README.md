# TFG
Libreria de efectos de procesamiento de audio.
https://github.com/andresgonzalezfornell/TFG/archive/master.zip

# Requisitos del sistema
Sistema operativo
    Linux Ubuntu 14.04 LTS o superior
    Mac OS X 10.9.5 (Mavericks) o superior
    Windows XP o superior
Mathworks Matlab
    Desarrollado en R2015a (aunque funciona a partir de la versi�n R2012b no se garantiza para versiones anteriores)
Plug-ins de Matlab
    Signal Processing Toolbox
Archivos de entrada
    Formato .mp3 o .wav, a cualquier frecuencia de muestreo
La librer�a est� garantizada y probada bajo los requerimientos indicados. Aunque es probable que funcione bajo circunstancias diferentes, es posible que su funcionamiento no sea completo y por tanto no se recomienda.

# Ejecuci�n de efectos
Para una ejecuci�n simple teclee en la ventana de comandos de Matlab el nombre del efecto que desea lanzar. Ejemplo:
>> delay
Se ofrece tambi�n la posibilidad de iniciar la librer�a mediante una interfaz �ndice d�nde aparecen todos los efectos disponibles.
>> index
Paso de salida a variables
Es posible guardar como variables la se�al de salida del procesamiento que se va a realizar. Para ello, a la hora de ejecutar el efecto deseado habr�a que igualar una variable nueva al efecto que se ejecutar�. Esto se debe a que los programas de cada efecto est�n definidos como funciones de Matlab. Ejemplo:
>> y = delay;
La variable igualada se corresponder� con un array de longitud N5, siendo N el n�mero de muestras de la se�al de salida. Las se�ales devueltas correspondientes se describen a continuaci�n.
>> y(:,1)
Se�al de salida del canal L
>> y(:,2)
Se�al de salida del canal R
>> y(:,3)
Espectro de la se�al de salida del canal L
>> y(:,4)
Espectro de la se�al de salida del canal R
>> y(:,5)
Espectro de la se�al media aritm�tica de ambos canales
Para obtener ayuda de como tratar el paso de salida a variables teclee en matlab el comando help seguido del programa. Ejemplo:
>> help delay