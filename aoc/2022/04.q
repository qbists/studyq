/https://adventofcode.com/2022/day/4

/ingestion
ass:"J"$''"-"vs''","vs'read0`:input/04.txt  /assignments

/part 1
contains:{$[any b:x=y;1b;x[1]<y 1]}. desc ::  / one range contains another
sum contains each ass

/part 2
overlaps:{x[0]<=y 1}. desc ::  / one range overlaps another
sum overlaps each ass
