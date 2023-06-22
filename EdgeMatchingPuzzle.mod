/*********************************************
 * OPL 22.1.1.0 Model
 * Author: Kuba
 * Creation Date: 4 kwi 2023 at 20:25:49
 *********************************************/

using CP;

int liczba_klockow = 8;

int rozmiar_planszy = 3;

// klocek o wartości [0,0,0,0] to klocek widmo, bo cplex wywala brak wartości przy odwołaniu się do indeksu 0, który wcześniej nie istniał
int w[0..liczba_klockow][1..4] = [[0,0,0,0], [1,2,3,4], [2, 4, 7, 2], [1, 5, 5, 4], [3, 4, 6, 5], [5, 7, 2, 1], [6, 6, 2, 3], [6, 7, 6, 6], [2, 1, 8, 7]];

dvar int klocki[1..rozmiar_planszy][1..rozmiar_planszy];

maximize sum(i in 1..rozmiar_planszy, j in 1..rozmiar_planszy) klocki[i][j];

subject to {
  
  forall(i in 1..liczba_klockow) {
    count(all(j in 1..rozmiar_planszy, k in 1..rozmiar_planszy) klocki[j][k], i) <= 1;
  }
  
  forall(i in 1..rozmiar_planszy, j in 1..rozmiar_planszy) klocki[i][j] <= liczba_klockow;
  
  forall(i in 1..rozmiar_planszy, j in 1..rozmiar_planszy-1) klocki[j][i] == 0 || klocki[j+1][i] == 0 || w[klocki[j][i]][3] == w[klocki[j+1][i]][1];
  
  forall(i in 1..rozmiar_planszy, j in 1..rozmiar_planszy-1) klocki[i][j] == 0 || klocki[i][j+1] == 0 || w[klocki[i][j]][2] == w[klocki[i][j+1]][4];


}

float liczba_nieuzytych_klockow = liczba_klockow - rozmiar_planszy^2 + count(all(j in 1..rozmiar_planszy, k in 1..rozmiar_planszy) klocki[j][k], 0);

int czy_sie_da_uzupelnic = 0;

execute {
  
   liczba_nieuzytych_klockow;
   
   if(liczba_nieuzytych_klockow == 0) {
     czy_sie_da_uzupelnic = 1
   };
   czy_sie_da_uzupelnic;
}