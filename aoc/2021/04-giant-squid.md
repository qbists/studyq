# 4. Giant Squid

Advent of Code 2021 [Day 4](https://adventofcode.com/2021/day/4)

The bingo boards are nicely readable in the text file, but we shall find them more tractable as vectors.

```q
q)q:read0`$":test/04.txt"
q)nums:value first q
q)show boards:value each" "sv'(where 0=count each q)cut q
22 13 17 11 0  8  2  23 4  24 21 9 14 16 7  6  10 3  18 5 1  12 20 15 19
3  15 0  2  22 9  18 13 17 5  19 8 7  25 23 20 11 10 24 4 14 21 16 12 6
14 21 17 24 4  10 16 15 9  19 18 8 23 26 20 22 11 13 6  5 2  0  12 3  7
```

A perfectly sensible looping approach would follow real life. We would call each number and see if any board has won.

We’re not going to do that. We’re going to call all the numbers and see where the wins occur.

```q
s:(or\')boards=/:\:nums  / states: call all the numbers in turn
```

The derived function `=/:\:` (Equal Each Right Each Left) gives us a cross-product on the Equal operator. The list `boards=/:\:nums` has an item for each board. Each item is a boolean matrix: a row for each of the called numbers, the columns corresponding to the board numbers. Here’s the first board with 1s flagging the numbers as they are called in turn.

```q
q)first boards=/:\:nums
0000000000000010000000000b
0000000010000000000000000b
0000000000010000000000000b
0000000000000000000100000b
0001000000000000000000000b
0010000000000000000000000b
..
```

Of course, once a number is called, it stays called.

```q
q)(or\)first boards=/:\:nums
0000000000000010000000000b
0000000010000010000000000b
0000000010010010000000000b
0000000010010010000100000b
0001000010010010000100000b
0011000010010010000100000b
..
```

That is just the first board. We want the same for every board.

```q
s:(or\')boards=/:\:nums  / states: call all the numbers in turn
```

How to tell if a board has won? Here is the state of board 0 after 9 numbers have been called.

```q
q)s[0;9;]
0011101110011010000100000b
```

Has it won?

```q
q)5 cut s[0;9;]
00111b
01110b
01101b
00001b
00000b
```

Clearly not. That would require all 1s on at least one row. Or a column.

```q
q)any all each {x,flip x}5 cut s[0;9;]
0b
```

Now we can flag the wins.

```q
q)show w:{any all each {x,flip x} 5 cut x}''[s]
000000000000011111111111111b
000000000000001111111111111b
000000000001111111111111111b
```

From this we can see that the third board is the first to win and the second is the last to win. Also that they win on (respectively) the 11th and 14th numbers called.

```q
q)sum each not w
13 14 11i
```

So the state of the winning board is `s[2;11;]`

```q
q)5 cut s[2;11;]
11111b
00010b
00100b
01001b
11001b
q)sum boards[2] where not s[2;11;] / sum the unmarked numbers
188
q)nums[11]*sum boards[2] where not s[2;11;] / board score
4512
```

That makes our complete solution:

```q
q:read0`$":input/04.txt"
nums:value first q
boards:value each" "sv'(where 0=count each q)cut q

s:(or\')boards=/:\:nums  / states: call all the numbers in turn
w:sum each not{any all each b,flip b:5 cut x}''[s]  / find wins
bs:{nums[x]*sum boards[y] where not s[y;x;]} / score for board y after xth number
a[`$"4-1"]:bs . {m,x?m:min x} w / winning board score
a[`$"4-2"]:bs . {m,x?m:max x} w / losing board score
```

This is a nice example of the ‘overcomputing’ characteristic of vector languages. Clearly, an efficient algorithm would stop when it reached the first win. Or, for Part 2, the last win.

But sometimes it is convenient to calculate all the results and search them. And, with vector operations, sometimes it is faster as well.