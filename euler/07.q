/https://projecteuler.net/problem=7
/By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
/ What is the 10 001st prime number?

kc:{(1#2;0b,1_x#10b)}                                             / (known primes; flag candidates)
snp:{(x,n;y&count[y]#i<>til n:1+i:y?1b)}.                         / sieve next prime
es:raze@[;1;1+where@] {{x>last first y}[floor sqrt x] snp/kc x}@  / Eratosthenes' sieve
c:es 1000000                                                      / primes < 1 000 000
c@10000
