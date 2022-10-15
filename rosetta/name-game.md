# The Name Game

[![Shirley Ellis and the Name Game](img/name-game.png)](https://youtu.be/5MJLi5_dyn0 "YouTube")
<br>
[Shirley Ellis The Name Game](https://youtu.be/5MJLi5_dyn0)

## Summary

*Make substitutions in a string or list of strings*

Two solutions, using respectively, **`ssr`** and **Amend At**.
Both use **projections**.

Both use the **Do iterator** to both apply and not-apply a function.
One uses the **Over iterator** to consolidate successive operations.

Both solutions have five code lines, no loops, no control structures.

## Question 

*Write a function that takes a name and returns the lyrics to the Shirley Ellis song ”The Name Game”.*

from [Rosetta Code](http://rosettacode.org/wiki/The_Name_Game)

We shall try two approaches to this problem and see how they compare.
First, string search and replacement. 
In the second we treat the songs as a list of strings and use Amend At to customize it. 


## String search and replace

The core of this is pretty simple.
Perhaps no more than inserting a name into a template.

```q
q)s:"Name, Name, bo-bName\nBanana-fana-fo-fName\nFee-fimo-mName\nName!\n\n"
q)1 ssr[s;"Name";]"Stephen";
Stephen, Stephen, bo-bStephen
Banana-fana-fo-fStephen
Fee-fimo-mStephen
Stephen!
```

Not quite: have to drop the first letter of the name. Unless it’s a vowel.
In fact, all the leading consonants. Is Y a vowel – _Yvette, Yvonne_? Let’s suppose so.

```q
q)V:raze 1 upper\"aeiouy"  / vowels
q)s2:"$1, $1, bo-b$2\nBanana-fana-fo-f$2\nFee-fimo-m$2\n$1!\n\n"
q)1 {ssr/[s2;("$1";"$2");(x;((x in V)?1b)_x)]}"Stephen";
Stephen, Stephen, bo-bephen
Banana-fana-fo-fephen
Fee-fimo-mephen
Stephen!
```

**Tip** `"$1"` and `"$2"` have no special significance here. Although they resemble tokens in Posix regular expression syntax, here they are just substrings that are easy to spot.

Note the use of [Do](https://code.kx.com/q/ref/accumulators#do) `\` to get the upper- and lower-case vowels.

Here we have used the [Over iterator](https://code.kx.com/q/ref/accumulators#ternary-values) to make _successive_ substititions. 
Breaking that down, it is equivalent to

```q
q)1 ssr[;"$2";"ephen"] ssr[;"$1";"Stephen"] s2;
Stephen, Stephen, bo-bephen
Banana-fana-fo-fephen
Fee-fimo-mephen
Stephen!
```

And with a leading vowel?

```q
q)1 {ssr/[s2;("$1";"$2");(x;((x in V)?1b)_x)]}"Anne";
Anne, Anne, bo-bAnne
Banana-fana-fo-fAnne
Fee-fimo-mAnne
Anne!
```

That A should be in lower case.

```q
q)1 {ssr/[s2;("$1";"$2");(x;lower((x in V)?1b)_x)]}"Anne";
Anne, Anne, bo-banne
Banana-fana-fo-fanne
Fee-fimo-manne
Anne!
```

But we have one more rule still to go.
When the name begins with B, F, or M, the corresponding _bo-b_, _fo-f_, and _mo-m_ loses its last letter. 
We could treat this as a possible third string replacement.

Lightbulb moment. We do not need to test the first letter to see if the third replacement is needed. If it is not, the replacement, e.g. _so-s_ with _so-_, is harmless: a no-op.

If we define the third substition

```q
s3:{1(-1_)\x,"o-",x}lower first Name
```

then our result is 

```q
ssr[;"$2";tn] ssr[;"$1";Name] ssr[s;;] . s3 
```

The replacements are all made in the last line:

-    _xo-_ for _xo-x_ for some letter _x_
-    `Name` for `"$1"`
-    `tn` for `"$2"`

Should the successive calls to `ssr` be refactored with [Over](https://code.kx.com/q/ref/accumulators#ternary-values)?

They could be. The syntax would be `ssr/[s;f;t]`, where `f` and `t` are the lists of from- and to-strings.
But rather than construct those variables, let’s apply `ssr/` to a 3-list of arguments. The syntax for that would be `(ssr/).(s;f;t)`.

```q
game_ssr:{[Name]
  V:raze 1 lower\"AEIOUY";                                        / vowels
  tn:lower((Name in V)?1b) _ Name;                                / truncated Name
  s3:{1(-1_)\x,"o-",x}lower first Name;                           / 3rd ssr
  s:"$1, $1, bo-b$2\nBanana-fana-fo-f$2\nFee-fimo-m$2\n$1!\n\n";
  (ssr/).(s;("$1";"$2";s3 0);(Name;tn;s3 1)) }
```

```q
q)1 raze game_ssr each string`Stephen`Anne`Yvonne`Brenda;
Stephen, Stephen, bo-bephen
Banana-fana-fo-fephen
Fee-fimo-mephen
Stephen!

Anne, Anne, bo-banne
Banana-fana-fo-fanne
Fee-fimo-manne
Anne!

Yvonne, Yvonne, bo-byvonne
Banana-fana-fo-fyvonne
Fee-fimo-myvonne
Yvonne!

Brenda, Brenda, bo-enda
Banana-fana-fo-fenda
Fee-fimo-menda
Brenda!
```


## Amending a list of strings

In this approach we treat the song as a list of strings and amend a template list.
The template list:

```q
q)show s:("bo-b";"Banana-fana fo-f";"Fee-fimo-m";"!";"")
"bo-b"
"Banana-fana fo-f"
"Fee-fimo-m"
"!"
""
```

Prefix lines 0 and 3 with the name.

```q
pfx:Name,", ",Name,", " / prefix
```

Suffix each of the first three lines with the truncated name.

```q
n:lower Name
v:"aeiouy"
sfx:((n in v)?1b)_ n / suffix
```

but first drop the last letter from lines of `s`

```q
where n[0]=last each s
```

The ternary form of [Amend At](https://code.kx.com/q/ref/amend) (syntax `@[x;yz]`) applies (unary) `z` to to each item of `x y`. 
So

```q
@[s;where n[0]=last each s;-1_]
```

does that.
Successive substitutions:

```q
@[;0;pfx,] @[;3;Name,] @[;0 1 2;,[;sfx]] @[;where n[0]=last each s;-1_] s 
```

We could use the [Over iterator](https://code.kx.com/q/ref/accumulators#ternary-values) to refactor the successive calls to Amend At as a call to `@/`.
The refactored syntax would be `@/[s;i;u]` where `i` is a nested list of indexes and `u` is a list of unaries.

```q
@/[; ((0;3;0 1 2;where n[0]=last each s)); (pfx,;Name,;,[;sfx];-1_)] s 
```

A step too far. 

The syntax of the successive applications keeps the index-unaries as pairs.
In the refactored line no improvement in legibility warrants the extra cognitive load of pairing unaries and indexes.
Absent some other decisive factor such as evaluation time, the earlier version is better here.

But it is good to to be able to spot opportunities to refactor!

Putting it all together:

```q
game_amend:{[Name]
  pfx:Name,", ",Name,", ";                                    / prefix
  n:lower Name;
  sfx:((n in "aeiouy")?1b)_n;                                 / suffix
  s:("bo-b";"Banana-fana fo-f";"Fee-fimo-m";"!";"");          / song template
  @[;0;pfx,] @[;3;Name,] @[;0 1 2;,[;sfx]] @[;where n[0]=last each s;-1_] s }
```

Test your understanding:
`@[;0 1 2;,[;sfx]]` uses the ternary form of Amend At.
Rewrite it using the quaternary form.

**Answer**

```q
@[;0 1 2;,;3#enlist sfx]
```

In the ternary form `@[x;y;z]`, `x[y]` becomes `z each x[y]`.

In the quaternary form `@[x;y;z;zz]`, `x[y]` becomes `x[y] z'zz`.

Bracket notation for derived functions may help here.
Equivalent to the above, `x[y]` becomes

    ternary      @[x;y;z]         z'[x y]
    quaternary   @[x;y;z;zz]      z'[x y;zz]

In this case, `s[0 1 2]` becomes in the ternary `,[;sfx]each s[0 1 2]` and in the quaternary `s[0 1 2],'3#enlist sfx`.


## Review

Both approaches found solutions of similar length and legibility. 

Both used projections. Both culminated in a last line that successively applied similar operations, respectively `ssr` and Amend At.

Using the Do iterator to refactor the last line of `game_ssr` improved legibility; refactoring the last line of `game_amend` did not.
