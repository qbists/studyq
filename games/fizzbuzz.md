# Fizz buzz


[![Fizz buzz](img/fizzbuzz.png)](https://www.ezrahill.co.uk/2019/04/14/the-fizzbuzz-question/ "Image by Ezra Hill")

> Fizz buzz is a group word game for children to teach them about division. Players take turns to count incrementally, replacing any number divisible by three with the word _fizz_, and any number divisible by five with the word _buzz_. — [_Wikipedia_](https://en.wikipedia.org/wiki/Fizz_buzz)


Fizz buzz is fun for programmers as well as children, and has been implemented in a [host of languages](https://rosettacode.org/wiki/FizzBuzz). 
Here is a simple solution in Python for the first hundred numbers.

```python
for i in range(1, 101):
    if i%3 == 0 and i%5 == 0:
        my_list.append("fizzbuzz")
    elif i%3 == 0:
        my_list.append("fizz")
    elif i%5 == 0:
        my_list.append("buzz")
    else:
        my_list.append(i)
```

Since it constructs its results as an array, it could claim to be an array solution. But it employs a for-loop and an if/then/else construct. 
We can usually dispense with them in q.

Start with a vector of numbers.

```q
q)show x:1+til 20
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
```

We are interested in whether they are divisible by 3 and 5. 
Those divisible by 3 have 0 as the result of `x mod 3`. Similarly by 5. Test both.

```q
q)0=x mod/:3 5
00100100100100100100b
00001000010000100001b
```

But we need four results, not two: divisible by neither; by 3; by 5; and by both.

```q
q)1 2*0=x mod/:3 5
0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0
0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2
q)sum 1 2*0=x mod/:3 5
0 0 1 0 2 1 0 0 1 2 0 1 0 0 3 0 0 1 0 2
```

The items of `x` are mapped to `0 1 2 3`.

Let’s construct our result as a symbol vector.

```q
q)`$string x
`1`2`3`4`5`6`7`8`9`10`11`12`13`14`15`16`17`18`19`20
q)(`$string x;20#`fizz;20#`buzz;20#`fizzbuzz)
1        2        3        4        5        6        7        8        9    ..
fizz     fizz     fizz     fizz     fizz     fizz     fizz     fizz     fizz ..
buzz     buzz     buzz     buzz     buzz     buzz     buzz     buzz     buzz ..
fizzbuzz fizzbuzz fizzbuzz fizzbuzz fizzbuzz fizzbuzz fizzbuzz fizzbuzz fizzb..
```

We just need a way to use `0 1 2 3` to pick from these four vectors.
Enter the [Case](https://code.kx.com/ref/maps#case) iterator.

```q
q)(sum 1 2*0=x mod/:3 5)'[`$string x;20#`fizz;20#`buzz;20#`fizzbuzz]
`1`2`fizz`4`buzz`fizz`7`8`fizz`buzz`11`fizz`13`14`fizzbuzz`16`17`fizz`19`buzz
```

Scalar extension means we can use atoms as the last three arguments.

```q
q)(sum 1 2*0=x mod/:3 5)'[`$string x;`fizz;`buzz;`fizzbuzz]
`1`2`fizz`4`buzz`fizz`7`8`fizz`buzz`11`fizz`13`14`fizzbuzz`16`17`fizz`19`buzz
```

This is a good example of ‘array thinking’.

> — What is the problem? I can write for-loops in my sleep.
> <br>
> — _We want you to wake up._

Notice how much of the expression simply states the problem.

``[`$string x;`fizz;`buzz;`fizzbuzz]`` lists the four possible result options.

`0=x mod/:3 5` tests for divisibility by 3 and 5.

`(sum 1 2* .. )'[ .. ]` relates the test results to the final results. This is the only ‘programmery’ bit. The other two parts correspond directly to the posed problem. 

In this way the solution exhibits high _semantic density_: most terms in the code correspond to terms in the problem domain. 

---

On semantic density:

* [“Three Principles of Code Clarity”](http://archive.vector.org.uk/art10009750 "Vector, the journal of the British APL Association"), _Vector_ 18:4
* [“Pair programming With The Users](http://archive.vector.org.uk/art10009900 "Vector, the journal of the British APL Association"), _Vector_ 22:1

