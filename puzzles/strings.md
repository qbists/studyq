# Cats cradle – fun with strings

![Cats cradle](img/cats-cradle.jpg)
<!-- GettyImages-1211439904 -->

 Adapted from John Earnest’s [A World Without Strings is Chaos](http://beyondloom.com/blog/strings.html)

> I developed these programming exercises while working at [1010data](https://1010data.com). Each summer we’d put a batch of half a dozen or so interns through a week-long intensive training program, including this set of puzzles, and then set them loose on the real codebase.

The problems vary in difficulty from trivial to moderately difficult (in non-escalating order), and are suitable for beginners or anyone wishing to brush a little rust off. A solution is provided for each problem. Most problems have at least one elegant solution, but many have multiple valid approaches – see how many ways you can satisfy the requirements!


## Multiplicity

Characters are expensive, and the accountants tell me we can’t hand them out willy-nilly anymore.
Given a string `x` and a character `y`, how many times does `y` occur in `x`?

```q
q)f["fhqwhgads";"h"]
2
q)f["mississippi";"s"]
4
q)f["life";"."]
0
```

---

Answers:
```q
{sum x=y}
{count group[x]y}
```


## Trapeze part

Sometimes I try reading sentences right-to-left to make my life more exciting. Results have been mixed. Given a string `x`, is it identical when read forwards and backwards?

```q
q)f "racecar"
1
q)f "wasitaratisaw"
1
q)f "palindrome"
0
```

---

Answers:
```q
{x~reverse x}
```


## Duplicity

One is the loneliest number. Given a string `x`, produce a list of characters which appear more than once in `x`.

```q
q)f "applause"
"ap"
q)f "foo"
,"o"
q)f "baz"
""
```

---

Answers:

```q
{where 1<count each group x}
```


## Sort yourself out

Alphabetical filing systems are passé. It’s far more Zen to organize words by their histograms! Given strings `x` and `y`, do both strings contain the same letters, possibly in a different order?

```q
q)f["teapot";"toptea"]
1
q)f["apple";"elap"]
0
q)f["listen";"silent"]
1
```

---

Answers:
```q
{asc[x]~asc y}
```


## Precious snowflakes

It’s virtuous to be unique, just like everyone else. Given a string `x`, find all the characters which occur exactly once, in the order they appear.

```q
q)f "somewhat heterogenous"
"mwa rgnu"
q)f "aaabccddefffgg"
"be"
```

---

Answers:
```q
{where 1=count each group x}
```


## Musical chars

Imagine four chars on the edge of a cliff. Say a direct copy of the char nearest the cliff is sent to the back of the line of char and takes the place of the first char. The formerly first char becomes the second, the second becomes the third, and the fourth falls off the cliff. Strings work the same way. Given strings `x` and `y`, is `x` a rotation of the characters in `y`?

```q
q)f["foobar";"barfoo"]
1
q)f["fboaro";"foobar"]
0
q)f["abcde";"deabc"]
1
```

---

Answers:
```q
{x in (1 rotate)scan y}
{y in{raze reverse 0 1 _ x}scan x}
```


## Size matters

Sometimes small things come first. Given a list of strings `x`, sort the strings by length, ascending.

```q
q)f ("books";"apple";"peanut";"aardvark";"melon";"pie")
"pie"
"books"
"apple"
"melon"
"peanut"
"aardvark"
```

---

Answers:
```q
{x iasc count each x}
```


## Popularity contest

Sixty-two thousand four hundred repetitions make one truth. Given a string `x`, identify the character which occurs most frequently. If more than one character occurs the same number of times, you may choose arbitrarily. Is it harder to find all such characters?

```q
q)f "abdbbac"
"b"
q)f "CCCBBBAA"
"C"
q)f "CCCBBBBAA"
"B"
```

---

Answers:
```q
{first key desc count each group x}
```

## esreveR a ecnetnes

Little-endian encoding is such a brilliant idea I want to try applying it to English. Given a string `x` consisting of words (one or more non-space characters) which are separated by spaces, reverse the order of the characters in each word.

```q
q)f "a few words in a sentence"
"a wef sdrow ni a ecnetnes"
q)f "zoop"
"pooz"
q)f "one two three four"
"eno owt eerht ruof"
```

---

Answers:
```q
{" "sv reverse each " "vs x}
```


## Compression session

Let’s cut some text down to size. Given a string `x` and a boolean vector `y` of the same length, extract the characters of `x` corresponding to a 1 in `y`.

```q
q)f["foobar";100101b]
"fbr"
q)f["embiggener";0011110011b]
"bigger"
```

---

Answers:
```q
{x where y}
```


## Expansion mansion

Wait, strike that – reverse it. Given a string `x` and a boolean vector `y`, spread the characters of `x` to the positions of 1s in `y`, filling intervening characters with underscores.

```q
q)f["fbr";100101b]
"f__b_r"
q)f["bigger";0011110011b]
"__bigg__er"
```

---

Answers:
```q
{("_",x)y*sums y}
{"_"^x -1+y*sums y}
```


## C_ns_n_nts

Vowels make prose far too… pronounceable. Given a string `x`, replace all the vowels (a, e, i, o, u, or y) with underscores.

```q
q)f "FLAPJACKS"
"FL_PJ_CKS"
q)f "Several normal words"
"S_v_r_l n_rm_l w_rds"
```

---

Answers:
```q
V:"AEIOUYaeiouy"            / vowels
{?[x in V;"_";x]}           / Vector Conditional; in
{@[x;where x in V;:;"_"]}   / Amend At; in
{$["j";x in V]'[x;"_"]}     / Case
{(x;"_")x in V} each        / index
{@[x;;:;"_"]where 12>V?x}   / Amend At; Find
ssr/[;V;"_"]                / ssr
```


## Cnsnnts rdx

On second thought, I’ve deemed vowels too vile for placeholders. Given a string `x`, remove all the vowels entirely.

```q
q)f "Several normal words"
"Svrl nrml wrds"
q)f "FLAPJACKS"
"FLPJCKS"
```

---

Answers:
```q
except[;V]
```


## Title redacted

Given a string `x` consisting of words separated by spaces (as above), and a string `y`, replace all words in `x` which are the same as `y` with a series of `x`s.

```q
q)f["a few words in a sentence";"words"]
"a few XXXXX in a sentence"
q)f["one fish two fish";"fish"]
"one XXXX two XXXX"
q)f["I don't give a care";"care"]
"I don't give a XXXX"
```

---

Answers:
```q
{ssr[x;y;count[y]#"X"]}
```


## It’s more fun to permute

My ingenious histogram-based filing system has a tiny flaw: some people insist that the order of letters in their names is significant, and now I need to re-file everything. Given a string `x`, generate a list of all possible re-orderings of the characters in `x`. Can you do this non-recursively?

```q
q)f "xyz"
"xyz"
"xzy"
"yzx"
"yxz"
"zxy"
"zyx"
```

---

Answers:
```q
{x {flip[y]where x=sum y}[s;] s vs til"j"$s xexp s:count x}
{(1 0#x) {raze({raze reverse 0 1 _ x}\)each x,'y}/ x} / (AR)
```

See Examples from Python: [Permute a string](https://code.kx.com/q/learn/python/examples/string#permute-a-string) for a recursive method


## Trimming locals

We have used up nearly our entire monthly allowance of parens and local variables. And mislaid the `trim` keyword. Until we can locate it, we need a substitute that uses no parens, defines no local variables, and of course – tests only once for spaces.

```q
q)f "   abc def  "
"abc def"
```

---

Answers:
```q
{{y _ x}/[x;] 1 -1*?'[;0b]1 reverse\null x}
```
The [Do](https://code.kx.com/q/ref/accumulators#do) iterator form `1 f\x` applies `f` to `x` 0 and 1 times.


*How many Zen monks does it take to change a lightbulb?*

**Two**. One to change it and one not to change it.

Note how `{y f x}/` applies `f` to successive _left_ arguments. (`{y f x}` is sometimes said to _commute_ `f`.)

```q
{(neg reverse[a]?0b)_(?[;0b]a:" "=x)_x}
```


##  Contributors

* Ajay Rathore
* Attila Vrabecz
* David Lu
* Stephen Taylor
