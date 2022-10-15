# ABC problem

![Letter blocks](img/WJEGGB.jpg)



## Summary 

*Search a tree of possibilities, stop when you find one*

A simple problem requires **recursively searching a tree** of possible solutions. 

**Each Right** is used to generate the next round of searches, and to evaluate them. 
Using **Index At** with **nested indexes** avoids two nested loops.

A global variable is used to **end the search** after a solution is found.

Core solution has three code lines: no loops, no counters.

## Problem

*Determine whether a string can be composed from a set of blocks*

You are given a collection of ABC blocks, maybe like the ones you had when you were a kid.
There are twenty blocks, with two letters on each block.
A complete alphabet is guaranteed amongst all sides of the blocks.

Write a function that takes a string (word) and determines whether the word can be spelled with the given collection of blocks. The rules are simple:

*   Once a letter on a block is used that block cannot be used again
*   The function should be case-insensitive

from [Rosetta Code](http://rosettacode.org/wiki/ABC_problem)

    
## Test cases

Example collection of blocks:

    (B O)
    (X K)
    (D Q)
    (C P)
    (N A)
    (G T)
    (R E)
    (T G)
    (Q D)
    (F S)
    (J W)
    (H U)
    (V I)
    (A N)
    (O B)
    (E R)
    (F S)
    (L Y)
    (P C)
    (Z M)

Example results from those blocks:

```python
>>> can_make_word("A")
True
>>> can_make_word("BARK")
True
>>> can_make_word("BOOK")
False
>>> can_make_word("TREAT")
True
>>> can_make_word("COMMON")
False
>>> can_make_word("SQUAD")
True
>>> can_make_word("CONFUSE")
True
```

## General case

### Backtracking

Each block you pick to supply a letter also removes its obverse from the available letters. For example, if you use VI for a V, you no longer have an I available. So you cannot make words such as _live_, _vial_, or _evil_ from the example blocks. Similarly, Y and L are on the same block and are not repeated: _quickly_ cannot be made.

For some letters there is a choice of blocks from which to pick. In the example blocks, you could pick a B from either BO or OB. It does not matter which: either way both B and O remain available. _As it happens_, the example blocks duplicate letters only in pairs. The BO/OB pairing is repeated for CP/PC, GT/TG, etc., and these are the only duplicated letters. _The rules do not specify this_, so the example blocks are a special case.

In the general case, different choices of block for a duplicated letter leave you with different sets of blocks from which to fill the rest of the string. Every time you have a choice of blocks, the possibilities proliferate.
Some may succeed, some may not.

The author of the [Fortran solution on Rosetta Code](http://rosettacode.org/wiki/ABC_problem#Fortran) notes this issue and offers a second solution of 277 code lines to deal with the general case, which the author refers to as “backtracking”.

We shall solve _only_ the general case.
It cries out for a recursive search of the tree of possibilities.


### Blocks, tiles, and pyramids

The problem refers to blocks bearing two letters each.
They might better be thought of as tiles, with a letter on each side.

A block can bear six letters on its sides. For that matter, a pyramid can bear four, and a dodecahedron twelve.

While the problem specifies two letters, we shall stay open to the possibility of code that works for any number of letters on each block.


## Core solution

The core of the solution is recursive.

1.  If the string is empty, all its letters have been matched and the result is `1b`.
1.  If you cannot fill the first letter of the string `s[0]` from the available blocks, the result is `0b`.
1.  Otherwise, find all the blocks that match `s[0]`. For each block, remove it from the available blocks, and call the function to see if you can make `1_s`. The result is whether any of these calls returns `1b`.

*Tip* A lambda can use `.z.s` to refer to itself.

```q
BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

cmw:{[s;b]                                                  / [string; blocks]
  $[0=count s; 1b;                                          /   empty string
    not any found:any each b=s 0; 0b;                       /   cannot proceed
    any(1_s).z.s/:b(til count b)except/:where found] }
```
```q
q)WORDS cmw\:BLOCKS
1101011b
```

The lines of `cmw` correspond to the steps 1–3 above.

Note the use of [Each Right](https://code.kx.com/q/ref/maps#each-left-and-each-right) `/:` first to generate the lists of blocks to be tried

```q
(til count b)except/:where found]
```

then to recurse with the rest of the string: `(1_s).z.s/:`.

Note also that the list of blocks `b` is applied to the lists of indexes. In full that would be

```q
b@(til count b)except/:where found]
```

[Index At](https://code.kx.com/q/ref/apply#index-at) `@` is elided here, but elided or not, is atomic, so there is no need to iterate `b` through the lists of indexes. Iteration is free!


## Case sensitivity

The problem requires the solution be insensitive to case in the words.

```q
Words:string`A`bark`BOOK`Treat`COMMON`squad`CONFUSE
cmwi:{cmw[;y]upper x}   / case-insensitive
```
```q
q)Words cmwi\:BLOCKS
1101011b
```


## Letters per block

The search of available blocks is `any each b=s 0`. This is independent of the number of letters on the blocks.

```q
q)show B6:upper string 10?`6
"MILGLI"
"IGFBAG"
"KAODHB"
"BAFCLB"
"KFHOGJ"
"JECPAE"
"KFMOHP"
"LKKLCO"
"KFIFPA"
"FGLGOF"

q)WORDS cmw\:B6
1010000b
```


## Stopping the search

More blocks and duplicate letters mean more solutions for any given string, and a solution is easier to find.
But that increases the work `cmw` must do, because `cmw` finds _all_ the solutions. However, we need only one, and would prefer evaluation stop after the first solution has been found.

For that we shall set a global variable and recurse, not `cmw`, but an anonymous lambda.

```q
cmws:{[x;y]                                                 / cmw – stop search
  .cmw.done::0b;                                            /   start search
  {[s;b]                                                    /   [string; blocks]
    $[.cmw.done; 1b;                                        /     call off search
      .cmw.done::0=count s; 1b;                             /     empty string
      not any found:any each b=s 0; 0b;                     /     cannot proceed
      any(1_s).z.s/:b(til count b)except/:where found] }[x;y] }
```
```q
q)\ts:100 WORDS cmw\:BLOCKS
83 5456
q)\ts:100 WORDS cmws\:BLOCKS
25 5440
```


## Test your understanding

Can you test `.cmw.done` outside the [Cond](https://code.kx.com/q/ref/cond) with `or` as e.g.

```q
.cmw.done or {[s;b]
```

Answer: No – both arguments of `or` are evaluated. (You are thinking of another programming language.)


## Review

The general case of the problem requires a tree search. That is easily expressed:

-   Each Right to generate lists of indexes to try
-   Apply list of blocks `b` direct to the nested lists of indexes
-   Each Right to recurse the function through the lists of blocks

The lambda used `.z.s` to refer to itself: it does not need a name to recurse.

The search through the tree of possibilities can be stopped by reading a global flag set when a solution is found.

Case-insensitivity is trivial. 

The solution is not limited to two letters per block.

Perhaps best of all, the solution is highly _legible_. 
The three code lines of the core solution correspond closely to an English description of the solution steps. 


