/https://adventofcode.com/2022/day/6

inp: first read0`:test/06.txt

// András Dőtsch
4 14{x+first where x=count@'distinct@'x#'(1_)\[y]}\:inp

// Péter Györök
d6:{[c;x]{[c;x]c+first where c=count each distinct each
    x neg[c-1]_til[c]+/:til count x}[c;x]}
4 14 d6\:inp

// Zsolt Venczel
fn: {[d; n] n + first where n = {[d;n;i] count distinct n # i _ d}[d;n] each til count d}
inp fn/:4 14

// Cillian Reilly
{y+?[;y]('[count;distinct])each flip(y-1)next\x}[inp;]each 4 14

// Stephen Taylor
f: {x+?[;x](count distinct::)each y (til count[y]-1)+\:til x}
g: {x+{x>count distinct y z+til x}[x;y;](1+)/0}  / alternative
/part 1 & 2
4 14 f\:inp   / \ts:100 => 289 721072
4 14 g\:inp   / \ts:100 => 470 1296


// Nathan Swann
// Next until count of distinct first 4 characters is 4
// Original string count - Next string count + 4
h:{c:count x; cn:count trim (next/) [{y<>count distinct y$x}[;y];x]; y+c-cn}
inp h/:4 14  / Parts 1 & 2

// Sean Ang
mtake:{neg[y]sublist x,z}\[();;]
fn:{1+first where x=count each distinct each mtake[x;y]}
4 14 fn\:inp

// Tom Ferguson & Nick Psaris
u:{[n;x;i] not n=count distinct x i}
f:{[n;x]n+first u[n;x] (1+)/ til n}
4 14 f\:inp

/
as Ajay also pointed out the space is pretty small
so as a side-challenge it's interesting to see if we can get some more speed out 
and it's not obvious

q)\ts:100 f[14]x
289 1376

q)a:{[n;x] n+?[;b]{x?x}each flip x til[count x]+/:b:til n}
q)\ts:100 a[14]x
166 1032912

and most of that is coming from {x?x}

q)U:{[n;x;i] not n~a?a:x i}
q)F:{[n;x]n+first U[b;x] (1+)/ b:til n}
q)\ts:100 F[14]x
220 1008
\

// David Crossey
raze {x+flip[count each' distinct each' x#''{1_'x}\[inp]]?'x} each 4 14