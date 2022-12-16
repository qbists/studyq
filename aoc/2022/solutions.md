# Solutions

Here are ‘exhibition’ solutions, to show off how elegantly terse q can be. 

Except where otherwise commented, each solution answers both parts of the problem. 

For exploration and discussion of each solution, see the individual problem pages.

```q
/read day's input
day: {read0`$":input/",(1_string x+100),".txt"}
```


## Day 1: Calorie Counting

```q
(first;sum 3#::)@\:desc sum each{(0,where null x)_ x}"I"$day 1
```

## Day 2: Rock Paper Scissors

```q
strategy: (day 2)[;0 2]
rounds: string`BX`CY`AZ`AX`BY`CZ`CX`AY`BZ
play: rounds!rounds[;0],'"XZYZYXYXZ"
(sum 1+ rounds? ::) each 1 play\ strategy
```

## Day 3: Rucksack Reorganization

```q
sum each 1+.Q.an?(first@inter/)each'(2 0N#/:;0N 3#)@\:day 3
```

## Day 4: Camp Cleanup 

```q
a: {asc each "J"$"-"vs/:/:","vs/:x} day 4
d4p1: {sum(x[;1;1]<=x[;0;1]) or x[;0;0]=x[;1;0]}
d4p2; {sum x[;1;0]<=x[;0;1]}
(d4p1;d4p2)@\:a
```

## Day 5: Supply Stacks 

```q
`s`m set'{
  (trim@'flip x[;1+4*til(1+count first x)div 4];  /stacks
  flip 0 -1 -1+(" J J J";" ")0:y)                 /moves
  }. -1 1_'{(0,where not count each x)_ x} day 5

f: {[o;s;m] @/[s;m 1 2;(m[0]_;(o m[0]#s m 1),)]}
first each s f[reverse]/m                         /part 1
first each s f[::]/m                              /part 2
```

## Day 6: Tuning Trouble

```q
4 14 {x+first {x>count distinct y z}[x;y](1+)/til x}\: day 6
```


