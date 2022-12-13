/ https://adventofcode.com/2022/day/3

/ part 1
err: {first x where x in y} . {(2,count[x]div 2)#x} ::  / identify error
priorities: " ",.Q.a,.Q.A

rucksacks: read0`:input/03.txt
sum priorities?err each rucksacks

/ part 2
groups: {_[;x]where count[x]#1 0 0} rucksacks  / group in threes
badge: first distinct ({x where x in y}/) ::  / identify badge
sum priorities?badge each groups