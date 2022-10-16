# Day 1: Sonar Sweep

> You're minding your own business on a ship at sea when the overboard alarm goes off! You rush to see if you can help. Apparently, one of the Elves tripped and accidentally sent the sleigh keys flying into the ocean!

Advent of Code 2021 [Day 1](https://adventofcode.com/2021/day/1)

---

Every puzzle has the same first step: ingesting the data. 
We‘re proud of how easy it is to convert each day’s text file into a tractable q data structure.

```q
q)show d:"J"$read0 `$":input/01.txt"
148 167 168 169 182 188 193 209 195 206 214 219 225 219 211 215 216 195 200 1..
```

How many of these depth measurements are larger than the previous measurement?

The [Each Prior](https://code.kx.com/q/ref/maps/#each-prior) iterator applied to the Greater Than operator `>` 
derives a function `>':` that tells us exactly that. 
We use it with a zero left argument for the first comparison.

```q
q)0>':d
11111111011110011010111111010111111101100011111001101110110011100110111101110..
```

We’re not interested in the first comparison, so we discard it and count the remaining hits.

```q
q)sum 1_ 0>':d
1400i
```

Because we are not interested in the first comparison, the 0 could be any integer. 
Perhaps better to get rid of it entirely, and apply `>':` as a unary, using either bracket or prefix syntax.

```q
q)sum 1_ >':[d] / bracket
1400i
q)sum 1_ (>':)d / prefix
1400i
```

Without the 0 left argument to `>':`, q has its own rules for what to compare the first item of `d` to. 
We don’t care, but you can read about these [defaults](https://code.kx.com/q/ref/maps/#each-prior).

We see above that the derived function >': is variadic: we can apply it as either a unary or a binary. Applying it as a unary means we could instead use the prior keyword.

```q
q)sum 1 _ (>) prior d
1400i
```

That is better q style, and perhaps the coolest way to write the solution.

Note the parens in `(>)`, which give it noun syntax. 
That is, the parser reads it as the left argument of `prior` rather than trying to apply it. 
With this as a model, part 2 looks simple. 
We want the 3-point moving sums of `d`, of which we shall ignore the first two.

```q
q)a:()!"j"$() / answers
q)a[`$"1-1"]:sum 1 _ (>) prior d
q)a[`$"1-2"]:sum 1 _ (>) prior 2 _ 3 msum d
q)show a
1-1| 1400
1-2| 1429
```

Oleg Finkelshteyn has a simpler (and faster) solution.

```q
q)sum(3_d)>-3_d
1429i
```

On [community.kx.com](https://community.kx.com/t5/Advent-of-Code-2021/AOC-Day-1-Sonar-Sweep/td-p/11352) user jbetz34 explains:

```q
L:149 163 165 160 179 184 186 199 207 210 / first 10 depths 
sum L[0 1 2] < sum L[1 2 3] / compare first 2 moving sums
L[0] + sum L[1 2] < L[3] + sum L[1 2] / factor out repeated sums
L[0] < L[3] / simplified comparison
```
