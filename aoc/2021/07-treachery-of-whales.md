# 7. The Treachery of Whales

> A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

Advent of Code 2021 [Day 7](https://adventofcode.com/2021/day/7)

---
## Summary

In today’s puzzle we use

* map iterators Each and Each Left
* the While iterator to implement a binary search
* the Do iterator 

---

We can represent crab positions as an integer vector.

```q
cp:16 1 2 0 4 2 7 1 2 14  / crab positions
```

The distance from `cp` to any position `x` is simply `abs cp-x`. 
A brute-force solution calculates the fuel cost to all possible destinations.

```q
q)abs cp-\:til 1+max cp
16 15 14 13 12 11 10 9 8 7 6  5  4  3  2  1  0
1  0  1  2  3  4  5  6 7 8 9  10 11 12 13 14 15
2  1  0  1  2  3  4  5 6 7 8  9  10 11 12 13 14
0  1  2  3  4  5  6  7 8 9 10 11 12 13 14 15 16
4  3  2  1  0  1  2  3 4 5 6  7  8  9  10 11 12
2  1  0  1  2  3  4  5 6 7 8  9  10 11 12 13 14
7  6  5  4  3  2  1  0 1 2 3  4  5  6  7  8  9
1  0  1  2  3  4  5  6 7 8 9  10 11 12 13 14 15
2  1  0  1  2  3  4  5 6 7 8  9  10 11 12 13 14
14 13 12 11 10 9  8  7 6 5 4  3  2  1  0  1  2
```

Each column corresponds to a candidate destination.

```q
q)sum abs cp-\:til 1+max cp  / fuel costs
49 41 37 39 41 45 49 53 59 65 71 77 83 89 95 103 111
```

And finds the smallest.

```q
q)min sum abs cp-\:til 1+max cp
37
```

But we notice that the destination costs follow a smooth curve. Once we move past the optimum destination (2) the fuel costs rise steadily. We could stop searching as soon as the fuel cost begins to rise again.

A binary search of the solution space should converge quickly on the minimum, without calculating the fuel cost for every possible destination.

Moreover there are clusters of crabs in some positions. We need only calculate the fuel cost for each distinct position, then weight it by the number of crabs there.

Count the crabs at each position:

```q
q)show cd:count each group cp  / crab distribution
16| 1
1 | 2
2 | 3
0 | 1
4 | 1
7 | 1
14| 1
```

Calculate fuel cost for destination `y` in distribution `x`.

```q
q)fc1:{sum(value x)*abs y-key x}[cd;]  / Part 1 fuel cost of destination 
q)fc1 2  / fuel cost of moving to 2
37
```

Now we’ll use `fc1` to search the solution space of `til 1+max cd`. Calculate the fuel cost at the halfway point and its neighbor. According to which cost is higher, drop half the solution space.

We start with a binary-search function. It evaluates a function at two adjacent values in the middle of a range and returns the upper or lower half of the range.

```q
q)show frd:(min;max)@\:key cd  / full range of possible destinations
0 16
q)fc1 each 0 1+floor med frd
59 65
```

The gradient is ‘up’ so that’s a ‘go-left’ – we want the lower part of the range (0,16).

```q
q).[<]fc1 each 0 1+floor med frd
1b
```

If the midpoint is `m` we want `0,m`. Had the gradient been ‘down’, we’d want `m,16`.

```q
q)?[;r;m]1 not\.[<]fc1 each 0 1+m:floor med frd
0 8
```

Note the use of `1 not\`. The form `1 f\x` is a handy functional equivalent of `(x;f x)`. 
We use the result with [Vector Conditional](https://code.kx.com/q/ref/vector-conditional/) `?[;r;m]` to get one half of the range.

This can all be expressed as a binary-search function.

```q
q)bs:{?[;y;m]1 not\.[<]x each 0 1+m:floor med y}  / halve range y with fn x
q)bs[fc1] 0 16
0 8
```

We can wrap this with a ‘short list’ function that narrows the range until we are happy to evaluate every point in it: say, no more than 5 points.

We can use the [While](https://code.kx.com/q/ref/accumulators/#while) iterator with a simple test function `{neg[x]>.[-]y}[n;]`.

```q
q)sl:{[n;f;r]{neg[x]>.[-]y}[n;] bs[f;]/r}  / short list
q)sl[5;fc1;] 0 16
0 4
```

The last expression above could have been written `sl[5;fc1;0 16]`, but I wrote it as the unary projection of `sl[5;fc1;]` because the result `0 4` is a version of the third argument `0 16`, so writing it as a projection helps the reader see a range transformed into another range. (You might also think of the first two arguments as constraints, options, or parameters; and the third argument as ‘data’.)

```q
q)rng:{x+til y-x-1}.  / range
q)min fc each rng sl[fc1;5;] 0 16
37
```

On my machine this is about 30× faster on the full puzzle data than the naive algorithm.


## Part 2

In Part 2 all that changes is the fuel-cost calculation. Each distance has a multiplier.

```q
fm:sums til 1+max cp
fc2:{sum(value x)*fm abs y-key x}[cd;] / fuel cost of moving to position y
```

The difference between the two fuel-cost functions is so small it’s worth making it an argument.

```q
fc:{sum(value x)*y abs z-key x}[cd;;] / Part 2 fuel cost of moving to position z
```

This makes the projection `fc` a binary; its first argument is the fuel multiplier. For Part 1 that can be the [Identity](https://code.kx.com/q/ref/identity/) operator `::`. Note here the use of an important q principle: functions, lists and dictionaries are all mappings from one domain to another. The syntax permits us to use either a function or a list as the first argument of `fc`.

Our complete solution:

```q
cd:count each group value first read0`:day7.txt   / crab distribution
frd:(min;max)@\:key cd                            / full range of destinations
fc:{sum(value x)*y abs z-key x}[cd;;]             / fuel cost of moving to position z
bs:{?[;y;m]1 not\.[<]x each 0 1+m:floor med y}    / halve range y with fn x
sl:{[f;n;r]{neg[x]>.[-]y}[n;] bs[f;]/r}           / short list
rng:{x+til y-x-1}.                                / range
a[`$"7-1"]:min fc[::] each rng sl[fc[::];5;] frd
fm:sums til 1+max frd
a[`$"7-2"]:min fc[fm] each rng sl[fc[fm];5;] frd
```