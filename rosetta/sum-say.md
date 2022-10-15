# Summarize and say

![Pebbles](img/PHPHX0.jpg)

## Summary 

*Analyze a dictionary of results; map between dictionaries*

A lambda for the Look & Say sequence **composes** with `desc` and the **Do iterator** to produce the Summarize & Say sequence.

A million integers in string form **hashes** with `group` and `desc` to a **dictionary** of 8002 unique seeds.

A dictionary of sequences, keyed by the unique seeds:
composition `count distinct@` measures the iterations needed to converge; `max` finds the slowest sequences.

**Reverse lookup** on a dictionary finds their unique seeds; indexing the  sequence and seed dictionaries with them finds the slowest sequences and all the seeds that produce them.

Seven code lines, no loops, no counters, no control structures.


## Question 

*Find for Sum & Say sequences all the seed values up to a million that take the most iterations to converge*

See [Rosetta Code](http://rosettacode.org/wiki/Summarize_and_say_sequence)
for the task details.

Note that in this context a series has converged when a value in the series is repeated.

Start with the simple [_Look and Say_ sequence](https://en.wikipedia.org/wiki/Look_and_say_sequence "Wikipedia)").

```q
q)ls:{raze(string 1_ deltas d,count x),'x d:where differ x}  / look & say
q)ls string 0
"10"
q)10 ls\string 0
,"0"
"10"
"1110"
"3110"
"132110"
"1113122110"
"311311222110"
"13211321322110"
"1113122113121113222110"
"31131122211311123113322110"
"132113213221133112132123222110"
```

The Look and Say sequence (or “Morris sequence”) grows indefinitely.
The Summarize and Say variant converges.

```q
q)sumsay:ls desc@                                            / summarize & say
q)15 sumsay\string 0
,"0"
"10"
"1110"
"3110"
"132110"
"13123110"
"23124110"
"1413223110"
"1423224110"
"2413323110"
"1433223110"
"1433223110"
"1433223110"
"1433223110"
"1433223110"
"1433223110"
```


## Unique seeds

Because `sumsay` sorts its argument digits, variations in order produce the same sequence.

```q
q)sumsay each string`123`321
"131211"
"131211"
```

So it is not necessary to construct a sequence for every one of a million seeds.

```q
q)seeds:group desc each string til 1000000
```

A dictionary. Its key is the unique seeds; its value their permutations.

```q
q)seeds string`21`9721`66633
12 21
1279 1297 1729 1792 1927 1972 2179 2197 2719 2791 2917 2971 7129 7192 7219 72..
33666 36366 36636 36663 63366 63636 63663 66336 66363 66633
```


## Sequences

Construct a 30-term sequence for each seed.

```q
seq:(key seeds)!30 sumsay\'key seeds
```

A dictionary of seeds and their sequences.

### Iterator syntax

**An iterator is a unary operator with postfix syntax.**
It takes a single argument, on its _left_.

Above, `sumsay` is the argument of `\` (the Scan form of) the Do iterator. 
Applying Do to `sumsay` derives the function `sumsay\`.

We earlier saw `sumsay\` applied as a binary, with infix syntax and 15 as a left argument. Here the left argument is 30: thirty successive applications of `sumsay`. 
With no right argument, `30 sumsay\` is a projection of `sumsay\` on its left argument 30, forming a unary that will apply `sumsay` to its argument 30 times. 

That projection `30 sumsay\` is the left argument of the Each operator `'`.

The unary derived function `30 saysum\'` applies `30 saysum\` to each item of its argument.

[How to use iterators](https://code.kx.com/q/wp/iterators/index "White paper")

### Bonus points

The repetition in `(key seeds)!30 sumsay\'key seeds`
can be removed by another iterator. 

The expression `n f/x` applies `f` successively `n` times to `x`. Its Scan form `n f\x` does the same, but returns the result of each application. The result has `n+1` items, corresponding to `til n+1` applications. The first item of the result corresponds to 0 applications; i.e. the original argument. 

`0 f/` and `0 f\` are identity functions for any `f`.
Which means… `1 f\x` <=> `(x;f x)`. 

```q
q)1 reverse\1011001b
1011001b
1001101b
```

The [Apply operator](https://code.kx.com/q/ref/apply) applies a function to a list of its arguments. So for some `f` we can define 

```q
q)(~) . 1 reverse\ "madamimadam"
1b
```

In our case `f` is `{30 sumsay\'x}`.

```q
seq:(!) . 1{30 sumsay\'x}\key seeds
```

## Convergence

Count the iterations to convergence: how many does the slowest take?

```q
q)max its:(count distinct@)each seq
21
```

Above, `(count distinct@)` is a composition, equivalent to `{count distinct x}`


## Selecting seeds

What unique seeds had sequences that took 21 steps to converge? 
`its` was defined by applying `(count distinct@)each` to `seq`, so `its` is a dictionary with the same keys, and

```q
q)where its=max its
"9900"
```

is a dictionary reverse lookup, returning the keys with values of 21.

Just that one, then. But that unique seed corresponds to several seeds:

```q
q)raze seeds where its=max its
9009 9090 9900
```

Above, the reverse dictionary lookup, then the results looked up in dictionary `seeds`.


## Script

Put it all together.

```q
ls:{raze(string 1_ deltas d,count x),'x d:where differ x}  / look & say
sumsay:ls desc@                                            / summarize & say

seeds:group desc each string til 1000000                   / seeds for million integers
seq:(key seeds)!30 sumsay\'key seeds                       / sequences for unique seeds
top:max its:(count distinct@)each seq                      / count iterations

/ report results
rpt:{1 x,": ",y,"\n\n";}
rpt["Seeds"]" "sv string raze seeds where its=top          / all forms of top seed/s
rpt["Iterations"]string top
rpt["Sequence"]"\n\n","\n"sv raze seq where its=top
```

Output:

```txt
Seeds: 9009 9090 9900

Iterations: 21

Sequence:

9900
2920
192210
19222110
19323110
1923123110
1923224110
191413323110
191433125110
19151423125110
19251413226110
1916151413325110
1916251423127110
191716151413326110
191726151423128110
19181716151413327110
19182716151423129110
29181716151413328110
19281716151423228110
19281716151413427110
19182716152413228110
19281716151413427110
19182716152413228110
19281716151413427110
19182716152413228110
19281716151413427110
19182716152413228110
19281716151413427110
19182716152413228110
19281716151413427110
19182716152413228110
```


## Review

Defined function `ls` for the Look & Say sequence; `sumsay` for the Summarize & Say sequence is just the composition `ls desc@`.

Took a million integers as strings and used `group` to hash them into an 8002-entry dictionary keyed by their digits sorted in descending order. 

Made a dictionary of 30-item sequences for the unique seeds, using the Do and Each iterators.

Used composition `count distinct@` and `each` to count the number of iterations required in each sequence before it converged, and aggregator `max` to measure the longest. 

Used **reverse lookup** on the dictionary of iterations to find the unique seeds for the slowest-converging sequences, then mapped them to the corresponding original seeds and to the sequences themselves. (Turns out there is just the one.)

