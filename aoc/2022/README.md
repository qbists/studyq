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
Shp: count each 1 first\inp                                         /map shape
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
