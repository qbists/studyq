# Four is magic

![Four block](img/2ADY7DK.jpg)
## Summary 

*Convergence and finite-state machines*

The Scan form of the **Converge iterator** generates the converging sequence of string lengths. 

Modifying the iterated function to return strings _and_ their lengths yielded a list from the convergence from which the strings could be selected by **Index**. 

A vector of pre-calculated string lengths constitutes a **finite-state machine** that generates the sequence three orders of magnitude faster than stringifying the integers as required. 

7 code lines: no loops, counters, or control structures.


## Question 

*Generate a converging integer sequence*

Another simple children’s game – and a popular programming challenge.

Start with a positive integer. Write it in English as a string, and count the length of the string. Print the result as e.g. “eleven is six” and use the count as the next number in the sequence. When you reach four, print “four is magic”. For example:

> Eleven is six, six is three, three is five, five is four, four is magic.

[Rosetta Code](http://rosettacode.org/wiki/Four_is_magic "rosettacode.org")
for full task details

We are going to need the small cardinal numbers, eventually as strings, but to start with, as symbols.

```q
C:``one`two`three`four`five`six`seven`eight`nine`ten,
  `eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen
```


## Finite-state machine

Experimenting with just these numbers yields useful insights.

```q
q)show sl:count each string C
0 3 3 5 4 4 3 5 5 4 3 6 6 8 8 7 7 9 8 8
```

**Every item of the vector is an index of it:**
the vector of string lengths constitutes a finite-state machine.

One and only one item matches its index: 4.
Running the machine will converge there.

Four really is magic.

```q
q)sl 11
6
q)sl 6
3
q)sl 3
5
q)sl 5
4
q)sl 4
4
q)sl\[11]
11 6 3 5 4
q)C sl\[11]
`eleven`six`three`five`four
```

**Tip** The same syntax applies a function to an argument or a list to its indexes

That means a finite-state machine represented as a list of its indexes can be iterated through its states without writing any further logic. 

That applies not just to vectors of indexes but to any dictionary `d` for which `all(value d)in key d` is true.

We can see here the core of a solution, at least for as many cardinals as we have string versions. But whether we cache strings for all the cardinals we need, or generate them at need, either way we need a function that will stringify a number.


## Outline solution

Expressing numbers on the short scale means we can analyze this problem into two parts. We shall work in symbols and cast to string only when everything else has been done.

`st`

: Stringify a number below a thousand.

`s`

: Break a number >1000 into 3-digit groups, and stringify each with `st`.

`fim`

: Generate the converging sequence and format it.


## Stringify a small number

Define `st` first. We shall need strings for multiples of ten.

```q
/ tens
T:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety
```

If `x<20` then `st x` is simply `C x`; otherwise, if `x<100` then `st x` is `(T;C)@'10 vs x`; otherwise we use `C` to stringify the hundreds and `st` on the remainder.

```q
st:{ / stringify <1000
  $[x<20; C x;
    x<100; (T;C)@'10 vs x;
    {C[y],`hundred,$[z=0;`;x z]}[.z.s] . 100 vs x] }
```
```q
q)st 456
`four`hundred`fifty`six
q)st 400
`four`hundred`
q)st 35
`thirty`five
```


## Stringify a large number

The first move is `st each 1000 vs x` to break the number into 3-digit groups and stringify them.

```q
q)1000 vs 12345678
12 345 678
q)st each 1000 vs 12345678
`twelve
`three`hundred`forty`five
`six`hundred`seventy`eight
```

Next, magnitudes.

