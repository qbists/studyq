/https://adventofcode.com/2022/day/10

inp: read0`:input/10.txt

// András Dőtsch
noop:0;addx:0,
i:1+\get","sv inp
sum i[c-2]*c:20+40*til 6
show".#"40 cut 2>abs(-1_1,i)-240#til 40

// Péter Györök
/no iterators!
.d10.ocr:()!();
.d10.ocr[529680320]:"A"
.d10.ocr[1067881856]:"B"
.d10.ocr[512103552]:"C"
.d10.ocr[1067616256]:"F"
.d10.ocr[1059153984]:"K"
.d10.ocr[1057230912]:"L"
.d10.ocr[33955712]:"J"
.d10.ocr[1066550784]:"P"
d10:{[part;x]a:" "vs/:x;
    t:1+a[;0]like"addx";
    d:1,1+sums "J"$a[;1];
    val:d where t;
    if[part=1;
        ind:20+40*til 6;
        :sum ind*val ind-1];
    r:40 cut (val-til[240]mod 40)within -1 1;
    //-1 " #"r;
    R2::r2:2 sv/:raze each 5 cut flip R::r;
    .d10.ocr r2} 
d10p1:{d10[1;x]} inp
d10p2:{d10[2;x]} inp

/
// Stephen Taylor
/part 1
X: {1+\raze{((0,;0^)@null x)@'x}"J"$5_'x} inp  /register X at each cyle
sum{x*y x-2}[20 60 100 140 180 220] X
/part 2
show 40 cut".#"{(til[count x]mod 40)within'-1 1+/:0^prev x} X

// Cillian Reilly
r:1+sums raze distinct each 0N,/:first(" J";" ")0: inp
{sum y*x -2+y}[r;20 60 100 140 180 220]
{40 cut(".#")1b,(mod[;40]1+til count x)within'-1 1+/:x} -1_r

// George Berkeley
s:{" " vs x}@' inp
xs:1+sums{("J"$x 1;0)("addx";"noop")?x 0}@'s
c:sums{(2 1)("addx";"noop")?x 0}@'s
sum t*xs neg[1]+c binr t:20 60 100 140 180 220 / part 1
fc:1^xs neg[1]+c binr 1+til max c
40 cut (".#"){mod[x;40]within(-1;1)+fc x}@'til 240 / part 2

// András Dőtsch
f:{$[x~"noop";0;0,"J"$last" "vs x]}
sum(sums 1,raze f each inp)[c-1]*c:20+40*til 6
".#"2>abs(6 40#til 40)-40 cut -1_(sums 1,raze f each inp)
/alternative
noop:0;addx:0,
i:1+\get","sv inp
sum i[c-2]*c:20+40*til 6
".#"40 cut 2>abs(-1_1,i)-240#til 40

// Zsolt Venczel
d10data: {{(x[0];"J"$x[1])}[" " vs x]} each inp

r: (enlist 1), raze {v:: 1; {$["addx" ~ x[0]; {r: (v; v + x); v:: v + x; r}[x[1]]; v]} each x}[d10data]
ans1: sum {r[x-1]*x}[(20 60 100 140 180 220)]
ans2: {40 cut (((-1 _ r) - 1) <= x) & (x <= (-1 _ r) + 1)}[raze {til 40} each til 6]