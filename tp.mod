# Conjuntos
set Jugadores;
set Equipos;
set Posiciones;
set Fechas;
set Fechas_sin_primera;


# Parametros
param presupuesto;
param max_mismo_equipo;
param cant_total_titulares;
param max_compras;
param min_suplentes_por_posicion;
param max_suplentes_por_posicion;
param cant_total_suplentes;
param cant_min{p in Posiciones};
param cant_max{p in Posiciones};
param p1{j in Jugadores};
param p2{j in Jugadores};
param p3{j in Jugadores};
param p4{j in Jugadores};
param p5{j in Jugadores};
param p6{j in Jugadores};
param p7{j in Jugadores};
param p8{j in Jugadores};
param p9{j in Jugadores};
param p10{j in Jugadores};
param p11{j in Jugadores};
param p12{j in Jugadores};
param p13{j in Jugadores};
param p14{j in Jugadores};
param p15{j in Jugadores};
param precio{j in Jugadores};
param equipo{j in Jugadores} symbolic in Equipos;
param posicion{j in Jugadores} symbolic in Posiciones;


# Lectura de Datos de CSV
table data IN "CSV" "GranDT2015.csv" : 	Jugadores <- [Jugador],
										p1 ~ F1,
										p2 ~ F2,
										p3 ~ F3,
										p4 ~ F4,
										p5 ~ F5,
										p6 ~ F6,
										p7 ~ F7,
										p8 ~ F8,
										p9 ~ F9,
										p10 ~ F10,
										p11 ~ F11,
										p12 ~ F12,
										p13 ~ F13,
										p14 ~ F14,
										p15 ~ F15,
										precio ~ Cotizacion,
										equipo ~ Equipo,
										posicion ~ Puesto;


# Variables
var EsTitular{j in Jugadores, f in Fechas} >= 0 binary;
var EsSuplente{j in Jugadores, f in Fechas} >= 0 binary;
var EsCapitan{j in Jugadores, f in Fechas} >= 0 binary;
var EsComprado{j in Jugadores, f in Fechas_sin_primera} >= 0 binary;


# Funcional
maximize Z: sum{j in Jugadores} ( p1[j]*(EsTitular[j,1] + EsCapitan[j,1]) +
								p2[j] * (EsTitular[j,2] + EsCapitan[j,2]) +
								p3[j] * (EsTitular[j,3] + EsCapitan[j,3]) +
								p4[j] * (EsTitular[j,4] + EsCapitan[j,4]) +
								p5[j] * (EsTitular[j,5] + EsCapitan[j,5]) +
								p6[j] * (EsTitular[j,6] + EsCapitan[j,6]) +
								p7[j] * (EsTitular[j,7] + EsCapitan[j,7]) +
								p8[j] * (EsTitular[j,8] + EsCapitan[j,8]) +
								p9[j] * (EsTitular[j,9] + EsCapitan[j,9]) +
								p10[j] * (EsTitular[j,10] + EsCapitan[j,10]) +
								p11[j] * (EsTitular[j,11] + EsCapitan[j,11]) +
								p12[j] * (EsTitular[j,12] + EsCapitan[j,12]) +
								p13[j] * (EsTitular[j,13] + EsCapitan[j,13]) +
								p14[j] * (EsTitular[j,14] + EsCapitan[j,14]) +
								p15[j] * (EsTitular[j,15] + EsCapitan[j,15])); 



# Restricciones

s.t. tamanio_equipo_titular{f in Fechas}: 
		sum{j in Jugadores} EsTitular[j, f] = cant_total_titulares;

s.t. titular_o_suplente_o_nada{j in Jugadores, f in Fechas}: 
		EsTitular[j, f] + EsSuplente[j, f] <= 1;

s.t. cantidad_suplentes{p in Posiciones, f in Fechas}: 
		min_suplentes_por_posicion <= sum{j in Jugadores : posicion[j] = p} EsSuplente[j, f] <= max_suplentes_por_posicion; 

s.t. cantidad_total_suplentes{f in Fechas}:
		sum{j in Jugadores} EsSuplente[j, f] = cant_total_suplentes;

s.t. gasto_total{f in Fechas}: 
		sum{j in Jugadores} precio[j] * ( EsTitular[j, f] + EsSuplente[j, f] ) <= presupuesto;

s.t. cant_equipo{e in Equipos, f in Fechas}:
		sum{j in Jugadores : equipo[j] = e} ( EsTitular[j, f] + EsSuplente[j, f] ) <= max_mismo_equipo;

s.t. tactica{p in Posiciones, f in Fechas}: 
		cant_min[p] <= sum{j in Jugadores : posicion[j] = p} EsTitular[j, f] <= cant_max[p];

s.t. cambios_fecha{j in Jugadores, f in Fechas_sin_primera}:
		EsTitular[j, f] + EsSuplente[j, f] - EsTitular[j, f-1] - EsSuplente[j, f-1] <= EsComprado[j, f];

s.t. restricA{j in Jugadores, f in Fechas_sin_primera}:
		EsTitular[j, f] + EsSuplente[j, f] >= EsComprado[j, f];

s.t. restircB{j in Jugadores, f in Fechas_sin_primera}:
		1 - (EsTitular[j, f-1] + EsSuplente[j, f-1]) >= EsComprado[j, f];

s.t. compras_por_fecha{f in Fechas_sin_primera}:
		sum{j in Jugadores} EsComprado[j, f] <= max_compras;

s.t. un_capitan{f in Fechas}:
		sum{j in Jugadores} EsCapitan[j, f] = 1;

s.t. capitan_titular{j in Jugadores, f in Fechas}:
		EsCapitan[j, f] <= EsTitular[j, f];



solve;


# Mostrar Resultados

for {f in Fechas} {
	printf: "\n********************** FECHA %d **********************\n", f;
	printf: "\nTITULARES\n";
	for {j in Jugadores : EsTitular[j,f] == 1} {
		printf: "%s    %s", posicion[j], j;
		for { {0}: EsCapitan[j,f] == 1} {
			printf: " [C]";
		}
		for { {0}: f > 1 && EsComprado[j,f] == 1} {
			printf: " *";
		}
		printf: "\n";
	}
	printf: "\nSUPLENTES\n";
	for {j in Jugadores : EsSuplente[j,f] == 1} {
		printf: "%s    %s\n", posicion[j], j;
	}
	printf: "\nPresupuesto usado: %d\n", sum{j in Jugadores : EsTitular[j,f] + EsSuplente[j,f] == 1} precio[j];
}

printf: "\n******************************************************\n\n";
printf: "Puntaje total obtenido: %d\n", Z;
printf: "\n******************************************************\n\n";

end;
