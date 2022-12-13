/https://adventofcode.com/2022/day/10

/ ingestion
t: read0`:test/10.txt
i: read0`:input/10.txt

/part 1
X: {1+\raze{((0,;0^)@null x)@'x}"J"$5_'x} i  /register X at each cyle
sum{x*y x-2}[20 60 100 140 180 220] X

/part 2
show 40 cut".#"{(til[count x]mod 40)within'-1 1+/:0^prev x} X
