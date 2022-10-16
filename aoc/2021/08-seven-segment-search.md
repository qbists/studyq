# 8. Seven Segment Search

> You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

Advent of Code 2021 [Day 8](https://adventofcode.com/2021/day/8)

---

Ingesting data with q always feels like replacing an axe with a chain saw.

```q
q)read0`$":test/08.txt"
"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
"edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc"
"fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg"
```

## Part 1

Treat it like a CSV: split it into two lists of strings; trim and split each string into substrings;
name each list, and flip for a table.

```q
q)flip `sample`signal!" "vs''trim each("**";"|")0:read0`$":test/08.txt"
sample                                                                                            signal
-----------------------------------------------------------------------------------------------------------------------------------------
"be"      "cfbegad" "cbdgef"  "fgaecd"  "cgeb"    "fdcge"   "agebfd" "fecdb"  "fabcd"   "edb"     "fdgacbe" "cefdb"   "cefbgd"  "gcbe"
"edbfga"  "begcd"   "cbg"     "gc"      "gcadebf" "fbgde"   "acbgfd" "abcde"  "gfcbed"  "gfec"    "fcgedb"  "cgb"     "dgebacf" "gc"
"fgaebd"  "cg"      "bdaec"   "gdafb"   "agbcfd"  "gdcbef"  "bgcad"  "gfac"   "gcb"     "cdgabef" "cg"      "cg"      "fdcagb"  "cbg"
```

Map the segments to their display positions; list the signal wires.

```q
q)show seg:6 cut" aaaa b    cb    c dddd e    fe    f gggg "  / segments
" aaaa "
"b    c"
"b    c"
" dddd "
"e    f"
"e    f"
" gggg "

q)show sw:except[;" "]distinct raze seg  / signal wires
"abcdefg"
```

Canonical signals: signal wires for numbers 0 to 9. (Signal wires are listed in alphabetical order.)

```q
q)show cs:string css:`abcefg`cf`acdeg`acdfg`bcdf`abdfg`abdefg`acf`abcdefg`abcdfg / canonical signals
"abcefg"
"cf"
"acdeg"
"acdfg"
"bcdf"
"abdfg"
"abdefg"
"acf"
"abcdefg"
"abcdfg"
```

Certain numbers are unmistakeable because the count of their signal wires is unique.

```q
q)show un:{lc!x?lc:where 1=count each group x} count each cs  / unmistakeable numbers
2| 1
4| 4
3| 7
7| 8
```
The numbers we are looking for – 1, 4, 7, and 8 – are all unmistakeable, so easy to identify and count:

```q
q)sum in[;key un]raze(count'')notes`signal 
26i
```

Putting it together:

```q
notes:flip`sample`signal!" "vs''trim each("**";"|")0:read0`$"input/08.txt"
sw:except[;" "]distinct raze seg:6 cut" aaaa b    cb    c dddd e    fe    f gggg " / segments and signal wires
cs:string css:`abcefg`cf`acdeg`acdfg`bcdf`abdfg`abdefg`acf`abcdefg`abcdfg / canonical signals
un:{lc!x?lc:where 1=count each group x} count each cs  / unmistakeable numbers: count | #
a[`$"8-1"]:sum in[;key un]raze(count'')notes`signal
```

## Part 2

Begin the analysis of each note by looking at how 1, 4, and 7 are represented. 
(We ignore 8 because it contains *all* the segments and so cannot help us eliminate any permutations.)
Find the sample signals for `1 4 7` and pair them with their canonical signals.

```q
q)q:first notes
q)show as:1 4 7!{x(;)'y .[?](count'')(y;x)}[cs 1 4 7;q`sample]  / analysis samples
1| "cf"   "be"
4| "bcdf" "cgeb"
7| "acf"  "edb"
```

Note above the terse use of the list `(;)` as a binary that pairs two values. 
(The two-item list with oth items missing is syntactic sugar for `enlist[;]`, so lambdas `{enlist[x;y]}` or `{(x;y)}` would be equivalent.)

Note also the use of `.[?](count'')(y;x)` rather than `(count each y)?count each x`.

The `be` signal wires are common to all three. When we remove them, we see from 7 that `d` maps to `a`, and from 4 that `cg` maps to either `bd` or `db`.

```q
q).[except']each as(7 1;4 1)
,"a" ,"d"
"bd" "cg"
```

What we know so far:

```q
q)(as 1#1),.[except']each as(7 1;4 1)
"cf" "be"
,"a" ,"d"
"bd" "cg"

q)show dm sw?(as 1#1),.[except']each as(7 1;4 1)  / as signal wires
2 5 1 4
0   3
1 3 2 6
```

The unmistakeable numbers thus restrict the number of permutations we need to explore. 
Start by listing them.

```q
q)show pl:(1 7#0N)cp/dm  / permutation list
3 2 1 6  4
3 2 4 6  1
3 6 1 2  4
3 6 4 2  1
```

What’s going on here? We start with a single item: seven nulls indicate any signal wire can be mapped to any position. 
As the left argument of `cp/` it is the initial state amended by applying `cp` to each item of `dm`.

The first item of `dm` tells us that 1 and 4 map to positions `2 5` or `5 2`. 

```q
q)first dm
2 5
1 4

q)cp[1 7#0N;first dm]
  1   4
  4   1

q)"01234567"cp[1 7#0N;first dm]  / make nulls visible
"  1  4 "
"  4  1 "
```

Each iteration of `cp` returns copies of the permutations with some nulls replaced.

```q
cp:{n:count x; i:(::;y 0); / crystallise permutation 
  $[count[y 0]-1;.[(2*n)#x;i;:;(1 reverse\y 1)where 2#n];.[x;i;:;first y 1]] }
```

Note above the use of `1 reverse\` as equivalent to `{(x;reverse x)}`.

Complete the permutation list with the remaining possibilities.

```q
pl:cp[pl] (where any null pl;til[count sw]except pl 0)
```

Only one of these permutations will yield all eight signal mappings. 
We `asc` each of them so they can be compared to the canonical signals.

```q
q)first pl where all each in[;css]`$(asc'')sw pl?\:sw?q`sample
3 6 1 2 0 4 5
```

Use the winning permutation to decode the signal.

```q
q)css?`$asc each sw p?sw?q`signal
8 3 9 4
```

Putting it all together:

```q
cp:{n:count x; i:(::;y 0); / crystallize permutation 
  $[count[y 0]-1;.[(2*n)#x;i;:;(1 reverse\y 1)where 2#n];.[x;i;:;first y 1]] }
an:{ / analyze note
  as:1 4 7!(cs 1 4 7)(;)'x[`sample].[?](count'')(x`sample;cs 1 4 7);  / analysis samples
  dm:sw?(as 1#1),.[except']each as(7 1;4 1);  / dictionary of mappings
  pl:(1 7#0N)cp/dm; / permutations given by unmistakeable numbers
  pl:cp[pl] (where any null pl;til[count sw]except pl 0); / complete the permutation list
  p:first pl where all each in[;css]`$(asc'')sw pl?\:sw?x`sample; / winning permutation
  10 sv css?`$asc each sw p?sw?x`signal }
a[`$"8-2"]:sum an each notes
```

