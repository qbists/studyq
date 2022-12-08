/https://adventofcode.com/2022/day/8

/ingestion
i:read0`:input/08.txt  /trees

rot: flip reverse::                        /rotate 90° clockwise
tor: reverse flip::                        /rotate 90° anticlockwise
app: {y,(1,count y 0)#x}                   /append row of xs
pre: {#[1,count y 0;x],y}                  /prepend row of xs
c4: {til[4]{[f;n;t]n tor/f@t}[x]'3 rot\y}  /apply ƒx to y from 4 directions

/part 1
v1: {pre[1b] .[>]1_'1(prev maxs::)\x}      /visibility from top
sum raze max c4[v1] i

/part 2
v2: {app[0] (-1_x){count[y]&1+sum mins x>/:y}'(1_til count x)_\:x}  /view down x
max raze prd c4[v2] i
