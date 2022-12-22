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

//// #adventofcode
// Péter Györök
.d20.move:{[b;i]
    c:count b;
    n:b[i];
    op:n`p;
    np:op+n[`v];
    if[not np within 1,c-1;
        np:((np-1) mod c-1)+1];
    $[op<=np;
        b:update p-1 from b where p within (op+1;np);
        b:update p+1 from b where p within (np;op-1)];
    b[i;`p]:np;
    b};
.d20.mix:{[b].d20.move/[b;til count b]};
d20:{[part;x]
    a:"J"$x;
    c:count a;
    b:([]p:til c;v:a*$[part=2;811589153;1]);
    b:.d20.mix/[$[part=2;10;1];b];
    p0:exec first p from b where v=0;
    exec sum v from b where p in (p0+1000 2000 3000) mod c};
d20p1:{d20[1;x]};
d20p2:{d20[2;x]};