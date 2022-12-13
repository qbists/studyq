/https://adventofcode.com/2022/day/8

/ingestion
i:read0`:input/08.txt  /trees
t:read0`:test/08.txt  /trees

rot: flip reverse::                        /rotate 90° clockwise
tor: reverse flip::                        /rotate 90° anticlockwise
c4: {til[4]{[f;n;t]n tor/f@t}[x]'3 rot\y}  /apply ƒx to y from 4 directions

/part 1
2 sum/max c4[(differ maxs::)'] i

/part 2
app: {y,(1,count y 0)#x}                   /append row of xs
v2: {app[0] (-1_x){count[y]&1+sum mins x>/:y}'(1_til count x)_\:x}  /view down x
2 max/prd c4[v2] i


/ Sean Ang
trees: i
search:{[trees]
  (
    fn trees;
    reverse each fn reverse each trees;
    flip fn flip trees;
    flip reverse each fn reverse each flip trees 
  ) }

/p1
fn:{differ each maxs each x}
sum raze (|/) search[trees]

/p2
c:{(-1+count x)^first 1+where (1_x)>=first x}
fn:{flip{c each z _' x}[x]\[();til count x]}
max raze (*/) search[trees]

/ Cillian Reilly
m:raze({reverse each x}\)each(flip\) i
/ m:raze({reverse each x}\)each(flip\)"J"$/:/: i
2 sum/max(::;reverse each;flip;reverse flip@)@'@'[99 99#0;;:;1]each{where each differ each maxs each x}each m
2 max/prd(::;reverse each;flip;reverse flip@)@'{(reverse til 99)&1+sum each mins each 1_/:x>-1_(_[1;]\)x}each'm