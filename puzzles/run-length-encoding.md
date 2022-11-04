# Run-length encoding

## Problem

Suppose we have a string of characters from the english alphabet:

```q
"aaaaaaaabbbbbbcccdeeeeeeefffbbaaab"
```

All of that repetition hurts the eyes! Please fix it by implementing the rule:

* groups of repeating characters are replaced by the character followed by its count;
* groups of one character are left alone.

Applying this rule, the above becomes a slender:

```q
"a8b6c3de7f3b2a3b"
```

Much nicer!

## Solution 1

Let's tackle the problem in 2 steps. First, we split the string into character groups. Second, we calculate the counts and construct the output string.

To find the character groups, it is enough to locate where a character differs from its predecessor. This is a pretty common task, and luckily for us Q handles it out of the box:

```q
q)s:"aaaaaaaabbbbbbcccdeeeeeeefffbbaaab"
q)differ s
1000000010000010011000000100101001b
```

With mask in hand, cutting the string is straightforward:

```q
q)(where differ s) cut s
"aaaaaaaa"
"bbbbbb"
"ccc"
,"d"
"eeeeeee"
"fff"
"bb"
"aaa"
,"b"
```

From here we compute the counts and apply our rule, being careful to handle the single character special case! 

```q
q){(x;(first x),string cnt) 1<cnt:count x} each (where differ s) cut s
"a8"
"b6"
"c3"
,"d"
"e7"
"f3"
"b2"
"a3"
,"b"
```

The only thing left to do is flatten the list into the result string, giving a final solution:

```q
q)sol1:{[s] raze {(x;(first x),string cnt) 1<cnt:count x} each (where differ s) cut s}
q)sol1 s
"a8b6c3de7f3b2a3b"
```

## Solution 2

```q
q)sol2:{[s] raze (neg[1]_s starts),'{[cnt]("";string cnt) 1<cnt} each 1_deltas starts:(where differ s),count s}
q)sol2 s
"a8b6c3de7f3b2a3b"
```

## Solution 3

```q
q)sol3:{(raze/)flip(x;string@[;;:;0N].(where 1=)\[1;]deltas@)@'-1 1_\:where differ x,"\n"}
q)sol3 s
"a8b6c3de7f3b2a3b"
```

## Performance indication

```q
q)t:1000000?("a";"b";"c")
q)\ts sol1 t
237 45222608
q)\ts sol2 t
213 54659648
q)\ts sol3 t
153 76546720
```

---

Contributors

* George Berkeley
* Stephen Taylor
