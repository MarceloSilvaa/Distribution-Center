# declaração dos conjuntos necessários à decisão:

set Cities;                                             # conjunto das cidades de Portugal continental

# declaração de parametros			       
param long {Cities};                                    # longitude das cidades
param lat {Cities};                                     # latitude das cidades
param pop {Cities};                                     # populações das cidades
param Pi := 3.14159265359;                              # Pi
param Radius := 6371.009;                               # raio da Terra						   
param deliv {i in Cities} := ceil(pop[i] * 3 / 1000);   # número de entregas anuais
param DCcost := 25000;                                  # manutenção anual do centro de distribuição
param limit := 5;

# Variáveis 
var nr >= 0;											# número de centros de distribuição a posicionar

var dX {i in Cities, j in Cities} >= 0;                 # componente horizontal da manhattan distance
                                                        # entre as cidades e o centro de destribuição
var dY {i in Cities, j in Cities} >= 0;                 # componente vertical da manhattan distance
                                                        # entre as cidades e o centro de destribuição
var d {i in Cities, j in Cities} >= 0;                  # soma da componente horizontal e vertical

var hasDC {i in Cities} binary;                         # DC's têm de estar em cidades

var servesCity {i in Cities, j in Cities} binary;       # Por quem é servida cada cidade

# declaração das restrições
subject to 

Latitude1 {i in Cities, j in Cities}: dX[i,j] >= (lat[j] - lat[i]) / 360 * 2 * Pi * Radius;
Latitude2 {i in Cities, j in Cities}: dX[i,j] >= (lat[i] - lat[j]) / 360 * 2 * Pi * Radius;
Longitude1 {i in Cities, j in Cities}: dY[i,j] >= (long[j] - long[i]) / 360 * 2 * Pi * Radius;
Longitude2 {i in Cities, j in Cities}: dY[i,j] >= (long[i] - long[j]) / 360 * 2 * Pi * Radius;
Dist {i in Cities, j in Cities}: d[i,j] = dX[i,j] + dY[i,j];
Service {j in Cities}: sum {i in Cities} servesCity[i,j] = 1; 
DCnumberlow: (sum {i in Cities} hasDC[i]) >= 1;
DCnumberhigh: (sum {i in Cities} hasDC[i]) <= limit;
Activate {i in Cities, j in Cities}: servesCity[i,j] <= hasDC[i]; 
CheckDC: nr = (sum {i in Cities} hasDC[i]); 

# declaração da função objectivo:
minimize total_cost: (sum{i in Cities} hasDC[i] * DCcost) + (sum {i in Cities, j in Cities} deliv[j] * d[i,j] * servesCity[i,j]);
