![Maintenance](https://img.shields.io/maintenance/yes/2023?style=for-the-badge)

Study Q
=======

*Tutorials, puzzles, exercises, essays and other study resources for the q programming language*

Most users of q encounter it as a means of querying large kdb+ datasets. 
But it is also a general-purpose programming language (PL) of great power and expressiveness, 
and a direct descendant of both APL and Lisp, 
early PLs that stamped their influence on the many languages that followed them.

If you find the verbosity of ‘high ceremony’ languages comforting, you will not like q.
But if you like coding at a high level of abstraction and also in **sympathy with the metal**
(q’s Unique Selling Point is its speed) you may find its terse expressions utterly addictive. 

Long experience with ‘scalar’ languages train the brain to break problems into loops.
Most q operators iterate *implicitly*
```q
q)1 2 3 + 4
5 6 7
```
so novice q programmers (qbies) have a certain amount of *unlearning* to do. 
You may experience this as a cognitive *decluttering* that frees you up to focus on algorithms and strategies.


Gods and mortals
----------------
Prior experience with its ancestor languages APL, k, and Lisp made q a familiar environment 
for many of its early adopters. Their need for training was minimal, 
and documentation little more than a memory aid.

Marvelling at bafflingly terse q solutions, qbies dubbed early adopters “the q gods”.
The expression honours their skill – but also places it out of reach. 
With grim humour, a popular textbook for the language took the title 
[*Q for Mortals*](https://code.kx.com/q4m3)
– how the rest of us can scrape by when using the language of the gods:
a traveller’s phrasebook for Coding Heaven. 

This repository is a [Promethean](https://en.wikipedia.org/wiki/Prometheus "Wikipedia") project.
Like any other language, q yields to study and practice. 
It is not reserved to a race of divine creatures.

Go for it.


Vector thinking
---------------
The q language was designed to make the power of kdb+ more accessible to new users. 
With a little study, a new q user with prior experience of SQL can quickly start working productively.

But the real power of kdb+, and its **machine sympathy** comes with thinking and writing in vectors. How to learn this?

Because of q’s origins in financial markets, most production q code is hidden by corporate networks and non-disclosure agreements.
Outside these exclusive environments it can be hard to learn from experienced qbists.

The code exhibited here offers valuable insight into how qbists work. 

It rewards study. 


Contribute
----------
Much content here first appeared at code.kx.com/learn.
It is reproduced in the hope that experienced qbists will extend it.

You are welcome to post solution code (e.g. to Project Euler problems) without comment or explanation, but we strongly prefer discussion, particularly exploration of alternatives. 
