/ https://adventofcode.com/2022/day/3

inp: read0`:input/03.txt

// András Dőtsch
f:sum {1 + .Q.an?first inter/[x]} each
f 2 0N#/: inp
f 0N 3# inp

// Péter Györök
d3out:{sum 1+.Q.an?raze distinct each x};
{p:((count each x)div 2)cut'x; d3out p[;0]inter'p[;1]} inp
d3out(inter/)each 3 cut inp

// Cillian Reilly
sum each 1+.Q.an?('[first;inter/])each'(2 0N#/:;0N 3#)@\:inp 

// George Berkeley
ps:.Q.a,.Q.A
sum {1+where ps=first (first t) inter last t:(0,div[;2] count x) _ x} each inp / part 1
sum {1+where ps=first (inter/)x} each (3*til div[;3] count inp) _ inp / part 2

//Tadhg Downey
pr:a!1+til count a:.Q.a,.Q.A
f:{sum raze {distinct (inter). x(0,floor c%2)_til c:count x}each pr read0 x}
g:{sum {distinct (inter/) x}each (3*til "j"$count[l]%3)_l:pr read0 x}

// Stephen Taylor
/ part 1
err: {first x where x in y} . {(2,count[x]div 2)#x} ::  / identify error
priorities: " ",.Q.a,.Q.A

sum priorities?err each inp

/ part 2
groups: {_[;x]where count[x]#1 0 0} inp  / group in threes
badge: first distinct ({x where x in y}/) ::  / identify badge
sum priorities?badge each groups

// Sujoy Rakshit
d:(.Q.a!1+til 26),.Q.A!27+til 26
f:{#[(0N;div[count x;2])] x}
/Part 1
sum ('[;]/[(d;first;(inter/);f)] each inp)
/Part 2
sum ('[;]/[(d;first;inter/)] each 0N 3#inp)

// Ajay Rathore
f:{sum 1+('[distinct;inter/]').Q.an?x}
f 2 0N#/: inp
f 3 cut inp

// David Crossey
score:(string .Q.a,.Q.A)!(1+til 52)
(sum score distinct each (inter/)@/:) each (ceiling[count'[inp]%2] cut' inp;3 cut inp)