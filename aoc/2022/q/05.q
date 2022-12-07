/https://adventofcode.com/2022/day/5

/ingestion
ce:count each
`Start`Moves set'{
  s: trim each flip x[;where count[first x]#0100b]; /stacks
  m: flip(" J J J";" ")0:y; /moves
  (s;m) }. -1 1_'{(0,where not ce x)_ x}read0`:input/05.txt

Stacks: Start

/see:{flip reverse each max[ce x]$'reverse each x}
/show see Stacks

/part 1
move1: {[from;to]
  Stacks[to]:first[Stacks from],Stacks[to];
  Stacks[from]: 1 _ Stacks[from]; } 

move: {do[x;move1 . (y;z)-1];}. 

move each Moves;
first each Stacks

/part 2
moven: {[n;from;to]
  Stacks[to]: (n#Stacks[from]),Stacks[to];
  Stacks[from]: n _ Stacks[from]; }.

Stacks: Start
moven each Moves-\:0 1 1;
first each Stacks