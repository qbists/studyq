/https://adventofcode.com/2022/day/5

inp: read0`:input/05.txt

// András Dőtsch
s:trim@'flip inp[til 8;1+4*til 9]
m:{0 -1 -1 + get x where x in .Q.n," "} each 10_inp
f:{[o;s;x] @/[s;x 1 2;(x[0]_;o[x[0]#s x 1],)]}
first each s f[reverse]/ m
first each s f[::]/ m


// Cillian Reilly
i:flip -1 1 1*0 -1 -1+(6#" I";" ")0:(1+inp?"")_inp
s:trim flip reverse((-1+inp?"")#inp)[;1+4*til 9]

last each{@/[x;y 2 1;(,;:);](reverse y[0]#;y[0]_)@\:x y 1}/[s;i]
last each{@/[x;y 2 1;(,;:);](y[0]#;y[0]_)@\:x y 1}/[s;i]

animate:{1"\033[H\033[J";-1 {@/[raze"[",'x,'"]";0 2+/:3*where null x;:;" "]}each reverse flip(7h$first system"c")$x;system"sleep 0.5";}
{animate o:@/[x;y 2 1;(,;:);](y[0]#;y[0]_)@\:x y 1;o}/[s;i];

// Péter Györök
d5:{[op;x]a:"\n\n"vs"\n"sv x;
    st:reverse each trim flip(4 cut/:-1_"\n"vs a 0)[;;1];
    ins:0 -1 -1+/:"J"$(" "vs/:"\n"vs a 1)[;1 3 5];
    st2:{[op;x;y]x[y 2],:op neg[y 0]#x[y 1];
        x[y 1]:neg[y 0]_x[y 1];x}[op]/[st;ins];
    last each st2}
d5[reverse] inp
d5[::] inp

// Zsolt Venczel
cont: trim each flip {{x[1]} each 4 cut x} each 8 # inp
m: {{(first "J"$x[1]; (first "J"$x[3])-1; (first "J"$x[5])-1)} " " vs x} each 10 _ inp
fn: {[t] first each cont {[t;c;m] @[@[c;enlist m[2];{[t;c;m;x] (t m[0] # c[m[1]]),c[m[2]]}[t;c;m]]; enlist m[1];{[c;m;x] m[0] _ c[m[1]]}[c;m]]}[t]/ m}
fn[reverse]
fn[::]

//Tadhg Downey
getInput:{[l]
  l:(0,where 0=count each l)_ l;
  state:trim flip reverse state[;where not 10=.Q.n?last state:l 0];
  moves:"J"$string(`$" "vs'1_ l 1)[;1 3 5];
  (state;moves) } 
{i:getInput x;last each iter/[i 0;i 1]} inp
{i:getInput x;last each iter2/[i 0;i 1]} inp

// Helpers
iter:{[acc;move] add[;move;] . sub[acc;move]}
add:{[acc;move;val] @[acc;move[2]-1;,;val]}
sub:{[acc;move] val:reverse (m:neg move 0)#@[acc;move[1]-1];(@[acc;move[1]-1;_[m]];val)}
sub2:{[acc;move] val:(m:neg move 0)#@[acc;move[1]-1];(@[acc;move[1]-1;_[m]];val)}
iter2:{[acc;move] add[;move;] . sub2[acc;move]}


// Stephen Taylor
ce:count each
`Start`Moves set'{
  s: trim each flip x[;where count[first x]#0100b]; /stacks
  m: flip(" J J J";" ")0:y; /moves
  (s;m) }. -1 1_'{(0,where not ce x)_ x} inp

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