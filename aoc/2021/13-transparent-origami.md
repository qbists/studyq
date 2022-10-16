# 13. Transparent Origami

> You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.

Advent of Code 2021 [Day 13](https://adventofcode.com/2021/day/13)

---

```q
`pts`folds set'('[reverse;value]';1_)@'{(0,where 0=ce x)_ x}read0`$":input/13.txt"
p1:((1+max pts)#0b) .[;;:;1b]/pts                                                   / page one
fold:{f:(::;flip)@"yx"?y@11;n:value 13_y;f .[or](::;reverse)@'(1 neg\n)#\:f x}      / fold x according to y
a[`$"13-1"]:sum raze fold[p1;first folds]
```