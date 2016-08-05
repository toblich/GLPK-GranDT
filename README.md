# GLPK-GranDT
Resolución del GranDT usando programación entera mixta. Calcula la solución óptima para el GranDT, informando fecha a fecha qué titulares y suplentes elegir y a quién asignar capitán, para así obtener el puntaje máximo, ateniéndose a las reglas del GranDT.

## Descripción de los archivos
#### tp.mod
Contiene el modelo que resuelve el GranDT de 15 fechas.

#### datos.dat
Contiene los datos y parámetros que configuran el modelo anterior.

#### GranDT2015.csv
Contiene los datos del GranDT de la primera mitad de 2015.

## Ejecución
En Linux con glpsol instalado, ejecutar
```
glpsol -m tp.mod -d datos.dat
```

Debería funcionar también en Windows instalando gusek, aunque no fue probado.

## Instalación de glpsol
En Ubuntu, ejecutar
```
sudo apt install glpk-utils
```
