/https://adventofcode.com/2022/day/15

/ inp: read0`:input/15.txt
/ Y: 2000000; LIM: 4000000
inp: read0`:test/15.txt
Y: 10; LIM: 20  / pts 1 & 2

`Sx`Sy`Bx`By set' flip {get @[x;where not x in "-0123456789";:;" "]}each inp;
m: sum abs (Sx-Bx;Sy-By) / manhattan dists
/ part 1
count except[;Bx where By=Y] distinct raze {$[y<0;();x-y-til 1+2*y]}'[Sx;m-abs Sy-Y]
/ part 2
peri: raze 1 1 -1 -1,''(Sy-Sx+m+1; Sy-Sx-m+1; Sy+Sx+m+1; Sy+Sx-m+1)
int: distinct raze peri {r:0-1%(%/)x-y; (r; sum x*r,1)}\:/: peri
sum 4000000 1*floor first int where {all raze(x=floor x;0<=x;x<=LIM;m<sum abs(Sx;Sy)-x)} each int

\
`S`B set'flip(get'')(":"vs')inp except\:"S=,",.Q.a;          / source/beacon pairs
D: sum each abs S-B                                          / distances scanned
nB: sum (distinct B)[;1]=Y                                   / # beacons on line Y
/ merge contiguous ranges
merge: .[{$[2>y[0]-last[x] 1; .[x;(count[x]-1;1);|;y 1]; x,enlist y]}/] (1#;1_)@\:asc ::

/ intersects: {(x+o*\:-1 1)where 0<=o:D-abs y-Y}. flip ::
/ -[;nB] sum{1+y-x}. flip merge intersects S                   / part 1

/ I: S[;0]+/:{x*(2*0<=x)#\:\:-1 1}D-/:abs S[;1]-\:/:til LIM    / intersections
/ r: {flip(0|;LIM&)@'flip merge x where 2=count each x}each I  / ranges by line
/ i: where not (1 2#0,LIM)~/:r                                 / rows with lacunae
/ sum each 4000000 1*/:raze (lac each r i),\:'i                / part 2

intersects: {(S[;0]+o*\:-1 1)where 0<=o:D-abs S[;1]-x}
-[;nB] sum{1+y-x}. flip merge intersects Y                   / part 1
/ {(x~merge flip(0|;LIM&)@'flip intersects y)and y<LIM}[1 2#0,LIM](1+)/0
/part 2
lac: {raze -1 -1 {1+y[1]+til x[0]-y[1]+1}':,[;1 2#LIM+1] x}  / lacunae in ranges
sum each 4000000 1*/:.[,'](lac;-1+)@'
  {x~y 0}[1 2#0,LIM] {(merge flip(0|;LIM&)@'flip intersects x 1;1+x 1)}/(1 2#0,LIM;0)


//// #adventofcode

// Péter Györök
d15p1:{[line;x]a:"J"$2_/:/:(" "vs/:x except\:",:")[;2 3 8 9];
    range:sum each abs a[;0 1]-a[;2 3];
    nr:range-abs line-a[;1];
    xs:flip a[;0]+/:(neg nr;nr);
    xs:asc xs where 0<=nr;
    merged:{$[last[x][1]>=y[0];x[count[x]-1;1]|:y[1];x,:enlist y];x}/[1#xs;1_xs];
    overlap:sum sum(distinct a[;2]where line=a[;3]) within/:merged;
    sum[1+merged[;1]-merged[;0]]-overlap};
// Péter Györök
d15p2:{[line;x]
    lim:2*line;
    a:"J"$2_/:/:(" "vs/:x except\:",:")[;2 3 8 9];
    range:sum each abs a[;0 1]-a[;2 3];
    cover:{[a;range;lim;line]
        if[0=line mod 1000;show line];
        nr:range-abs line-a[;1];
        xs:flip a[;0]+/:(neg nr;nr);
        xs[;0]|:0; xs[;1]&:lim;
        xs:asc xs where 0<=nr;
        {$[last[x][1]>=y[0]-1;x[count[x]-1;1]|:y[1];x,:enlist y];x}/[1#xs;1_xs]
        }[a;range;lim]each til 1+lim;
    c:where 2=count each cover;
    cc:1+cover[c;0;1];
    c+4000000*cc};

// András Dőtsch
//part 1
/ i:j:get@'(.Q.n!.Q.n) inp
/ i[;0 2]+:1000000
/ Y:2000000
/ L:10000000#"."
/ f1:{
/     s:x 0 1;b:x 2 3;
/     d:sum abs s-b;
/     r:s[0]+(abs[Y-s 1]-d;d-abs[Y-s 1]);
/     if[.[<=]r;L[r[0]+til 1+r[1]-r 0]:"#"];
/     if[Y=b 1;L[b 0]:"B"];
/  }
/ f1 each i;
/ 0+sum"#"=L
/ //part 2
/ L1:L2:L3:L4:([]x:();y:())
/ f2:{[x0;y0;x1;y1]
/     d:1+abs[x0-x1]+abs[y0-y1];
/     l:til d;
/     `L1 upsert ([]x:x0+l    ;y:(y0-d)+l);
/     `L2 upsert ([]x:(x0+d)-l;y:y0+l);
/     `L3 upsert ([]x:x0-l    ;y:(y0+d)-l);
/     `L4 upsert ([]x:(x0-d)+l;y:y0-l);
/  }
/ .[f2] each j;
/ sum 4000000 1 * (raze/) L1 inter L2 inter L3 inter L4

//// Vector Dojo

// Rory Kemp
`sx`sy`bx`by set' flip {get @[x;where not x in "-0123456789";:;" "]}each inp;
m:sum abs (sx-bx;sy-by) / manhattan dists
{count except[;bx where by=x] distinct raze {$[y<0;();x-y-til 1+2*y]}'[sx;m-abs sy-x]} 2000000 / part 1
/ NB: wrong result for test.txt
peri:raze 1 1 -1 -1,''(sy-sx+m+1; sy-sx-m+1; sy+sx+m+1; sy+sx-m+1)
int:distinct raze peri {r:0-1%(%/)x-y; (r; sum x*r,1)}\:/: peri
sum 4000000 1*floor first int where {all raze(x=floor x;0<=x;x<=4000000;m<sum abs(sx;sy)-x)} each int

//// https://github.com/CillianReilly/AOC

// Cillian Murphy
sb:2 cut/:flip "J"$-1_/:/:last each'"="vs/:/:("  **    **";" ")0:inp,\:"."
md:{sum abs x-y}
distances:md ./:sb
sensors:first each sb
beacons:last each sb
range:{neg[x]+til 1+(-/)(neg\)x}

// part 1
(neg sum 2000000=last each distinct beacons)+/count distinct raze{$[not 0<d:(abs x-last y)-z;first[y]+range abs d;()]}'[2000000;sensors;distances]

// part 2
// works for test data but real input is too large
// 20 vs ?[;1b]all{y<md[;x]each til[20]cross til 20}'[sensors;distances]


