/https://adventofcode.com/2022/day/6

input:read0`:input/06.txt

// András Dőtsch
4 14{x+first where x=count@'distinct@'x#'(1_)\[y]}\:first inp

// Péter Györök
d6:{[c;x]{[c;x]c+first where c=count each distinct each
    x neg[c-1]_til[c]+/:til count x}[c;first x]}
d6[4] inp
d6[14] inp

//Zsolt Venczel
fn: {[d; n] n + first where n = {[d;n;i] count distinct n # i _ d}[d;n] each til count d}
fn[;4] first inp
fn[;14] first inp

// Cillian Reilly
{y+?[;y]('[count;distinct])each flip(y-1)next\x}[first inp;]each 4 14

// Stephen Taylor
f: {x+?[;x](count distinct::)each y (til count[y]-1)+\:til x}
g: {x+{x>count distinct y z+til x}[x;y;](1+)/0}

/part 1 & 2
4 14 f\:first input
4 14 g\:first input

/
q)\ts:100 4 14 f\:first input
289 721072
q)\ts:100 4 14 g\:first input
470 1296
\

// Nathan Swann
// Next until count of distinct first 4 characters is 4
// Original string count - Next string count + 4
h:{c:count x; cn:count trim (next/) [{y<>count distinct y$x}[;y];x]; y+c-cn}

// Part 1
h[inp;4]

// Part 2
h[inp;14]
