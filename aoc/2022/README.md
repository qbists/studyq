Advent of q 2022
================

[Eric Wastl](http://was.tl)’s annual [Advent of Code](https://adventofcode.com) (AoC) competition always engages some veteran q programmers. (In fact Arthur Whitney studies AoC solutions for ways to improve the design of k.) Their ingenious and wonderfully terse solutions repay study, but are mostly shared on private forums. 

The repo includes test and input files for the 2022 AoC puzzles, and working solutions, together with articles analysing and comparing them. 


## Solutions

Here are ‘exhibition’ solutions, to show off how elegantly terse q can be. 

Except where otherwise commented, each solution answers both parts of the problem. 

For exploration and discussion of each solution, see the individual problem pages.

```q
/read day's input
day: {read0`$":input/",(1_string x+100),".txt"}
```


### Day 1: Calorie Counting

```q
(first;sum 3#::)@\:desc sum each{(0,where null x)_ x}"I"$day 1
```

### Day 2: Rock Paper Scissors

```q
strategy: (day 2)[;0 2]
rounds: string`BX`CY`AZ`AX`BY`CZ`CX`AY`BZ
play: rounds!rounds[;0],'"XZYZYXYXZ"
(sum 1+ rounds? ::) each 1 play\ strategy
```

### Day 3: Rucksack Reorganization

```q
sum each 1+.Q.an?(first@inter/)each'(2 0N#/:;0N 3#)@\:day 3
```

### Day 4: Camp Cleanup 

```q
a: {asc each "J"$"-"vs/:/:","vs/:x} day 4
d4p1: {sum(x[;1;1]<=x[;0;1]) or x[;0;0]=x[;1;0]}
d4p2: {sum x[;1;0]<=x[;0;1]}
(d4p1;d4p2)@\:a
```

### Day 5: Supply Stacks 

```q
`s`m set'{
  (trim@'flip x[;1+4*til(1+count first x)div 4];  /stacks
  flip 0 -1 -1+(" J J J";" ")0:y)                 /moves
  }. -1 1_'{(0,where not count each x)_ x} day 5

f: {[o;s;m] @/[s;m 1 2;(m[0]_;(o m[0]#s m 1),)]}
first each s f[reverse]/m                         /part 1
first each s f[::]/m                              /part 2
```

### Day 6: Tuning Trouble

```q
4 14 {x+first {x>count distinct y z}[x;y](1+)/til x}\: day 6
```

### Day 7: No Space Left On Device

```q
p:(1#`:) {$[y~"$ cd /";1#x;y~"$ cd ..";-1_x;y like"$ cd *";x,.Q.dd[last x]`$last" "vs y;x]} \ inp: day 7
s:"J"$first@'(" "vs/:inp)
d:exec sum s by p from ungroup ([]p;s)
sum d where d<=100000
min d where d>=d[`:]-40000000
```

### Day 8: Treetop Tree House

```q
rot: flip reverse::                        /rotate 90° clockwise
tor: reverse flip::                        /rotate 90° anticlockwise
c4: {til[4]{[f;n;t]n tor/f@t}[x]'3 rot\y}  /apply ƒx to y from 4 directions
vn: not(=':)maxs::                         /visibility from N
2 sum/max c4[vn] inp: day 7                /part 1
vdw: {reverse[til count first x]&/:
  1+((sum mins 1_)'')x>-1_'(1_)\'[x]}      /viewing distance from W
2 max/prd c4[vdw] inp                      /part 2
```

### Day 9: Rope Bridge

```q
s: sums("RLDU"!(1 0;-1 0;0 -1;0 1))where .[!] ("CJ";" ")0:day 9
move: {$[1<max abs d:y-x;x+signum d;x]}\[0 0;]
(count distinct@)each(9 move\s)1 9  /both parts
```

### Day 10: Cathode-Ray Tube

```q
i: 1+\get ssr/[;("addx";"noop");"0"]" "sv day 10  /X-register values
sum i[c-2]*c: 20+40*til 6                         /part 1
show ".#" 40 cut 2> abs (-1_1,i)- 240#til 40      /part 2
```

### Day 11: Monkey in the Middle

```q
/ initial state: input + item count
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
```

### Day 12: Hill Climbing Algorithm

```q
Shp: count each 1 first\inp: day 12                                 /map shape
`Start`End set'Shp vs/:raze[inp]?"SE";                              /start & end coords
Map: ./[;(Start;End);:;0 25] -97+6h$inp                             /height map
Is: 2 1 2#End                                                       /visited; last visited
adj: (0 1;1 0;0 -1;-1 0)+\:                                         /adjacency
filter: {y where not[null h] and (-2+Map . x)< h: Map ./:y}
step: {(x,;::)@\:except[;x]distinct raze{filter[x] adj x}each y}.  

-1+count(not Start in last@) step\ Is                               /part 1
a: Shp vs/:where raze inp="a"                                       /"a" coords
-1+count(not any a in last@) step\ Is                               /part 2
```

### Day 13: Distress Signal

```q
inp: day 13
I: 2 cut .j.k each inp where count[inp]#110b
b: {x@/:(y;z)}                                        /'both' combinator

cmp: {
  $[all b[type;x;y]<0;      `long$x-y;
    any 0=c:b[count;x;y];   .[-;c];
    r:cmp . b[first;x;y];   r;
                            cmp . b[1_(),;x;y] ] }

sum 1+where 1>cmp .' I                                /part 1

qs: {$[2>count x; x;    
      raze(.z.s;::;.z.s)@'x
        (group signum x cmp\:first x)@-1 0 1 ] }

`A`B set'b[.j.k;"[[2]]";"[[6]]"];
J: qs(A;B),raze I
prd 1+b[where ~/:[;J]::; A; B]                        /part 2
```

### Day 14: Regolith Reservoir

```q
range: {$[.[=]x;first x;{x+til y-x-1}. asc x]}        / x => y inclusive
between: .[,'] (range') flip ::
line: {[map;pts] ./[map;between pts;:;] 1}            / draw rock line

Map: { /air and rock
  I: (reverse'')raze{1_(;)prior x}@'(get'') " -> "vs/:x;
  ((2 0+0 1000|max raze I)#0)line/I } day 14

fall: {[map;xy] first p where not map ./:p: xy+/:(1 0;1 -1;1 1;0 0) }
drop: {[map] .[map;p;:;] 2*count[map]>1+first p: fall[map]/[0 500] }

sum raze 2=drop/[Map]                                 /part 1

drop2: {[map] .[map;;:;2] fall[map]/[0 500] }
sum raze 2={not x . 0 500} drop2/Map                  /part 2
```

### Day 15: Beacon Exclusion Zone

```q
`Sx`Sy`Bx`By set' flip {get @[x;where not x in "-0123456789";:;" "]}each day 15;
m: sum abs (Sx-Bx;Sy-By) / manhattan dists
/ part 1
count except[;Bx where By=Y] distinct raze {$[y<0;();x-y-til 1+2*y]}'[Sx;m-abs Sy-Y]
/ part 2
peri: raze 1 1 -1 -1,''(Sy-Sx+m+1; Sy-Sx-m+1; Sy+Sx+m+1; Sy+Sx-m+1)
int: distinct raze peri {r:0-1%(%/)x-y; (r; sum x*r,1)}\:/: peri
sum 4000000 1*floor first int where {all raze(x=floor x;0<=x;x<=LIM;m<sum abs(Sx;Sy)-x)} each int
```

### Day 16: Proboscidea Volcanium

```q
d16:{[part;dur;x]
    a:(" "vs/:x except\:";,");
    n:`$a[;1]; flow:n!"J"$5_/:a[;4]; edge:n!`$9_/:a;
    n:asc n; flow2:flow n; edge2:n?edge n;
    c:count n;
    edge3:raze til[c],/:'edge2;
    dist:(c;c)#4000000000000000000;
    dist:.[;;:;0]/[dist;{x,'x}til c];
    dist:.[;;:;1]/[dist;edge3];
    dist:{[x;i]x&x[;i]+/:\:x[i;]}/[dist;til c];
    pfi:distinct 0,where 0<flow2;
    dist2:{x[y;y]}[dist;pfi];
    pf:flow2 pfi;
    cpf:count pf;
    queue:enlist`on`pos`time`tflow!(0=til cpf;0;0;0);
    maxflows:enlist[cpf#0b]!enlist 0;
    while[count queue;
        nq:queue;
        nq:raze{x,/:([]npos:where not x`on)}each nq;
        if[count nq;
            nq:update on:@[;;:;1b]'[on;npos], pos:npos, time:1+time+dist2 ./:(pos,'npos) from nq;
            nq:delete from nq where time>=dur;
            nq:update tflow:tflow+(dur-time)*pf npos from nq;
            maxflows|:exec on!tflow from nq;
        ];
        queue:nq;
    ];
    if[part=1; :max maxflows];
    kf:1_/:key maxflows;
    vf:value maxflows;
    max max (0=sum each/:kf and/:\:kf)*vf+/:\:vf}
d16[1;30] inp: day 16  / part 1
d16[2;26] inp          / part 2
```

### Day 17: Pyroclastic Flow 

```q
.d17.shape:{raze til[count x],/:'where each x}each not null
    (enlist"####";(" # ";"###";" # ");("  #";"  #";"###");
    enlist each"####";("##";"##"));
.d17.ssz:1+max each .d17.shape;

d17:{[lim;x]
    dir:-1+2*">"=first x;
    dc:count dir;
    field:();
    i:-1;
    pcs:0;
    top:0N;
    flog:enlist[()]!enlist `int$(); //field log
    hlog:`int$();   //height log
    while[1b;
        i+:1;
        d:dir[i mod dc];
        if[null top;
            m:0; while[$[m=count field;0b;0=sum field m]; m+:1];
            field:m _field;
            if[pcs>=lim; :count[field]];
            hlog,:count field;
            snap:0b,raze 12 sublist field;
            flog[snap],:pcs;
            if[3<=count st:flog[snap];
                if[1=count pers:distinct 1_deltas st;
                    per:first pers;
                    hfst:hlog[st 0];    //height in first partial period
                    hper:hlog[st 2]-hlog[st 1]; //height per period
                    fullPers:(lim-st 0)div per; //number of full periods
                    plst:(lim-st 0)mod per;  //pieces in last partial period
                    hlst:hlog[plst+st 1]-hlog[st 1]; //height in last partial period
                    :hfst+(fullPers*hper)+hlst;
                ];
            ];
            shape:.d17.shape pcs mod 5;
            ssz:.d17.ssz pcs mod 5;
            field:((ssz[0]+3)#enlist 7#0b),field;
            top:0;
            left:2;
            pcs+:1;
        ];
        left+:d;
        if[7<left+ssz 1; left-:1];
        if[0>left; left+:1];
        if[any field ./:(top;left)+/:shape; left-:d];
        top+:1;
        hit:0b;
        if[count[field]<top+ssz 0; hit:1b];
        if[any field ./:(top;left)+/:shape; hit:1b];
        if[hit;
            top-:1;
            field:.[;;:;1b]/[field;(top;left)+/:shape];
            top:0N;
        ];
    ];
    };
d17[2022] inp: day 17
d17[1000000000000] inp
```
### Day 18: Boiling Boulders

```q
I: get@' day 18
//part 1
D: (0-1_4#)\[1 0 0]
s: {[I] sum count@'I except/:D+/:\:I}
s I
//part 2
I+:1
U: cross/[til@'2+max I]
f: {[C] distinct C,U inter raze[D+/:\:C] except I}
s U except f/[1 3#0]
```

---

[Péter Györök’s AOC 2022 solutions](https://github.com/gyorokpeter/puzzle_solutions/tree/master/aoc/2022)

---

## Q leaderboard

https://adventofcode.com/2022/leaderboard/private/view/1526329

## Sources

* [k4 Topicbox](https://k4.topicbox.com/groups/k4)
* #adventofcode at [kxsys.slack.com](https://kxsys.slack.com)
* #vector-dojo at [iversoncollege.slack.com](https://iversoncollege.slack.com)
* [community.kx.com](https://community.kx.com)
* [github.com/CillianReilly/AOC/2022](https://github.com/CillianReilly/AOC/tree/master/2022)
* [github.com/adotsch/AOC/2022](https://github.com/adotsch/AOC/tree/master/2022)


## Contributors 

* Muneish Adya
* [Sean Ang](https://github.com/sean185)
* Balaji
* [George Berkeley](gberkeley4@gmail.com)
* [David Crossey](https://github.com/davidcrossey)
* [András Dőtsch](https://github.com/adotsch)
* [Tadgh Downey](mailto:tdowney@kx.com)
* Tom Ferguson
* [Péter Györök](https://github.com/gyorokpeter)
* [Rory Kemp](https://github.com/rak1507)
* Phineas
* [Nick Psaris](https://github.com/psaris)
* [Roman Pszonka](mailto:rpszonka@kx.com)
* [Sujoy Rakshit](https://github.com/SujoyRakshit)
* Ajay Rathore
* [Cillian Reilly](mailto:cillian.reilly2@gmail.com)
* Ahmed Shabaz
* [Nathan Swann](https://github.com/NathanSwann-AquaQ)
* [Stephen Taylor](https://github.com/StephenTaylor-Kx)
* [Zsolt Vencsel](mailto:zvenczel@kx.com)
* Attila Vrabecz

---

[Advent of Code 2022](https://www.reddit.com/r/adventofcode/) on Reddit
