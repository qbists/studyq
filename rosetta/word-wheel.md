# Word wheels


<table>
  <tr><td>N</td><td>D</td><td>E</td></tr>
  <tr><td>O</td><td><b>K</b></td><td>G</td></tr>
  <tr><td>E</td><td>L</td><td>W</td></tr>
</table>

Find all the words containing K that can be composed from the letters in the grid. Use letters no more times than they appear in the grid.

## Summary 

*Multiple levels of iteration and nested indexes*

Test whether a word can be composed from a grid by examining the difference of their letter counts.

Minimize the number of tests by making a matrix of all the results, then indexing into it. 

Compose iterated functions to iterate through the lists of indexes.

Use simple syntactic substitution to parallelize the key computation. 

* Six code lines for Part 1; twelve for Part 2
* No loops, no counters, no control structures.


## Question

*Write a program to solve the word-wheel puzzle*

Words must contain at least three letters and appear in the [National Puzzlers’ League dictionary](http://wiki.puzzlers.org/pub/wordlists/unixdict.txt).

Write programs to

1. Solve a grid: find all the words that can be composed from it that contain its middle letter
2.  Find the grids with the longest solutions that include a 9-letter word

from [Rosetta Code](http://rosettacode.org/wiki/Word_wheel) 


## Get a vocabulary

**Dictionaries and vocabularies** To avoid confusion between _dictionary_ as a q data structure, and as a list of words, we refer here to the latter as a _vocabulary_.

Reading the vocabulary is straightforward enough, but we discover words we do not want.

```q
q)show vocab:"\n"vs .Q.hg "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
"10th"
"1st"
"2nd"
"3rd"
"4th"
"5th"
"6th"
"7th"
"8th"
"9th"
,"a"
"a&m"
"a&p"
"a's"
"aaa"
"aaas"
"aarhus"
"aaron"
"aau"
"aba"
"ababa"
"aback"
..
```

We want only words with 3-9 letters composed of the letters a-z. 
(We see the vocabulary is already in lower case.)

**Note** Sometimes we display lists of strings as symbols just to save space.

```q
q).Q.A in raze vocab          / any upper-case letters here?
00000000000000000000000000b
q)ce:count each
q)`$v39:{x where(ce x)within 3 9}{x where all each x in .Q.a}vocab
`aaa`aaas`aarhus`aaron`aau`aba`ababa`aback`abacus`abalone`abandon`abase`abash..

q)count v39
20664
```

List `v39` is all the words we might find from a word wheel. 


## Match on the mid letter

The example grid is `"ndeokgelw"`. Its mid letter is k, so only words containing k are candidates.

```q
q)grid:"ndeokgelw"
q)grid 4
"k"
q)show c:v39 where grid[4]in'v39
"aback"
"ackerman"
"ackley"
"adkins"
"aiken"
"airlock"
"airpark"
..
```


## Test composable

A simple test for whether a word `w` can be composed from a grid `g` is to examine the difference of their letter counts. 

```q
q)lc:ce group@
q)lc grid
n| 1
d| 1
e| 2
o| 1
k| 1
g| 1
l| 1
w| 1
q)(lc grid)-lc "alaska"
n| 1
d| 1
e| 2
o| 1
k| 0
g| 1
l| 0
w| 1
a| -3
s| -1
```

The negative numbers in the difference show `"alaska"` cannot be composed from `"ndeokgelw"`.
The complete test:

```q
q)all 0<=(lc grid)-lc "alaska"
0b
```


## Test all the candidates

Subtract is not atomic in the domain of dictionaries, so we use Each Right to subtract from the grid letter count the letter count of each candidate.

```q
q)c where all each 0<=(lc grid)-/:lc each c
"eke"
"elk"
"keel"
"keen"
"keg"
"ken"
"keno"
"knee"
"kneel"
"knew"
"know"
"knowledge"
"kong"
"leek"
"week"
"wok"
"woke"
```

Putting that all together:

```q
ce:count each
lc:ce group@
vocab:"\n"vs .Q.hg "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
v39:{x where(ce x)within 3 9}{x where all each x in .Q.a}vocab

solve:{[g;v]
  i:where(g 4)in'v;
  v i where all each 0<=(lc g)-/:lc each v i }[;v39]
```
```q
q)solve "ndeokgelw"
"eke"
"elk"
"keel"
"keen"
"keg"
"ken"
"keno"
"knee"
"kneel"
"knew"
"know"
"knowledge"
"kong"
"leek"
"week"
"wok"
"woke"
```


## Find the best wheel

The `solve` function makes possible a naïve solution to the second question: which grids have the longest solutions – i.e. the most words composable from them?

Every grid with a 9-letter word in its solution is a permutation of that word.
But only the middle letter determines which candidate words need testing against the grid, so nine rotations exhaust the possibilities.

```q
q)count grids:distinct raze(til 9)rotate\:/:v where(ce v)=9
27810
```

Now we just need the length of their solutions and it will be easy to bust out the winners.

```q
bust:{[v]
  grids:distinct raze(til 9)rotate\:/:v where(ce v)=9;
  wc:(count solve@)each grids;
  grids where wc=max wc }
```

While we are waiting for the solutions to over 27,000 grids we have ample time to reflect on what is being done. 

Each call to `solve` finds the vocabulary words that contain the grid’s middle letters. Yet there are only 26 possible middle letters; only 26 of these searches are necessary. We could make a dictionary: the letters a-z keyed to the indexes of words that contain them.

```q
q)`$v39 iaz:(.Q.a)!where each .Q.a in'\:v39
a| `aaa`aaas`aarhus`aaron`aau`aba`ababa`aback`abacus`abalone`abandon`abase`ab..
b| `aba`ababa`aback`abacus`abalone`abandon`abase`abash`abate`abater`abbas`abb..
c| `aback`abacus`abc`abdicate`abduct`abeyance`abject`abreact`abscess`abscissa..
..
```

Further reflection shows us `bust` is performing the letter-count subtraction for each of 27,000+ grids. But rotation makes no difference to the letter count of the grid. There are only 3,088 distinct letter counts for the 27,000+ grids. And each word in the dictionary need be tested only once against each of the 3,088 9-letter words.


## An efficient solution

Start again by listing the indexes of all the words that can be composed from each grid word.

```q
q)vlc:lc each v39                           / letter counts of vocabulary words
q)ig:where(ce v39)=9                        / find grids (9-letter words)
q)igw:where each(all'')0<=(vlc ig)-/:\:vlc  / find words composable from each grid word
```

List `igw` corresponds to the 9-letter grid words. Each item is the vocabulary indexes for words composable from the corresponding grid word.

Each grid word has nine possible mid letters.

```q
q)show ml:4 rotate'v39 ig                   / mid letters for each grid
"minalabdo"
"nathyaber"
"rrentabho"
"itionabol"
"inateabom"
"igineabor"
"issaeabsc"
..
```

Each mid letter selects a different word list from `iaz`.

The first grid word is `"abdominal"`. The first item of `igw` lists the words that can be composed from it.

```q
q)`$v39 igw 0
`aba`abdominal`abo`ada`adam`ado`aid`aida`ail`aim`ala`alai`alamo`alan`alb`alba..
```

The first item of `ml` is the mid letters of the nine permutations of `"abdominal"`. 
Dictionary `iaz` gives us the vocabulary indexes of the words that contain each mid letter.

```q
q)ml 0
"minalabdo"

q)`$v39 iaz ml 0
`abdomen`abdominal`abnormal`abominate`abraham`abram`abramson`abysmal`academe`..
`abdicate`abdominal`abelian`abetting`abide`abidjan`abigail`ablution`abolish`a..
`aaron`abalone`abandon`abdomen`abdominal`abelian`abelson`aberdeen`abernathy`a..
`aaa`aaas`aarhus`aaron`aau`aba`ababa`aback`abacus`abalone`abandon`abase`abash..
`abalone`abdominal`abel`abelian`abelson`abigail`ablate`ablaze`able`ablution`a..
`aaa`aaas`aarhus`aaron`aau`aba`ababa`aback`abacus`abalone`abandon`abase`abash..
`aba`ababa`aback`abacus`abalone`abandon`abase`abash`abate`abater`abbas`abbe`a..
`abandon`abdicate`abdomen`abdominal`abduct`abed`aberdeen`abetted`abhorred`abi..
`aaron`abalone`abandon`abbot`abbott`abdomen`abdominal`abelson`abhorred`abhorr..

```

