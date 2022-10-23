/https://projecteuler.net/problem=5
/ 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
/What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

{any 0<x mod y}[;1+til 10] (1+)/10                         / try everything
{any 0<x mod y}[;1+til 10] (q+)/q:prd 2 3 5 7              / try only multiples of primes to 10
{any 0<x mod y}[;1+til 20] (q+)/q:prd 2 3 5 7 11 13 17 19  / try only multiples of primes to 20