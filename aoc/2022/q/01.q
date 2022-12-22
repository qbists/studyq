/ https://adventofcode.com/2022/day/1

/ingestion
inp: read0`:input/01.txt
loads: sum each{(0,where null x)_ x}"I"$inp

loads: value {"(sum ",x,")"} ssr[;"  ";";sum "]" "sv inp  /Sean Ang
loads: value each"++"vs"+"sv inp                          /Cillian Murphy
loads: desc deltas asc s*(~':)s:sums"J"$inp               /Cillian straight-vector
loads: (sum get::) each "\n\n"vs"c"$read1 `:test/01.txt   /Nick Psaris

/ part 1 & part 2
(first;sum 3#::)@\:desc loads


// Péter Györök
d1:{sum each"J"$"\n"vs/:"\n\n"vs"\n"sv x};
//d1:{sum each{(0,where null x)cut x}"J"$x};
max d1 inp
sum 3#desc d1 inp

// András Dőtsch
i:sum@'get@'",,"vs","sv read0`:01.txt
max i           //1
sum 3#desc i    //2

// Tadhg Downey
f: {max sum each (0,where 0N=l)_l:"J"$read0 x}
g: {sum 3#desc sum each (0,where 0N=l)_l:"J"$read0 x}

// Zsolt Venczel
data: "J"$inp
indexes: where 0N ~/: data
deer: (enlist first[indexes] # data), 1 _/: indexes _ data
maxCal: max sum each deer
top3: sum 3 # desc sum each deer

// Roman Pszonka
t:"I"$inp
sorted:desc sum each _[0,1+where t=0N;t] / split, sum each section, and sort
sorted[0] / first element
sum sorted[til 3] / sum of first 3 elements

// Attila Vrabecz
x:"J"$inp
max(0|+)scan x
sum 3#desc{x*0=next x}(0|+)scan x 

// Mark Street
max sum each (where null i) cut i:0N,"J"$inp

// Muneish Adya
//part 1
(l:"J"$inp);max l:(+/')(0,(&)0N=l)_l
//part 2
sum 3#desc l

// Cillian Reilly
(max;sum 3#desc@)@\:deltas asc s*(~':)s:sums"J"$inp

// Sean Ang
max value {"(sum",x,")"} ssr[;"  ";";sum "] " " sv inp

// David Crossey
(first;sum 3#desc@)@\:sum each where[null 0N,r] _ r:"J"$read0 inp