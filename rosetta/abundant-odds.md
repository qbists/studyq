# Abundant Odds


![Number series](img/G36AKX.jpg)

## Summary 

*Use iterators to find values in a series that pass a test*

Filter a list for items that pass a test that may be CPU-intensive. 

Stop an iteration when

-   it finds a value that passes a test
-   a specified number of values have been found


## Problem

*Find abundant odd numbers*

An [abundant number](https://en.wikipedia.org/wiki/Abundant_number "Wikipedia") is a number $n$ for which the sum of proper divisors $s(n)>n$.

Abundant numbers are common, though even abundant numbers seem to be much more common than odd abundant numbers.

Find and display with their proper divisor sums

1.  the first 25 abundant odd numbers
1.  the thousandth abundant odd number
1.  the first abundant odd number greater than one billion (10<sup>9</sup>)

from [Rosetta Code](http://rosettacode.org/wiki/Abundant_odd_numbers)


## Proper divisors and their sum

A naïve algorithm for the proper divisors of integer `x`.

```q
s:{c where 0=x mod c:1+til x div 2}            / proper divisors
```

That gives us `sd` for their sum, and `abundant` for whether `x` is an abundant number.

```q
sd:sum s@                                      / sum of proper divisors
abundant:{x<sd x}
```

The composition `sum s@` is equivalent to the lambda `{sum s x}`.


## Search the odd integers

We can answer the first two questions by finding the first 1000+ abundant odd numbers.

```q
Filter:{y where x peach y}
A:Filter[abundant] 945+2*til 260000
```

Our naïve `s` is CPU-intensive, so `Filter` uses `peach` to distribute the work between any secondary threads q is [allowed to run](https://code.kx.com/q/basics/cmdline#-s-secondary-threads).

We know the first abundant odd number is 945, so we start our search at 945.

Did we find enough abundant numbers?

```q
q)count A
1057
```

We did. Now we can answer the first two questions.


## First two answers

```q
q)1 sd'\25#A   / first 25 abundant odd numbers, and the sum of their divisors
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 7875 8085 8415 8505 8925 9135 9555 9765  10395 11025
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 8349 8331 8433 8967 8931 9585 9597 10203 12645 11946

q)1 sd\A 999   / 1000th abundant odd number and the sum of its divisors
492975 519361
```

What is that `\` doing, and how are we getting both the numbers and the sums of their divisors?

Start with Q2, the thousandth abundant odd number. `A` is a list of the first 1057 abundant odd numbers, so `A 999` (or `A@999` or `A[999]`) is the number itself, and `sd` returns the sum of its divisors.

```q
q)A 999
492975
q)sd A 999
519361
```

So we could write our answer as

```q
q)(A 999;sd A 999)
492975 519361
```

But this is equivalent to the results of applying `sd` zero and one times. The Scan version of the [Do iterator](https://code.kx.com/q/ref/accumulators#do) returns both results.

```q
q)1 sd\A 999
492975 519361
```

Next, Q1. Here `25#A` is a vector. Apply the unary `sd` to each item

```q
q)sd each 25#A
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

Now, `each` is a bit of syntactic sugar q provides because we have no prefix syntax for using an iterator to apply a unary. But we could actually use bracket notation to apply the unary `sd'`.

```q
q)sd'[25#A]
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

The last step uses the same move as in Q2. We use `1 sd'\25#A` to get the results of applying `sd'` zero and one times to `25#A`.

That gets us a 2-item list: `(25#A;sd each 25#A)`.

```q
q)1 sd'\25#A
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 787..
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```


## Combining iterators

Where did the brackets go in `1 sd'\25#A`?

**For a unary function `f` the derived function `f\` is variadic and can be applied as a binary with infix syntax.**

The function `f\` derived by the iterator has a binary application: apply `f` successively `x` times to `y`.
You can apply `f` successively `x` times to `y` either

```q
x f\y        / infix syntax, preferred
f\[x;y]
```

Here `x` is 1, `y` is `25#A` and `f` is `sd'`.

Lastly we note that iterators such as `'` (Each) and `\` (Do) are unary operators with _postfix_ syntax, i.e. an iterator is written to the _right_ of its argument.

### Iterator syntax

In `sd'`, the argument of Each is `sd`, and in `sd'\`, the argument of Scan is `sd'`.

Combining iterators affords great power.
It is possible to do it with bracket notation

