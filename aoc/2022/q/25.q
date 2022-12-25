/https://adventofcode.com/2022/day/25

inp: read0`:input/25.txt

//// #adventofcode
// Péter Györök
d25:{digits:("=-012"!-2+til 5);
    s:5 vs sum 5 sv/:digits x;
    digits?{[s]if[first[s]>2; s:0,s];s+next[s>2]+(s>2)*-5}/[s]};

// András Dőtsch
f:{x[i:where 2<x]-:5;x[i-1]+:1;x}
(2 1 0 -1 -2!"210-=") (f/) 5 vs sum 5 sv/:("210-="!2 1 0 -1 -2)read0`25.txt