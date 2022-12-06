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
