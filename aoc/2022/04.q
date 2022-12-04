/https://adventofcode.com/2022/day/4

/ingestion
ass:desc each "J"$''"-"vs''","vs'read0`:input/04.txt  /assignments

/part 1
sum ({$[any b:x=y;1b;x[1]<y 1]}.) each ass

/part 2
sum ({x[0]<=y 1}.) each ass
