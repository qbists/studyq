# 12. Passage Pathing

> With your submarine’s subterranean subsystems subsisting suboptimally, the only way you’re getting out of this cave anytime soon is by finding a path yourself. Not just *a* path - the only way to know if you’ve found the best path is to find *all* of them.

Advent of Code 2021 [Day 12](https://adventofcode.com/2021/day/12)

---

```q
map:.[!](key;'[except'[;`start];value])@\:delete end from group 
  .[!]flip{x,reverse each x}`$"-"vs/:read0`$":input/12.txt"

sc:{x where(first each string x)in .Q.a}key[map]except`start                / small caves

xplr:{[m;sc;f;r]                                                            / explore map; small caves; routes
  (r where`end=last each r),raze r,/:'(m last each r)except'r f\:sc
  } [map;sc;]

a[`$"12-1"]:count (xplr[inter]/) 1 1#`start
a[`$"12-2"]:count (xplr[{$[2 in(ce group x)@y;x inter y;()]}]/) 1 1#`start
```