```q
/ magnitudes
M:``thousand`million`billion`trillion`quadrillion`quintillion`sextillion`septillion
```
```q
q){x{$[x~`;x;x,y]}'M reverse til count x} st each 1000 vs 12345678
`twelve`million
`three`hundred`forty`five`thousand
`six`hundred`seventy`eight`
```

Finish it off.

```q
s:{$[x=0; "zero";
  {" "sv string except[;`]raze x{$[x~`;x;x,y]}'M reverse til count x}st each 1000 vs x]}
```
```q
q)s 12345678
"twelve million three hundred forty five thousand six hundred seventy eight"
```


## Iterate

Generating the convergence is now easy: stringify, count, repeat.

```q
q)(count s@)\[12345678]
12345678 74 12 6 3 5 4
```

!!! tip "The composition `(count s@)` is equivalent to the lambda `{count s x}`"

Stringify the sequence and use Each Prior to format in pairs.

```q
q)raze 1_{y," is ",x,", "}prior s each(count s@)\[12345678]
"twelve million three hundred forty five thousand six hundred seventy eight is seventy..
```

Finish off.

```q
fim:{@[;0;upper],[;"four is magic.\n"]
  raze 1_{y," is ",x,", "}prior s each(count s@)\[x]}
```

And test.

```q
q)1 raze fim each 0 4 8 16 25 89 365 2586 25865 369854 40000000001;
Zero is four, four is magic.
Four is magic.
Eight is five, five is four, four is magic.
Sixteen is seven, seven is five, five is four, four is magic.
Twenty five is eleven, eleven is six, six is three, three is five, five is four, four is magic.
Eighty nine is eleven, eleven is six, six is three, three is five, five is four, four is magic.
Three hundred sixty five is twenty four, twenty four is eleven, eleven is six, six is three, three is five, five is four, four is magic.
Two thousand five hundred eighty six is thirty six, thirty six is ten, ten is three, three is five, five is four, four is magic.
Twenty five thousand eight hundred sixty five is forty five, forty five is ten, ten is three, three is five, five is four, four is magic.
Three hundred sixty nine thousand eight hundred fifty four is fifty eight, fifty eight is eleven, eleven is six, six is three, three is five, five is four, four is magic.
Forty billion one is seventeen, seventeen is nine, nine is four, four is magic.
```


## Test your understanding

All those integers got stringified by `(count s@)\` but we did not keep the strings.
Instead we stringified the numbers a second time.

Replace `s each(count s@)\` with an expression that applies `s` once only to each number.

**Answer**

The sequence is generated by the [Converge](https://code.kx.com/q/ref/accumulators#converge) iterator with the syntactic form `f\[x]`. 
In the solution above `f` is `count s@`. 
(The composition is equivalent to `{count s x}`.)
That returns the count of the string. 

All we have to do is include the string in the result without using it to generate the next iteration. 
Happily we are spared a test, because `first` on an atom is a no-op.
Our new `f`:

```q
q)show q:{(count str;str:s first x)}\[12345678]
12345678
(74;"twelve million three hundred forty five thousand six hundred seventy eight")
(12;"seventy four")
(6;"twelve")
(3;"six")
(5;"three")
(4;"five")
(4;"four")
```

Note above that the 0th item of the result comes from applying `f` zero times to the argument 12345678, i.e. a no-op. 
When you apply a function derived by the Scan form of the [Converge, Do or While iterators](https://code.kx.com/q/ref/accumulators), the first item of the result is always the derived function’s argument unchanged. 
It follows that items of the resulting list might not have uniform type.

We can extract the strings with `(1 _ q)[;1]` but functional forms allow us to embed the extraction in the line without defining a variable.

```q
{x[;1]} 1_{(count str;str:s first x)}\[12345678]
```

Of course, we do not need a lambda when we have [Index](https://code.kx.com/q/ref/apply#index).

```q
.[;(::;1)]1_{(count str;str:s first x)}\[12345678]
```


## Caching results

If you had to calculate a lot of these sequences you might prefer to cache some strings and stringify only numbers beyond the cache.

```q
q)CL:count each CACHE:s each til 1000000

q)CL\[123456]
123456 56 9 4

q)CACHE CL\[123456]
"one hundred twenty three thousand four hundred fifty six"
"fifty six"
"nine"
"four"

q)\ts:100000 .[;(::;1)] 1_{(count str;str:s first x)}\[123456]
4573 3040
q)\ts:10000 CACHE CL\[123456]
5 800
```

We see using the vector of string lengths as a finite-state machine is three orders of magnitude faster than stringifying the four numbers. 


## Review

The solution is small and well modularized, with three constants and three functions. 

```q
/ small cardinal numbers
C:``one`two`three`four`five`six`seven`eight`nine`ten,
  `eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen
/ tens
T:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety
/ magnitudes
M:``thousand`million`billion`trillion`quadrillion`quintillion`sextillion`septillion

st:{ / stringify <1000
  $[x<20; C x;
    x<100; (T;C)@'10 vs x;
    {C[y],`hundred,$[z=0;`;x z]}[.z.s] . 100 vs x] } 

/ stringify
s:{$[x=0; "zero"; 
  {" "sv string except[;`]raze x{$[x~`;x;x,y]}'M reverse til count x} st each 1000 vs x] }

/ four is magic
fim:{@[;0;upper],[;"four is magic.\n"] raze 1_{y," is ",x,", "} prior 
  .[;(::;1)] 1_{(count str;str:s first x)}\[x] } 
```

The sequence is generated by applying a function with the [Converge iterator](https://code.kx.com/q/ref/accumulators#converge). The function stringifies an integer argument and returns the string length.

Modifying the iterated function to return both the string and its length avoids having to stringify the numbers a second time. 

Caching strings yields a vector of string lengths that can be used with Converge as a finite-state machine, three orders of magnitude faster than stringifying numbers on the fly. 

