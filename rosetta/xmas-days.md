# The Twelve Days of Christmas


![Carol singers](img/CN6580.jpg)

## Summary 

*Map a simple data structure to a complex one*

**Nested indexes** describe the structure of the result, produced by a single (elided) use of **Index At**.

**Amend** and **Amend At** let us change items at depth in the result structure.

Two code lines: no loops, no counters, no control structures.


## Question 

*Write a program that prints the [lyrics](http://www.lyricsmode.com/lyrics/c/christmas_carols/the_twelve_days_of_christmas.html "lyricsmode.com") of the Christmas carol “The Twelve Days of Christmas”*

from [Rosetta Code](http://rosettacode.org/wiki/The_Twelve_Days_of_Christmas) 


## Follow a python

Rosetta Code offers a [Python solution](http://rosettacode.org/wiki/The_Twelve_Days_of_Christmas#Python "rosettacode.org").

```python
gifts = '''\
A partridge in a pear tree.
Two turtle doves
Three french hens
Four calling birds
Five golden rings
Six geese a-laying
Seven swans a-swimming
Eight maids a-milking
Nine ladies dancing
Ten lords a-leaping
Eleven pipers piping
Twelve drummers drumming'''.split('\n')
 
days = '''first second third fourth fifth
          sixth seventh eighth ninth tenth
          eleventh twelfth'''.split()
 
for n, day in enumerate(days, 1):
    g = gifts[:n][::-1]
    print(('\nOn the %s day of Christmas\nMy true love gave to me:\n' % day) +
          '\n'.join(g[:-1]) +
          (' and\n' + g[-1] if n > 1 else g[-1].capitalize()))
```

Seems pretty straightforward. 
We could translate it into q.

```q
gifts:(
  "A partridge in a pear tree.";
  "Two turtle doves";
  "Three french hens";
  "Four calling birds";
  "Five golden rings";
  "Six geese a-laying";
  "Seven swans a-swimming";
  "Eight maids a-milking";
  "Nine ladies dancing";
  "Ten lords a-leaping";
  "Eleven pipers piping";
  "Twelve drummers drumming")

days:" "vs"first second third fourth fifth sixth",
  " seventh eighth ninth tenth eleventh twelfth"
```

Now we need a function that returns verse `x`, which we can iterate through `til 12`.

Unlike the Python code, we shall generate the whole carol as a list of strings.

First line:

```q
q){ssr["On the %s day of Christmas";"%s";]days x}3
"On the fourth day of Christmas"
```

First two lines:

```q
q){(ssr["On the %s day of Christmas";"%s";days x];"My true love gave to me")}3
"On the fourth day of Christmas"
"My true love gave to me"
```

But we do not need the power of `ssr`. We can just join strings.

```q
q){("On the ",(days x)," day of Christmas";"My true love gave to me")}3
"On the fourth day of Christmas"
"My true love gave to me"
```

And some gifts.

```q
q){("On the ",(days x)," day of Christmas";"My true love gave to me"),(x+1)#gifts}3
"On the fourth day of Christmas"
"My true love gave to me"
"A partridge in a pear tree."
"Two turtle doves"
"Three french hens"
"Four calling birds"
```

But not in that order.

```q
q){("On the ",(days x)," day of Christmas";"My true love gave to me"),reverse(x+1)#gifts}3
"On the fourth day of Christmas"
"My true love gave to me"
"Four calling birds"
"Three french hens"
"Two turtle doves"
"A partridge in a pear tree."
```

Almost. Except on the first day, the last line begins _And a partridge_.
We can deal with this. A little conditional execution.


### Conditional execution

Here is the first line expressed as the result of a [Cond](https://code.kx.com/q/ref/cond).

```q
$[x;"And a partridge in a pear tree";"A partridge in a pear tree"]
```

We do not need to compare `x` to zero. If it is zero, we get the second version of the line. But we already have the short version of the line. 
We want to amend it.

```q
$[x;"And a";"A"],1_"A partridge in a pear tree"
```

The second part of the conditional above is a no-op. 
Better perhaps to say we _may_ want to amend the line.
With a function that drops the first char and prepends `"And a"`:

```q
"And a", _[1;] @   / a composition
```

We could use the [Do iterator](https://code.kx.com/q/ref/accumulators#do) to apply it – zero or one times.

```q
q)1("And a", _[1] @)\"A partridge"
"A partridge"
"And a partridge"
```

Now we do have to compare `x` to 0. And cast the result to long.

```q
("j"$x=0)("And a", _[1;] @)/"A partridge"
```

Nothing here seems quite satisfactory. We shall revisit it. 
For now we shall prefer the slightly shorter and syntactically simpler Cond.


### Apply At

We want to make the changes above, conditionally, to the last gift of the day. 
Happily, until we reverse the list, that is the first gift: index is 0.

```q
q){("On the ",(days x)," day of Christmas";"My true love gave to me"), 
    reverse @[;0;{y,1_x};$[x;"And a";"A"]](x+1)#gifts}0
"On the first day of Christmas"
"My true love gave to me"
"A partridge in a pear tree."
```

Here we have used the quaternary form of [Amend At](https://code.kx.com/q/ref/amend).
The Reference gives its syntax as 
```q
@[d; i; v; vy]
```
Let’s break ours down accordingly. 

```q
@[; 0; {y,1_x}; $[x;"And a";"A"]]
```

`d`

: The `d` argument is missing. It is the only argument missing, so we have a unary projection of Amend At. That makes the value of `d` the expression to its right: `(x+1)#gifts`. The list of gifts, partridge first.

`i`

: 0: we are amending the first item in the list. The partridge line.

`v`

: This is the function to be applied to the partridge line. We are using the quaternary form of Amend At, so `v` is a binary. The partridge line is its `x` argument. Our `v` is `{y,1_x}`. It will drop the first character of the partridge line and prepend the value of the fourth argument.

`vy`

: This the right argument of `v`: a choice between `"And a"` and `"A"`. 

We need a blank line at the end of each verse.

```q
q){("On the ",(days x)," day of Christmas";"My true love gave to me"), reverse(enlist""),@[;0;{y,1_x};$[x;"And a";"A"]](x+1)#gifts}0
```

Put this into the script.

```q
day:{("On the ",(days x)," day of Christmas";"My true love gave to me"), 
  reverse(enlist""),@[;0;{y,1_x};$[x;"And a";"A"]](x+1)#gifts}
```

And run it.

```q
q)1 "\n"sv raze day each til 12;
On the first day of Christmas
My true love gave to me
A partridge in a pear tree.

On the second day of Christmas
My true love gave to me
Two turtle doves
And a partridge in a pear tree.

..

On the twelfth day of Christmas
My true love gave to me
Twelve drummers drumming
Eleven pipers piping
Ten lords a-leaping
Nine ladies dancing
Eight maids a-milking
Seven swans a-swimming
Six geese a-laying
Five golden rings
Four calling birds
Three french hens
Two turtle doves
And a partridge in a pear tree.
```


## Q eye for the scalar guy

Our translation of the Python solution worked, but we can do better. 
Start from scratch.

Leave aside for now how the day changes at the beginning of each verse. 
Set aside also the `"And a"` on the first verse, and notice that only that verse varies this way. 

Suppose we construct each verse as a subset of the final stanza? 

```q
stanza:(
  "On the twelfth day of Christmas";
  "My true love gave to me:";
  "Twelve drummers drumming";
  "Eleven pipers piping";
  "Ten lords a-leaping";
  "Nine ladies dancing";
  "Eight maids a-milking";
  "Seven swans a-swimming";
  "Six geese a-laying";
  "Five golden rings";
  "Four calling birds";
  "Three french hens";
  "Two turtle doves";
  "And a partridge in a pear tree.";
  "")
```


### Nested indexes

Fifteen lines. For verse `x` we want the first two and the last `x+2`. 

```q
q)0 1,/:{(reverse x)+2+til each 2+x}til 12 / line numbers
0 1 13 14
0 1 12 13 14
0 1 11 12 13 14
0 1 10 11 12 13 14
0 1 9 10 11 12 13 14
0 1 8 9 10 11 12 13 14
0 1 7 8 9 10 11 12 13 14
0 1 6 7 8 9 10 11 12 13 14
0 1 5 6 7 8 9 10 11 12 13 14
0 1 4 5 6 7 8 9 10 11 12 13 14
0 1 3 4 5 6 7 8 9 10 11 12 13 14
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
```

Indexing is atomic. Index `stanza` using [Index At](https://code.kx.com/q/ref/apply#index-at).

```q
q)show verses:stanza @ 0 1,/:{(reverse x)+2+til each 2+x}til 12
("On the twelfth day of Christmas";"My true love gave to me:";"And a partridg..
("On the twelfth day of Christmas";"My true love gave to me:";"Two turtle dov..
("On the twelfth day of Christmas";"My true love gave to me:";"Three french h..
("On the twelfth day of Christmas";"My true love gave to me:";"Four calling b..
("On the twelfth day of Christmas";"My true love gave to me:";"Five golden ri..
("On the twelfth day of Christmas";"My true love gave to me:";"Six geese a-la..
("On the twelfth day of Christmas";"My true love gave to me:";"Seven swans a-..
("On the twelfth day of Christmas";"My true love gave to me:";"Eight maids a-..
("On the twelfth day of Christmas";"My true love gave to me:";"Nine ladies da..
("On the twelfth day of Christmas";"My true love gave to me:";"Ten lords a-le..
("On the twelfth day of Christmas";"My true love gave to me:";"Eleven pipers ..
("On the twelfth day of Christmas";"My true love gave to me:";"Twelve drummer..
```

A list. Each item is a list of strings. Nice. 

Postfix syntax lets us elide Index At:

```q
q)lines:0 1,/:{(reverse x)+2+til each 2+x}til 12
q)(stanza lines) ~ stanza@lines
1b
```

Thus

```q
verses:stanza 0 1,/:{(reverse x)+2+til each 2+x}til 12
```

### Amend At Each

Now for those first lines. Iterate a function that, in the first line, replaces `"twelfth"` with the corresponding item of `days`:

It uses the ternary form of [Amend At](https://code.kx.com/q/ref/amend) to apply a unary function to the first line of the verse. That unary is `ssr[;"twelfth";y]` a projection of ternary `ssr` onto `"twelfth"` and the item from `days`.

```q
q)verses{@[x;0;ssr[;"twelfth";y]]}'days
("On the first day of Christmas";"My true love gave to me:";"And a partridge ..
("On the second day of Christmas";"My true love gave to me:";"Two turtle dove..
("On the third day of Christmas";"My true love gave to me:";"Three french hen..
("On the fourth day of Christmas";"My true love gave to me:";"Four calling bi..
("On the fifth day of Christmas";"My true love gave to me:";"Five golden ring..
("On the sixth day of Christmas";"My true love gave to me:";"Six geese a-layi..
("On the seventh day of Christmas";"My true love gave to me:";"Seven swans a-..
("On the eighth day of Christmas";"My true love gave to me:";"Eight maids a-m..
("On the ninth day of Christmas";"My true love gave to me:";"Nine ladies danc..
("On the tenth day of Christmas";"My true love gave to me:";"Ten lords a-leap..
("On the eleventh day of Christmas";"My true love gave to me:";"Eleven pipers..
("On the twelfth day of Christmas";"My true love gave to me:";"Twelve drummer..
```


### Amend in depth

We can fix verse 0, line 2.

```q
q)first .[;0 2;{"And",5_x}]verses{@[x;0;ssr[;"twelfth";y]]}'days
"On the first day of Christmas"
"My true love gave to me:"
"A partridge in a pear tree."
""
```

Here we use the ternary form of [Amend](https://code.kx.com/q/ref/amend) to apply a unary function to line 2 of verse 0. The function we apply is a lambda: `{"And",5_x}`.


### Raze and print

Raze to a list of strings and print.

```q
q)verses:stanza 0 1,/:{(reverse x)+2+til each 2+x}til 12
q)lyric:raze .[;0 2;{"A",5_x}] verses{@[x;0;ssr[;"twelfth";y]]}'days

q)1"\n"sv lyric;
On the first day of Christmas
My true love gave to me:
A partridge in a pear tree.

On the second day of Christmas
My true love gave to me:
Two turtle doves
And a partridge in a pear tree.

..

On the twelfth day of Christmas
My true love gave to me:
Twelve drummers drumming
Eleven pipers piping
Ten lords a-leaping
Nine ladies dancing
Eight maids a-milking
Seven swans a-swimming
Six geese a-laying
Five golden rings
Four calling birds
Three french hens
Two turtle doves
And a partridge in a pear tree.
```


### Test your understanding

**Question** Using string-search-and-replace to change the days looks like a sledgehammer to crack a nut. Can you find an alternative?

**Answer** Replace the unary projection `ssr[;"twelfth";y]` with `{(7#x),y,14_x}[;y]`. 
Notice how projecting `{(7#x),y,14_x}` onto `[;y]` maps the `y` of the outer lambda to the `y` of the inner lambda.

**Question** If you `raze` the verses before fixing the last line of the first verse, how else must you change the definition of `lyric`?

**Answer**

```q
lyric:@[;2;{"A",5_x}]raze(stanza lines){@[x;0;ssr[;"twelfth";y]]}'days
```

You are now no longer amending at depth but amending an entire item.
So you use Amend At rather than Amend.

**Question** Write an expression to generate all the first lines.

**Answer**

```q
{"On the ",x," day of Christmas"}each days
```

Less obviously you can use an elision for the substitution. 
(Elision with one item missing is a unary projection of [`enlist`](https://code.kx.com/q/ref/enlist).)

```q
q)("On the ";;" day of Christmas")"first"
"On the "
"first"
" day of Christmas"
q)raze("On the ";;" day of Christmas")"first"
"On the first day of Christmas"
```

For the whole list that gives 

```q
raze each("On the ";;" day of Christmas")each days
```

Remembering that with unary functions `f each g each` can be composed as `(f g@)each` gets us

```q
(raze("On the ";;" day of Christmas")@)each days
```

which is interesting, but the lambda is preferable as syntactically simpler.


## Review

We got a lot from seeing each verse as a subset of `stanza`. We avoided lots of explicit iteration by generating a nested list of indexes, and indexing `stanza` with it. Indexing is atomic, and returned us a nested list of strings, each item a verse. We used an Each Right and one `each` to generate the indexes; otherwise iteration was free.

**Tip** Iteration is free. Not actually, of course. But the iteration implicit in the primitives generally evaluates faster than any iteration you specify explicitly. And it is certainly free in terms of code volume.

The structure was put together from integer indexes: lighter work than pushing strings around. 

We used one more Each to pair off days and verses and amend the first lines. After that we needed only fix the last line of the first verse and remove a level of nesting.

Great example of what you can get done with nested indexes. 