We just need to select from each list just the words that are composable from `igw 0`, that is

```q
q)`$v39 (igw 0)inter/:iaz ml 0
`abdominal`adam`aim`alamo`alma`almond`ama`ami`amid`amino`animal`balm`bam`bimo..
`abdominal`aid`aida`ail`aim`alai`ali`alia`ami`amid`amino`ani`animal`bail`bali..
`abdominal`alan`almond`amino`ana`and`ani`animal`ban`banal`band`bin`bind`bland..
`aba`abdominal`abo`ada`adam`ado`aid`aida`ail`aim`ala`alai`alamo`alan`alb`alba..
`abdominal`ail`ala`alai`alamo`alan`alb`alba`ali`alia`alma`almond`animal`bail`..
`aba`abdominal`abo`ada`adam`ado`aid`aida`ail`aim`ala`alai`alamo`alan`alb`alba..
`aba`abdominal`abo`alb`alba`bad`bail`bald`bali`balm`bam`ban`banal`band`bid`bi..
`abdominal`ada`adam`ado`aid`aida`almond`amid`and`bad`bald`band`bid`bimodal`bi..
`abdominal`abo`ado`alamo`almond`amino`bimodal`blond`boa`boil`bold`bon`bona`bo..
```

Iterating that through `igw` and `iaz`:

