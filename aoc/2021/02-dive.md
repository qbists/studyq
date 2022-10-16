# Day 2: Dive!

> Now, you need to figure out how to pilot this thing.
>
> It seems like the submarine can take a series of commands like forward 1, down 2, or up 3…

Advent of Code 2021 [Day 2](https://adventofcode.com/2021/day/2)

---

Today‘s problem solution uses projections to ingest the data, then a table to think through a solution to the second part. Finally we reduce the table solution to a simpler vector expression.

The text file consists of course adjustments that affect horizontal position and depth.

	forward 5
	down 5
	forward 8
	up 3
	down 8
	forward 2


## Part 1

Take the starting position and depth as 0 0.

```q
q)forward:1 0*; down:0 1*; up:0 -1*
q)show c:value each read0`$":test/02.txt"
5 0
0 5
8 0
0 -3
0 8
2 0
```

The final position and depth are simply the sum of `c` and the answer to part 1 is their product.

```q
q)prd sum c
150
```

## Part 2

Part 2 complicates the picture. The first column of `c` still describes forward movements. But we now need to calculate ‘aim’. Up and Down now adjust aim. Depth changes by the product of forward motion and aim.

A table can help us to think this through.

```q
q)crs:{select cmd:x,fwd,ud from flip`fwd`ud!flip value each x}read0`$":test/02.txt"
q)update aim:sums ud from `crs
`crs
q)update down:fwd*aim from `crs
`crs
q)show crs
cmd         fwd ud aim down
---------------------------
"forward 5" 5   0  0   0
"down 5"    0   5  5   0
"forward 8" 8   0  5   40
"up 3"      0   -3 2   0
"down 8"    0   8  10  0
"forward 2" 2   0  10  20
```

Now we have the changes in horizontal and vertical position ``crs[`fwd`down]`` and can simply sum for the final position.

```q
q)sum each crs[`fwd`down]
15 60
```

But the `down` column is no more than the product of the `fwd` column and the accumulated sums of the `ud` column. We can express the whole thing in terms of the `fwd` and `ud` vectors.

```q
q)fwd:`ud set'flip c  / forward; up-down
q)prd sum each(fwd;fwd*sums ud)
900
```

The repetition of `fwd` draws the eye. Isn’t `(fwd;fwd*sums ud)` just `fwd` multiplied by 1 and by `sums ud`?

```q
q)prd sum fwd*1,'sums ud
900
```

Put another way, `(fwd;fwd*sums ud)` is `fwd` multiplied by `sums[ud]` zero and 1 times.

```q
q)prd sum 1(sums[ud]*)\fwd
900
```

Or expressed as a function directly on the columns of `c`

```q
prd sum {x*1,'sums y}. flip c
```

That reduces our complete solution to

```q
forward:1 0*; down:0 1*; up:0 -1*
c:value each read0`$":input/02.txt"
a[`$"2-1"]:prd sum c
a[`$"2-2"]:prd sum {x*1,'sums y}. flip c
```