/https://adventofcode.com/2022/day/20

inp: read0`:input/20.txt

//// https://github.com/adotsch/AOC
// András Dőtsch

I:"J"$inp
//part 1
N:count I
f:{[is;x]
    j0:is?x;
    is0:(j0#is),(j0+1)_is;
    m:I[x] mod N-1;
    j1:1+mod[m+j0-1;N-1];
    (j1#is0),x,j1 _is0 
 }
J:I til[N] f/ til N
sum J (1000 2000 3000 + J?0) mod N    //6640
// part 2
I*:811589153
J:I til[N] f/ til[10*N] mod N
sum J (1000 2000 3000 + J?0) mod N    //11893839037215

