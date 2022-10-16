# 10. Syntax Scoring

> You ask the submarine to determine the best route out of the deep-sea cave, but it only replies:
>
> > Syntax error in navigation subsystem on line: all of them

Advent of Code 2021 [Day 10](https://adventofcode.com/2021/day/10)

---

```q
subsys:read0`$":input/10.txt"
tkn:"()[]{}<>" / tokens
opn:"([{<"; cls:")]}>"

prs:{[str;stk] c:str 0; / parse string with stack
  $[c in opn;(1_str;stk,c);opn[cls?c]=last stk;(1_str;-1 _ stk);(str;stk)] }.

pr:('[prs/;(;"")]) each subsys
a[`$"10-1"]:sum (cls!3 57 1197 25137) 2 first'/pr

com:(opn!cls)reverse each{y where 0=ce x}. flip pr / completions
a[`$"10-2"]:"j"$med({y+5*x}/)each 1+cls?com
```