```q
q)(\[sd])[1;A 999]
492975 519361
q)(\['[sd]])[1;25#A]
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 787..
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

or (partly) with keywords such as `each`

```q
q)(sd each)\[1;25#A]
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 787..
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

but the combinations quickly become cumbersome.
Best to master iterator syntax.

```q
q)1 sd'\25#A
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 787..
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

## Beyond a billion

Q3 asks for the lowest abundant odd number that is bigger than 1,000,000,000.

The While iterator expresses what we want.

```q
q)1 sd\(not abundant@)(2+)/(prd 9#10)+1
1000000575 1083561009
```

We recognize the `1 sd\` form of reporting the result and the sum of its divisors.

Here the iterator is [While](https://code.kx.com/q/ref/accumulators#while) and its argument is the projection `2+` i.e. Add 2. The derived function `(2+)/` adds 2 to the right argument at each iteration, starting here from a `y` of a billion plus one.

The `x` in `x(2+)/y` is `(not abundant@)`. That is a composition, equivalent to `{not abundant x}`. The iterator keeps incrementing by 2 as long as the test in `x` fails; i.e. it will stop and return a result as soon as an abundant odd number is found.


## Keeping the sum

Finding the proper divisors of 1,000,000,575 with the naïve algorithm is a non-trivial computation. Rather than find an abundant number and apply `sd` to it again, it would be more efficient to keep the sum.

We could replace `sd` with a function that returns both `x` and `sd x`, then use `,` to compare them.

```q
q)(<) . {x,sd x} 944   / not abundant
0b
q)(<) . {x,sd x} 945   / abundant
1b
```

But that `{x,sd x}` looks familiar.

```q
q)1 sd\945
945 975
```

So we could write our filter expression to select from a list of pairs.

```q
q)Filter[(<).]flip 1 sd'\899+2*til 700
945  975
1575 1649
2205 2241
```

Can we do something similar for Q3?


## While again

To keep the divisor sums, we need them computed in the iterator’s argument and in its result. 

We use a function that takes an odd number and its divisors sum, and returns the next odd number and its divisors sum.

```q
q){1 sd\2+x 0}1000000571 0
1000000573 212728259
```

That zero in the second place was _not_ the divisors sum of 1000000571 but it does not matter, because the function ignores it.
We just need the sum to ‘tag along’ so it appears in the final result.

```q
q)(.[>]){1 sd\2+x 0}/1000000001 0
1000000575 1083561009
```

The test condition `(.[>])` is Apply Greater Than, which applies `>` to a pair as its left and right arguments.


## Stop when you have enough

Just to round this off, we can now see how to find the first 25 abundant odd numbers and then stop.

Above the ‘seed’ for the iteration was `1000000001 0`. For Q3 we shall use a seed of `(1;())` representing

-   1, the first odd number
-   a list of all the results found so far, i.e. none.

We iterate a function that returns the next odd number and the updated list.
Here it is, applied to the seed.

```q
q){sm:sd n:x+2;(n;$[n<sm;y,enlist n,sm;y])}. (1;())
3
()
```
Here it encounters the first abundant odd number.

```q
q){sm:sd n:x+2;(n;$[n<sm;y,enlist n,sm;y])}. (943;())
945
,945 975
```

We can simplify it a bit by composing it with a function that does the incrementing.

```q
q)({(x;y,(x<sm)#enlist x,sm:sd x)}. 2 0+) (943;())
945
,945 975
```

Now iterate that with While until the list count hits 25.

```q
q)flip{x 1}r:{25>count x 1}({(x;y,(x<sm)#enlist x,sm:sd x)}. 2 0+)/(1;())
945 1575 2205 2835 3465 4095 4725 5355 5775 5985 6435 6615 6825 7245 7425 787..
975 1649 2241 2973 4023 4641 5195 5877 6129 6495 6669 7065 7063 7731 7455 834..
```

Test your understanding:
What is `r 0` above?

Answer:

```q
q)r 0
11025
```

The first item of the result `r` is the last abundant odd number found.

```q
q)last r 1
11025 11946
```


## Review

Our first strategy was to calculate $s(n)$ for each of the first quarter million or so odd numbers and filter out those whose $s(n)$ exceeded them. 
That found over a thousand abundant odd numbers, so we could answer Q1 and Q2.

We had however recalculated $s(n)$ for the abundant numbers, so we amended the expression to work on pairs (number and $s(n)$), using the Do iterator to construct the pairs.

Q3 took us to the While iterator to proceed from 1,000,000,001 to the next abundant odd number, returning both the number and its $s(n)$.

From that we could adapt the technique to solve Q2 with a While iteration that stops when the 25th value has been found.

The While iterator uses a truth condition that tests the result of the function being iterated. 
Where the truth condition 

-   tests only the current value, the iterated function need only produce it, e.g. `2+`
-   needs to test anything else it must either refer to a global variable or find what it needs to test in the result of the iterated function

In the second solution for Q2, $s(n)$ is calculated in the iterated function, and a list of abundant numbers and their divisor sums updated and passed to the next iteration.

