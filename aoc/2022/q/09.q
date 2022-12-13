/https://adventofcode.com/2022/day/9

inp: read0`:input/09.txt

// András Dőtsch
p:(1#`:) {$[y~"$ cd /";1#x;y~"$ cd ..";-1_x;y like"$ cd *";x,.Q.dd[last x]`$5_y;x]} \ inp
s:"J"$first@'" "vs/:inp
d:exec sum s by p from ungroup ([]p;s)
sum d where d<=100000
min d where d>=d[`:]-40000000
/ ^-- ungroup and exec idea from Péter Györök

// Péter Györök
d9:{[t;x]a:" "vs/:x;
    dir:raze a[;0];
    amt:"J"$a[;1];
    dir2:dir where amt; //raze amt#'dir;
    mH:("UDLR"!(0 -1;0 1;-1 0;1 0))dir2;
    pH:enlist[0 0],sums mH;
    step1:{d:y-x;if[1<max abs d;x:x+signum d];x};
    step:step1\[0 0;];
    pT:step/[t;pH];
    count distinct pT};
d9p1:{d9[1;inp]};
d9p2:{d9[9;inp]};

// Zsolt Vancsel
data: {{(first x[0];"J"$x[1])}[" " vs x]} each inp

dst: {$[any 1 < abs x - y; {$[x=-2;-1;x=2;1;x]} each -1 * x - y; (0; 0)]}

path: raze {{[x;y] $["R" ~ x; (1; 0); "U" ~ x; (0; -1); "D" ~ x; (0; 1); "L" ~ x; (-1; 0); (0; 0)]}[x[0]] each til x[1]} each data
cntPath: {t:: (0; 0); h:: (0; 0); count distinct {h:: h+x; m: dst[t; h]; t:: t+m; t} each x}

nodes: 9
n: {(0; 0)} each til nodes
p: {(::)} each til nodes

{p[0]:: path; {t:: (0; 0); h:: (0; 0); p[x]:: {h:: h+y; m: dst[t; h]; t:: t+m; m}[x] each p[x-1]} each 1 _ til nodes}[]

ans1: cntPath[path]
ans2: cntPath[p[nodes-1]]

// Cillian Reilly
s:sums(`R`L`D`U!(1 0;-1 0;0 -1;0 1))raze(#'). reverse("SJ";" ")0:inp
move:{$[1<max abs d:y-x;x+signum d;x]}\[0 0;]

count distinct move s
count distinct 9 move/s
/both parts
(count distinct@)each(9 move\s)1 8

// George Berkeley
s:{" " vs x} each inp
f:{{(0 1;0 -1;-1 0;1 0)"UDLR"?x}("J"$y)#x}.
path:sums raze f each s
g:{$[not any 2=abs y-x; enlist x; enlist x+signum y-x]}
r:{{x,g[last x;y]}/[enlist(0 0);x]}
count distinct r path 
count distinct r/[9;path]

// Stephen Taylor
/
/works for test case but not puzzle input
is: 1 4#4 0 4 0                                         /states: H & T, row col row col

/part 1
MD: "DURL"!0 1 cross 1 -1                               /move => r/c; increment
move: {[d;s;m]s,1_("J"$m 2)move1[d m 0;]\last s}[MD;;]
move1: {follow @[y;;+;]. x}                             /move 1 space
follow: {x+0 0,signum{x*any 1<abs x}.[-]2 cut x}        /T follows H

s: is move/inp  /states
count distinct s[;2 3] 

ds: {.[;;:;]/[;2 cut x;"HT"] .[5 6#".";4 0;:;"s"]}      /display state
\

