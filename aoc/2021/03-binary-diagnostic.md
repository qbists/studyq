# Day 3: Binary diagnostic

Ingestion here is a treat. Comparing the file lines to `"1"` gets us a boolean matrix.

```q
q)show dg:"1"=read0`$":input/03.txt" / diagnostic
110011110101b
110011100010b
010100011010b
011001100000b
010011011101b
..
```

## Part 1

Finding the most-common bit is just comparing the the sum of `dg` to half its count.

```q
q)sum[dg]>=count[dg]%2  / gamma bits
001110101101b
```

And the least-common bit is a slight variation.

```q
q)sum[dg]<count[dg]%2  / epsilon bits
110001010010b
```

which suggests finding both with a projection.

```q
q)(>=;<){.[x](sum y;count[y]%2)}\:dg
001110101101b
110001010010b
```

Above, a comparison operator is passed to the lambda as its left argument. 
Within the lambda, the [Apply operator](https://code.kx.com/q/ref/apply/) `.` uses `x` to compare `sum y` and `count[y]%2`. 
But we can do that a little more neatly.

```q
{.[x]1 .5*(sum;count)@\:y}
```

The [Each Left map iterator](https://code.kx.com/q/ref/maps#each-left-and-each-right) applies the lambda between the two comparison operators and the diagnostic matrix.

All that remains is to encode these two binary numbers as decimals and get their product. 

The complete solution:

```q
q)prd 2 sv'(>=;<){.[x]1 .5*(sum;count)@\:y}\:"1"=read0`$":input/03.txt"
2967914
```

## Part 2

To find the oxygen generator rating we need to filter the rows of `dg` by an aggregation (most-common bit) of its first column, and so on. 
Start with a filter based on the aggregator we already defined.

```q
fltr:{where y= .[x]1 .5*(sum;count)@\:y)}
```
This finds which items of its right argument match the most-common or least-common bit according its left argument.

```q
q)fltr[>=]101010b
0 2 4
```

As another way of working across the columns of `dg` we’ll flip it and iterate through the items (rows). 
As each iteration will use the result of the previous iteration, we need an [Accumulator iterator](https://code.kx.com/ref/acumulators/). 
We’ll use the Scan iterator to filter the rows of `flip dg` until we find the next iteration would leave no rows. 
Initially, all the rows are ‘in’: `til count dg`.


```q
(til count dg){$[count i:fltr[>=] y x;x i;x]}/flip dg
```

Here we can see the structure of the iteration. 
The initial state `til count dg` is a list of all the rows of `dg`. 
The lambda being iterated tests the first column of `dg` and finds which rows pass the test. 
Only the rows listed in the left argument are tested, so eliminated rows stay eliminated. 
We stop just before we eliminate the last row/s. 

We can use the Scan iterator to watch the row indexes being filtered.

```q
q)(til count dg) {$[count i:fltr[>=]y x;x i;x]}\ flip"1"=read0`$":test/03.txt"
1 2 3 4 7 8 9
2 3 4 8
2 3 4
2 3
,3
q)dg 3
10111b
```

That is the oxygen-generator rating for the test data. 
Switching the comparison operator will give us the CO<sub>2</sub> scrubber rating. 
So to be tidy, let’s name the lambda and make the comparison operator its third argument.

```q
q)dg:"1"=read0`$":test/03.txt"
q)analyze:{$[count i:fltr[z]y x;x i;x]}
q)(til count dg) analyze[;;>=]\ flip dg
1 2 3 4 7 8 9
2 3 4 8
2 3 4
2 3
,3
q)(til count dg) analyze[;;<]\ flip dg
0 5 6 10 11
5 11
,11
,11
,11
q)dg 11
01010b
```

So the rating (O<sub>2</sub> or CO<sub>2</sub>) is a function of the diagnostic matrix and a comparison operator. 
Let’s write it that way.

```q
rating:{first(til count y)analyze[;;x]\flip y}
```
And there’s the CO<sub>2</sub> scrubber rating for the test data. 
On to the puzzle data.

```q
q)fltr:{where y= .[x]1 .5*(sum;count)@\:y)}
q)analyze:{$[count i:fltr[z]y x;x i;x]}
q)rating:{first(til count y)analyze[;;x]\flip y}
q)prd 2 sv'dg (>=;<)rating\: dg:"1"=read0`$":input/03.txt"
7041258
```

---

Alternative solutions (adapted) from sujoy13 on [community.kx.com](https://community.kx.com/t5/Advent-of-Code-2021/AOC-Day-3-Binary-Diagnostic/td-p/11372):

```q
L:read0`$:"input/03.txt"
prd 2 sv'"J"$string ("01";"10")@\:{(>).(sum')"10"=\:x} each flip L / part 1
prd {2 sv'"I"$string{?[1~count x;x;x where x[;y]=z(>=).(sum')"10"=\:x[;y]]}[;;y]/ [x;til count first x]}[L;] each ("01";"10") /part 2
```