```q
igw inter/:'iaz ml
```

It remains only to raze the lists and count the solution lengths to get the word count for each grid.

```q
wc:ce raze igw inter/:'iaz ml
```

Those grids?

```q
grids:raze(til 9)rotate\:/:v39 ig
```

Putting it all together:

```q
best:{[v]
  vlc:lc each v;                             / letter counts of vocabulary words
  ig:where(ce v)=9;                          / find grids (9-letter words)
  igw:where each(all'')0<=(vlc ig)-/:\:vlc;  / find words composable from each grid
  grids:raze(til 9)rotate\:/:v ig;           / 9 permutations of each grid
  iaz:(.Q.a)!where each .Q.a in'\:v;         / find words containing a, b, etc
  ml:4 rotate'v ig;                          / mid letters for each grid
  wc:ce raze igw inter/:'iaz ml;             / word counts for grids
  distinct grids where wc=max wc }           / grids with most words
```

```q
q)show w:best v39
"ntclaremo"
"tspearmin"

q)ce solve each q
215 215
```


## Parallelization

The heavy CPU lifting in `best` is done by the dictionary subtractions in the definition of `igw`: 3,088 × 20,664 tests. 
This would be a good subject for parallelization, and the compact q code means there is not much to do. 

We shall use the `peach` keyword, which, like `each`, applies a unary function.
But what unary function?

The expression to parallelize here is `(dlc ig)-/:\:dlc`. 
That has the syntax `x f\:y` where `f` is `-/:` and `x` is `dlc ig`. 

Iterators Each Left and Each Right are equivalent to applying Each to a unary. In other words

```q
x f/:y   <=>   f[x;] each y
x f\:y   <=>   f[;y] each x
```

So 

```q
(vlc ig)-/:\:vlc   <=>   -/:[;vlc] each vlc ig
```

which gets us to 

```q
igw:where each(all'')0<=-/:[;vlc]peach vlc ig
```

On the author’s six-core machine with an allowance of four secondary tasks, this halves the execution time of the previous expression. 
You can experiment with settings your own machine, and see whether you iget further improvements by extending the left argument of `peach`.
For example:

```q
igw:{where all each 0<=x-/:y}[;vlc] peach vlc ig
```


## Review

For the first program, `solve`, the key move is to use the difference between letter-count dictionaries to determine whether a word is composable from a grid. 
It helps that dictionaries are in the domain of the Subtract operator.

Having found the words containing the grid’s mid letter, it remained only to select those that are composable from the grid.

The `solve` function suggests a naïve solution for the second program: `bust`iterates `solve` over all the possible grids, counts the solution lengths and picks the longest. 

Waiting for `bust` to complete left time to reflect on the work it was repeating unnecessarily.

In `best` that work is refactored into 

-   a dictionary `iaz` that maps mid letters to words that contain them
-   a list `igw` of the words composable from each of the 9-letter grid words

In both `iaz` and `igw`, vocabulary words are represented by their indexes in `v39`, the list of 3-9 letter words. 
For the nine grids permuted from a single grid word, e.g. `"abdominal"`, we take from `igw` its list of composable words and intersect it with each of the word lists for the mid letters of its permutation.
Easier to express in q than English:

```q
igw inter/:'iaz ml
```

Even the refactored `best` entails over 63 million dictionary subtractions to find which words are composable from each of the 3,088 grid words. 
This is a prime target for parallelization, and where the terse q code comes into its own. 

The `peach` keyword applies a unary function. The expression `(vlc ig)-/:\:vlc` specifies two levels of iteration, but transforms easily into a unary applied by `each`, for which we need only substitute `peach`. 
Still only a single line of code, it is light work to experiment with moving other elements of the calculation within the ambit of `peach`. 

Download: [`ww.q`](ww.q)

