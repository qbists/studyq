/https://adventofcode.com/2022/day/9

/ ingestion
test: read0`:test/09.txt
inp: read0`:input/09.txt

is: 1 4#4 0 4 0                                         /states: H & T, row col row col

/part 1
MD: "DURL"!0 1 cross 1 -1                               /move => r/c; increment
move: {[d;s;m]s,1_("J"$m 2)move1[d m 0;]\last s}[MD;;]
move1: {follow @[y;;+;]. x}                             /move 1 space
follow: {x+0 0,signum{x*any 1<abs x}.[-]2 cut x}        /T follows H

s: is move/inp  /states
count distinct s[;2 3] 


ds: {.[;;:;]/[;2 cut x;"HT"] .[5 6#".";4 0;:;"s"]}      /display state
