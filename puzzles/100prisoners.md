# One Hundred Prisoners

The [One Hundred Prisoners problem](https://en.wikipedia.org/wiki/100_prisoners_problem "Wikipedia") has a famously counter-intuitive solution, nicely explained on YouTube:

https://www.youtube.com/watch?v=iSNsgj1OCLA

Exploring it in q is illuminating!

George Berkeley kicked this off in the Vector Dōjō :

> A problem I found interesting, and maybe you will too… You can view a vector `v = (1 0 2 3 5 6 4)` as a permutation, i.e. given an index `i`, the permutation sends `i` to `v[i]`. If we apply the permutation multiple times, then eventually we end up where we started. In fact, if we look at `v`, we can see it breaks down into the following cycles:
> 
> 	0 -> 1 -> 0
> 	2 -> 2
> 	3 -> 3
> 	4 -> 5 -> 6 -> 4
> 
> Given a permutation, return the number of cycles! (so 4 for the given `v`)

```q
q)v:1 0 2 3 5 6 4
q)v scan 0
0 1
q)(v scan)each 0 2 3 4
0 1
,2
,3
4 5 6
```

Each item belongs to one and only one cycle. Above, we see all the items, so we see there are only four cycles. A more brute-force approach:

```q
q)(v scan)each v
1 0
0 1
,2
,3
5 6 4
6 4 5
4 5 6
```

`0 1` and `1 0` are the same cycle. Sorting each cycle lets us remove duplicates and count.

```q
q)distinct(asc v scan)each v
`s#0 1
`s#,2
`s#,3
`s#4 5 6

q)count distinct(asc v scan)each v
4
```

Rian Ó Cuinnegáin linked the problem to the One Hundred Prisoners problem. The key to the problem (spoiler) is that in 100-item permutations, there is about a one-in-three chance that the maximum cycle length is no more than 50. (Above, it is 3.)

```q
q)max(count v scan)each v
3
q)max{(count x scan)each x} -100?100
44
q)max{(count x scan)each x} -100?100
55
q)max{(count x scan)each x} -100?100
90
```

This could be smarter. Consider the last case. The longest cycle has 90 items. Once it is found, we have the cycle length for all 90 of its items. We no longer need to evaluate the other 89. 

Let’s work on a state with three items: the cycle length for each index, the permutation itself, and the untested indices.

```q
q)show q:-10?10 / test
5 0 1 9 2 6 8 4 7 3
q)is:(#[;0]count@;::;til count@)@\: / initial state
q)is q
0 0 0 0 0 0 0 0 0 0
5 0 1 9 2 6 8 4 7 3
0 1 2 3 4 5 6 7 8 9
```

Now a step function that updates the state by evaluating the next index.

```q
q)step:{[c;p;i] if[count i;c[r]:count r:p scan i 0];(c;p;where not c)} .

q)step is q
8 8 8 0 8 8 8 8 8 0
5 0 1 9 2 6 8 4 7 3
3 9
```

Above, the cycle of which 0 is a member has length 8. After the first step, only two indices remain to evaluate.
So much less work to do:

```q
q)p:-100?100

q)\t:1000 max(count p scan)each p
134
q)\t:1000 max first step over is p
13
```

This approach also quickly gives us the answer to the question George first posed: how many cycles are in the permutation? The first item of a scan result is of course the initial state; we count the rest.

```q
q)-1+ count step scan is v
4
q)-1+ count step scan is p
6
```

My thanks to Vector Dōjō tutors Rian Ó Cuinnegáin and Cillian Murphy for their work on this.