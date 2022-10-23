/https://projecteuler.net/problem=3
/The prime factors of 13195 are 5, 7, 13 and 29.
/What is the largest prime factor of the number 600851475143 ?

/N:13195
N:600851475143

/candidates: primes to √N
kc:{(1#2;0b,1_x#10b)}                                                       / known primes; flag candidates
snp:{(x,n;y&count[y]#i<>til n:1+i:y?1b)}.                                   / sieve next prime
es:raze@[;1;1+where@] {{x>last first y}[floor sqrt x] snp/kc x}@            / Eratosthenes' sieve
c:es floor sqrt N                                                           / primes to √N

last c where not N mod c                                      				/ overcompute: try all


\ 
i:count[c]-1; while[N mod c i-:1;]; c i
.[@] ({z and x mod y z}[N].) @[;1;-1+]/(c;count c)  / loop to find last
