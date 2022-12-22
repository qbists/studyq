/https://adventofcode.com/2022/day/9

inp: read0`:test/09.txt

// Cillian Reilly and Nick Psaris
s:sums("RLDU"!(1 0;-1 0;0 -1;0 1))where (!/) ("CJ";" ")0:inp
move:{$[1<max abs d:y-x;x+signum d;x]}\[0 0;]

/ count distinct move s
/ count distinct 9 move/s
/both parts
(count distinct@)each(9 move\s)1 9

\
// András Dőtsch revised by Nick Psaris
i:where (!/) ("CJ";" ")0:inp
s:sums ("UDLR"!(0 -1;0 1;-1 0;1 0)) i
f:{$[2 in abs y-:x;x+1&-1|y;x]}
count distinct 1 {0 0 f\ x}/ s
count distinct 9 {0 0 f\ x}/ s

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

// Balaji
/load directions
steps: flip("CJ";" ")0: inp
/rope head follows directions
head:(enlist 0 0) {x, last[x]+/:(mv y 0)*/: 1+til y 1}/ steps
/tail follows head
f: {$[1<>max abs d:y - x;x+signum d;x]}\
/part 1
tail: f head
count group tail
/part 2 
/ each knot tail becomes head of next knot
lastknot:9 f/ head
count group lastknot

// Ahmed Shabaz
t:flip`m`n!raze@'($[`;];$["J";])@'flip" "vs'inp
d:`L`R`U`D!(-1 0; 1 0; 0 1; 0 -1)
t:update sums H from ungroup update H:{y#enlist d[x]}'[m;n] from t
f:{$[any 1<abs y-x; x+signum y-x;x]}\[0 0;]
/part 1
count distinct exec f H from t
/part 2
count distinct ?[`t;();();9(`f;)/`H]

// András Dőtsch
/revised by Nick Psaris
i:where (!/) ("CJ";" ")0:inp
s:sums ("UDLR"!(0 -1;0 1;-1 0;1 0)) i
f:{$[2 in abs y-:x;x+1&-1|y;x]}
count distinct 1 {0 0 f\ x}/ s
count distinct 9 {0 0 f\ x}/ s