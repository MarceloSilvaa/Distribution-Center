# declaração dos conjuntos necessários à decisão:

set Cities;                      # conjunto das cidades de Portugal continental

# declaração de parametros			       
param long {Cities};                                    # longitude das cidades
param lat {Cities};                                     # latitude das cidades
param pop {Cities};                                     # populações das cidades
param Pi := 3.14159265359;                              # Pi
param Radius := 6371.009;                               # raio da Terra						   
param deliv {i in Cities} := ceil(pop[i] * 3 / 1000);   # número de entregas anuais
param DCcost := 25000;                                  # manutenção anual do centro de distribuição

# Variáveis principais
var X;                           # latitude do centro de destribuição
var Y;                           # longitude do centro de destribuição

# Variáveis auxiliares
var dX {i in Cities} >= 0;       # componente horizontal da manhattan distance
                                 # entre as cidades e o centro de destribuição
var dY {i in Cities} >= 0;       # componente vertical da manhattan distance
                                 # entre as cidades e o centro de destribuição
var d {i in Cities} >= 0;        # soma da componente horizontal e vertical

var hasDC {i in Cities} binary;  # DC's têm de estar em cidades

# declaração das restrições
subject to 

Latitude1 {i in Cities}: dX[i] >= (X - lat[i]) / 360 * 2 * Pi * Radius;
Latitude2 {i in Cities}: dX[i] >= (lat[i] - X) / 360 * 2 * Pi * Radius;
Longitude1 {i in Cities}: dY[i] >= (Y - long[i]) / 360 * 2 * Pi * Radius;
Longitude2 {i in Cities}: dY[i] >= (long[i] - Y) / 360 * 2 * Pi * Radius;
Dist {i in Cities}: d[i] = dX[i] + dY[i];
DCnumber: (sum {i in Cities} hasDC[i]) = 1;
DCcity {i in Cities}: d[i] * hasDC[i] <= 0; 

# declaração da função objectivo:
minimize total_cost: DCcost + sum {i in Cities} deliv[i] * d[i];
