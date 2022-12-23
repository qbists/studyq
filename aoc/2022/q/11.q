/https://adventofcode.com/2022/day/11

// ingestion
inp: read0`:test/11.txt

// Rory Kemp & Stephen Taylor
/initial state with count
is: update c:0 from flip `W`o`n`t`f!flip
  {get each(raze 4_;raze("{[old]";;;;"}").-3#;last;last;last)@'" "vs'1_6#x}
  each (0,1+where not count each inp)_inp

turn: {[f;s;i]
  t: s i;                                    /turn dict
  w: f .[@]t`o`W;                            /worry levels
  d: w group t `f`t not w mod t`n;           /distribution
  .[;(i;`W);0#] .[;(key d;`W);{x,y};value d] .[;(i;`c);+;count w] s }

round: {[f;s] s turn[f]/til count s}
prd 2#desc@[;`c]20 round[div[;3]]/is         /part 1
prd 2#desc@[;`c]20 round[mod[;prd is`n]]/is  /part 2


/
//Péter Györök
d11:{[d;r;x]
    a:"\n"vs/:"\n\n"vs"\n"sv x;
    it:"J"$4_/:" "vs/:a[;1]except\:",";
    its:raze it;
    itm:(0,-1_sums count each it)cut til count its;
    op0:6_/:" "vs/:a[;2];
    op:?[op0[;1]like"old";count[op0]#{x*x};
        (("*+"!(*;+))op0[;0;0])@'"J"$op0[;1]];
    dv:"J"$last each" "vs/:a[;3];
    throw:reverse each"J"$last each/:" "vs/:/:a[;4 5];
    pdv:prd dv;
    st:(itm;its;count[it]#0);
    step:{[throw;op;d;dv;pdv;st;i]
        itm:st 0;its:st 1;tc:st 2;
        ii:itm i;
        tc[i]+:count ii;
        w:((op[i]@'its ii)div d)mod pdv;
        its[ii]:w;
        itm:@[;;,;]/[itm;throw[i]0=w mod dv[i];ii];
        itm[i]:"j"$();
        (itm;its;tc)}[throw;op;d;dv;pdv];
    round:step/[;til count itm];
    mb:last round/[r;st];
     prd 2#desc mb}
d11[3;20] inp 
d11[1;10000] inp 

// András Dőtsch
c:{`item`op`cond`if1`if0`cnt!get'[(
    "(),",17_x 1;
    "{[old]",18_x[2],"}"),
    last@'" "vs/:x 3 4 5],
    0
 } each 7 cut inp
f:{[c;x]
    d:c x;
    item:mw d[`op]d[`item];
    c[x;`item]:0#0;
    c[x;`cnt]+:count item;
    c[d`if1;`item],:item where 0=item mod d`cond;
    c[d`if0;`item],:item where 0<>item mod d`cond;
    c
 }
mw:div[;3]
prd 2#desc @[;`cnt] c f/ (20*8)#til 8
mw:mod[;prd c`cond]
prd 2#desc @[;`cnt] c f/ (10000*8)#til 8

// Zsolt Venczel
d:{(
    "J"${", " vs x[1]} ": " vs x[1];
    {parse "{[old] ",x[1],"}"} " = " vs x[2];
    "J"$last " " vs x[3];"J"$last " " vs x[4];"J"$last " " vs x[5]
    )} each 7 cut inp

calc: {
    mi::{x[0]} each d;
    mr::(count d) # 0;
    {{{[p;m1;m2;db;ni]
        mr[p]:: mr[p] + 1;
        np: $[(ni mod db)=0; m1; m2];
        mi:: .[.[mi; enlist np; :; mi[np],ni]; enlist p; :; 1_mi[p]];
        }[x; d[x] [3]; d[x] [4]; d[x] [2]]
             each wlFn[d[x]] each mi[x]
    } each til count d} each til roundN;
    prd 2 # desc mr
 }

roundN: 20
wlFn: {x[1][y] div 3}
ans1: calc[]

roundN: 10000
mdc: prd {x 2} each d
wlFn: {x[1][y] mod mdc}
ans2: calc[]

// Cillian Reilly
/items
items:(),/:value each 18_/:inp 1+7*til sum inp like"*Monkey*"
operations:value each"{[old]",/:(19_/:inp 2+7*til sum r like"*Monkey*"),\:"}"
divisors:value each last each" "vs/:inp 3+7*til sum inp like"*Monkey*"
to:value each'last each'" "vs/:/:inp 4 5+/:7*til sum inp like"*Monkey*"
/part 1
f:{.[;0,y;:;`long$()]{.[x;0,y 0;,;y 1]}/[x;]{,'[;w]x[3]not 0=mod[;x 2]w:floor %[;3]x[1]x 0}x[;y]}
prd 2#desc sum raze(8 cut 64#100000000b)*/:8 cut count each'first each -1_raze 20{{f\[x;til count first x]}last x}\enlist(items;operations;divisors;to)
/part 2
f:{@[;z 0;:;count[x]#enlist 7h$()]@/[y;;,';flip w]m:z[2]2 not/@[;z 0]w:mod[;x]z[1]y z 0}
prd 2#desc sum{x*count[x]#(2#c)#1b,(c:count first x)#0b}
  count[items]cut first each count each'
  raze enlist[flip items mod/:divisors],-1_f[divisors]\[flip items mod/:divisors;]
  raze 10000#enlist(til count items),'flip(operations;to)

// George Berkeley 
/Part 1:
s:{5#1_ x} each 7 cut read0`:/tmp/aoc11.txt
l:{(),value last ":" vs x 0} each s
cnts:(count l)#0
g:{{[fs;x] (x*c;x+c:x^"J"$fs 1)("*+")?fs 0} -2#" " vs x 1} each s
m:{{[x;y;z;w]w,(z;y)0=mod[w:div[w;3];x]}.{"J"$last " " vs y x}[;x] each (2;3;4)} each s
move:{o:first l x;l[x]:1_ l[x];u:m[x] g[x] o;l[u 1],:u 0;x}
mmove:{cnts[x]+:count l x;{move x}/[count l x;x]}
{mmove each x}/[20;til count l]
prd 2#desc cnts
/Part 2:
s:{5#1_ x} each 7 cut read0`:/tmp/aoc11.txt
l:{(),value last ":" vs x 0} each s
cnts:(count l)#0
N:prd {"J"$ last " " vs x 2} each s
g:{{[fs;x] (x*c;x+c:x^"J"$fs 1)("*+")?fs 0} -2#" " vs x 1} each s
m:{{[x;y;z;w]w,(z;y)0=mod[w:mod[w;N];x]}.{"J"$last " " vs y x}[;x] each (2;3;4)} each s
move:{o:first l x;l[x]:1_ l[x];u:m[x] g[x] o;l[u 1],:u 0;x}
mmove:{cnts[x]+:count l x;{move x}/[count l x;x]}
{mmove each x}/[10000;til count l]
prd 2#desc cnts

// Rory Kemp
m:{get each(raze 4_;,[;"}"]"{[old]",raze -3#;l;l;l:first reverse@)@'" "vs'1_"\n"vs x}each"\n\n"vs read1`:11.txt
turn:{`W`o`n`t`f set'x y;c[y]+:count W;.[;y,0;:;0#0].[x;(key d;0);{x,y};value d:w group(f,t)@0=(w:q o W)mod n]}
run:{c::m:'0;q::x;y{x turn/til count x}/m;prd 2#desc c}
run[div[;3];20]        / part 1
run[mod[;prd m@'2];20] / part 2

//Stephen Taylor
/part 1
is: {  /initial state
  w: get each .[;(::;1)]":"vs'x[;1]; /item worry levels
  o: get each
    ({"{",x,"}"}ssr[;"old";"x"]except[;" "]::) 
    each .[;(::;1)] "="vs'x[;2]; /op
  d: first("   J";" ")0:2_'x[;3]; /divisor
  t: get each raze each -2#''x[;4 5]; /to monkeys
  n: count[w]#0; /# inspected
  ([]w;o;d;t;n) } {(where x like "Monkey *")_ x} ::


monkey: {[rlx;s;i]  /relaxation; state; monkey#
  m: s i;  /monkey dict
  w: div[;rlx]m[`o]@m`w; /new worry levels
  t: w group m[`t]0<mod[;m`d] w; //what to throw where
  s: .[;(i;`w);0#] .[;(i;`n);count[w]+] .[s;(key t;`w);{x,y};value t];  /throw
  s }

round: {[rlx;s] s monkey[rlx]/til count s}

prd 2#desc@[;`n] 20 round[3]/is test

/part2
is: {  /initial state
  d: first("   J";" ")0:2_'x[;3]; /divisor
  w: (mod\:[;d](),get ::)each .[;(::;1)]":"vs'x[;1]; /item worry levels
  o: get each
    ({"{",x,"}"}ssr[;"old";"x"]except[;" "]::) 
    each .[;(::;1)] "="vs'x[;2]; /op
  t: get each raze each -2#''x[;4 5]; /to monkeys
  n: count[w]#0; /# inspected
  ([]w;o;d;t;n) } {(where x like "Monkey *")_ x} ::

monkey: {[s;i]  /relaxation; state; monkey#
  m: s i;  /monkey dict
  w: mod\:[;s`d] m[`o]@m`w; /new worry levels
  c: (s`d)?m`d; 
  t: w[;c]@group m[`t]@0<w[;c]; //what to throw where
  s: .[;(i;`w);0#] .[;(i;`n);count[w]+] .[s;(key t;`w);{x,y};value t];  /throw
  s }

round: {x monkey/til count x}

prd 2#desc@[;`n] fs: 10000 round/is test


// Balaji
ii:{`init`func`test`true`false!({(),get x};{get "{[old]",x,"}"};get;get;get)@'(last') vs'[":=   "] 1_"\n" vs x} each  "\n\n" vs -1_"c"$read1 `:input/11.txt;
init:{update s:init,ninsp:0 from `ii}; /init
p12:{[]{p:ii x;ii[x;`ninsp]+:count nxti:p[`true`false] 0<mod[;p`test] n:relieve p[`func] each p[`s];ii[x ;`s]:`long$(); {ii[x;`s],:y}./:nxti,'n} each til count ii;}

relieve: div[;3] /p1
init`;20 p12/`; prd 2#desc ii`ninsp

relieve: mod[;prd ii`test] /p2: all operations are invariant to this, prevents overflow
init`;10000 p12/`; prd 2#desc ii`ninsp

// Sean Ang
/mine looks pretty much the same as yours Balaji!
f:`:d11eg.txt
f:`:d11.txt
`state`op`test`pass set' flip {get each(last": "vs x[1];"{[old]",(last"="vs x[2]),"}";last" "vs x[3];" "sv last each " "vs'x[5 4])} each 7 cut read0 f

fn:{[w;x;y]
    cnt[y]+:count t:0=mod[;test[y]]s:w op[y]x[y];
    x[y]:0#0; d:s group pass[y]t;
    @[x;key d;{x,y};value d]
    }

p1:fn[div[;3];]
cnt:(count state)#0;20{x p1/til count x}/state
prd 2#desc cnt

p2:fn[mod[;prd test];]
cnt:(count state)#0;10000 {x p2/til count x}/state
prd 2#desc cnt

