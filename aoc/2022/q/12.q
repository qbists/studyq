/https://adventofcode.com/2022/day/12

inp: read0`:test/12.txt

Shp: count each 1 first\inp                                         /map shape
`Start`End set'Shp vs/:raze[inp]?"SE";                              /start & end coords
Map: ./[;(Start;End);:;0 25] -97+6h$inp                             /height map
Is: 2 1 2#End                                                       /visited; last visited
adj: (0 1;1 0;0 -1;-1 0)+\:                                         /adjacency
filter: {y where not[null h] and (-2+Map . x)< h: Map ./:y}
step: {(x,;::)@\:except[;x]distinct raze{filter[x] adj x}each y}.  

-1+count(not Start in last@) step\ Is                               /part 1
a: Shp vs/:where raze inp="a"                                       /"a" coords
-1+count(not any a in last@) step\ Is                               /part 2


/
// Péter Györök
d12:{[part;x]
    a:-97+`int$ssr/[;"SE";"az"]each x;
    st:raze raze each til[count x],/:'/:where each/:x=/:"SE";
    visited:a<>a;
    queue:$[part=1;enlist first st;raze til[count x],/:'where each a=0];
    d:0;
    while[count queue;
        d+:1;
        visited:.[;;:;1b]/[visited;queue];
        nxts:update queue f from ungroup
            ([]f:til count queue;b:queue+/:\:(-1 0;0 1;1 0;0 -1));
        nxts:select from nxts where b[;0]>=0,b[;1]>=0,b[;0]<count a,
            b[;1]<count first a,not visited ./:b,(a ./:f)>=(a ./:b)-1;
        queue:exec distinct b from nxts;
        if[st[1] in queue; :d];
    ];
    '"no solution"}
d12[1;] inp
d12[2;] inp

// András Dőtsch
//helpers
dim:{-1_count@'first\[x]}
rot:{y . mod[x+til@'d;d:dim y]}
nei:{[n;m]
    M:.[(d+max abs n)#0N;s:til@'d;:;d#til prd d:dim m];
    (raze/)@'(n rot\: M) .\:s
 }
//1
I:raze inp
J:((.Q.a,"SE")!(.Q.a,"az"))I
N:nei[(-1 0;1 0;0 -1;0 1);inp]
S:0Wi^("S "!0 0N)I
W:{(2>x)+0Wi*2<=x}(-/:)."j"$(J;J N)
f:{x&min 0Wi^W+x N}
f/[S]where"E"=I
//2
S:0Wi^("a "!0 0N)J
f/[S]where"E"=I

/
András
^-- N is (flat) neighbor indices, W is step cost/penalty, f/ is basically a simplified Dijkstra.
Peter Gyorok
you don't need Dijkstra for this, just BFS will do, since all edges are of equal weight
András
The weights has nothing to do with it. You have shorter and longer paths, Dijkstra finds the shortest.
You don't need BFS either, as Dijkstra does the job too. :slightly_smiling_face:
Peter Gyorok
BFS finds the shortest path if all edges have the same weight.
And if you run Dijkstra on a graph where all the edges are the same weight, you get the exact same behavior except with more detours and more complex code.
András
My Dijkstra is {x&min@'W+x N}/, I wouldn't call that complex, but I can use whatever algorithm I see fit to solve AOC problems anyway. This worked pretty well for me.
¯\_(ツ)_/¯
Of course I know BFS does the job, but I've chosen Dijkstra, because it's more general and if the 2nd part changes the weighs, it's much easier to modify my code.
Peter Gyorok
I was also thinking that part 2 might change the weights (e.g. you figure out that you can actually climb higher than 1 but it takes some time, and the goal is now to optimize for time). But I decided I would just refactor/rewrite if that happens.


// Cillian Reilly
/I needed to do my homework on path-finding algorithms, but I'm quite happy how this turned out.
/breadth-first search
locate:{reverse(any each 1 flip\x=y)?\:1b}[inp;]
start:locate"S"
end:locate"E"
map:./[-97+6h$inp;(start;end);:;0 25]
visited:.[map&0;end;:;1]
adj:(0 1;1 0;0 -1;-1 0)+\:
filter:{[x;y;z;w]p:x ./:z;z where(&/)(not y ./:z;p>-2+x . w;not null p)}
step:{(./[y;p;:;1];p:distinct raze filter[x;y;;]./:flip(adj each z;z))}
/part 1
-1+count(not start in last@)(step[map;;].)\(visited;enlist end)
/part 2
a:{raze xc,/:'yc xc:where 0<count each yc:where each x=y}[inp;"a"]
-1+count(not any a in last@)(step[map;;].)\(visited;enlist end)

// George Berkeley
/I solved first in Python, then took quite some time to get it working in q
N:count inp 0
M:count inp
ijs:til[M] cross til N
start:raze ijs where ({"S"=inp[x][y]}.) each ijs
end:raze ijs where ({"E"=inp[x][y]}.) each ijs
inp[start 0;start 1]:"a"
inp[end 0;end 1]:"z"
v:{N#0b} each til M
p:start
q:enlist raze start,0
cnt:0
ir:{[x;y;z](y<N)&(0<=y)&(x<M)&0<=x}.
ih:{all 1>=(7h$inp[y 0][y 1])-7h$inp[x 0][x 1]}
gc:{c where not {v[x 0;x 1]} each c:b where ih[x;] each b:a where ir each a:{x+/:(1 0 1;-1 0 1;0 1 1;0 -1 1)} x}
loop:{p::q 0;cnt::last p;$[end~2#p; q::();v[p 0;p 1]; q::1_ q;{v[x 0;x 1]::1b; q::1_ q,gc x} p]}
bfs:{[start]v::{N#0b} each til M;cnt::0;q::enlist raze start,0;while[count q;loop[]];$[end~2#p;cnt;0W]}

bfs[start] / part 1
starts:ijs where ({("a"=inp[x][y])|"S"=inp[x][y]}.) each ijs
min {bfs[x]} each starts / part 2
/As usual will need to clean up and study yours for a more elegant solution. 
/I need to read up some more on the scoping rules. 
/Plus probably should have passed state between iterations rather than mutating globals. 

// Phineas
x:{(`r`c!/:(count x;count x 0)vs/:i),'([]v;w:26&1|("S",.Q.a)?v;j:i:til count v:raze x)} inp
d:([]r:0 0 1 -1;c:1 -1 0 0)
/p1
c:flip`j`k!flip raze x[`j]{y,'y,r[`j]where -2<x[y;`w]-0W^(r:(2!x)(`r`c#x y)+/:z)`w}[x]\:d
{select min c+d by j:k from ej[`j;x;y]}[t:update d:j<>k from c]/[([]j:1#?[x`v;"S"];c:0)]?[x`v;"E"]
/p2
{select min c+d by j:k from ej[`j;x;y]}[t]/[([]j:where 1=x`w;c:0)]?[x`v;"E"]
