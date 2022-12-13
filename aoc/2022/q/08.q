/https://adventofcode.com/2022/day/8

inp: read0`:input/08.txt  /trees

// Péter Györök
{a:"J"$/:/:x;
  op:{x>maxs each -1_/:-1,/:x};
  sum sum max(op a; flip op flip a; reverse flip op flip reverse a;
  reverse each op reverse each a)} inp
{a:"J"$/:/:x;
  op:{[m;x]0,/:{[m;x;y]$[y<m;x+1;1]}[m]\[0;]each -1_/:x};
  op2:{[op;m;x]prd(op[m]x; flip op[m] flip x;
      reverse flip op[m] flip reverse x;
      reverse each op[m] reverse each x)}[op];
  op3:{[op2;x;m]op2[m;x]*m=x}[op2];
  max max sum op3[a] each til 10} inp

// Zsolt Venczel
hdata: {{"J"$x} each x} each inp
vdata: flip hdata
cnt: count hdata
rng: 1+til cnt - 2
((4 * cnt) - 4) + sum sum each {{[y;x] any (
    (max x # hdata[y]) < hdata[y][x];
    (max (x+1) _ hdata[y]) < hdata[y][x];
    (max y # vdata[x]) < vdata[x][y];
    (max (y+1) _ vdata[x]) < vdata[x][y]
    )}[x] each rng} each rng

ds: {s: sum x > maxs y; $[s < count y; s+1; s]}
max max {{[y;x] (*/) (
    ds[hdata[y][x]] reverse x # hdata[y];
    ds[hdata[y][x]] (x+1) _ hdata[y];
    ds[vdata[x][y]] reverse y # vdata[x];
    ds[vdata[x][y]] (y+1) _ vdata[x]
    )}[x] each rng} each rng

// Stephen Taylor
rot: flip reverse::                        /rotate 90° clockwise
tor: reverse flip::                        /rotate 90° anticlockwise
c4: {til[4]{[f;n;t]n tor/f@t}[x]'3 rot\y}  /apply ƒx to y from 4 directions
/part 1
2 sum/max c4[(differ maxs::)'] i
/part 2
app: {y,(1,count y 0)#x}                   /append row of xs
v2: {app[0] (-1_x){count[y]&1+sum mins x>/:y}'(1_til count x)_\:x}  /view down x
2 max/prd c4[v2] i

// Tadhg Downey
{(sum/)(|/)(flip reverse(>':)maxs reverse fi;reverse(>':)maxs reverse x;flip(>':)maxs fi:flip x;(>':)maxs x)} inp
rvd: {v'[t;reverse t:til count x;nxtGr[x]]} / Row view distance
nxtGr: {[l] {[l;i] first w where (w:where[l>=l i])>i}[l]each til count l} / Next greater index
{(max/)prd(flip reverse each rvd each reverse each fi;reverse each rvd each reverse each x;flip rvd each fi:flip x;rvd each x)} inp

// Cillian Reilly
trees:3(flip reverse@)\inp
map:((reverse flip@)/)'[til 4;]
p1:not(=':)maxs@
p2:{reverse[x]&/:1+(sum mins 1_)each'y>x _\:/:y}
2 sum/max map p1 each trees
2 max/prd map p2[til count first trees;]each trees
/part 1 variants
2 sum/first 4({(flip reverse@)each(x|not(=':)maxs y;y)}.)/((2#count inp)#0;inp)

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

