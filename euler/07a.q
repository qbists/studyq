/https://projecteuler.net/problem=7
/ By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
/ What is the 10 001st prime number?
np1:{[n] 											  / nth prime
  es:{                                                /   Eratosthenes' Sieve
    kc:{(1#2;0b,1_x#10b)};                            /     (known primes; flag candidates)
    snp:{i:(n-1)+n*til count[y]div n:1+i:y?1b;(x,n;@[y;i;:;0b])}. ;       /     sieve next prime
    {x>last first y}[floor sqrt x] snp/kc x };
  rslv:raze @[;1;1+where@]::;                         /   resolve result
  pt:rslv es::;                                       /   primes to
  pi:{x%log x};                                       /   π(x) first approximation
  @[;n]pt (n>pi@)(2*)/1000 }

np0: {[N]                                          / Nth prime
  P: (N>{x%log x}::)(2*)/1000;                     /   Nth prime < P:π(x) first approx
  es: {                                            /   Eratosthenes' Sieve for primes <x
    kf:{(1#2;0b,1_x#10b)};                         /     (known primes; flag candidates)
    snp:{[x;k;f](k,p;f&x#i<>til p:1+i:f?1b)}[x].;  /     sieve next prime
    {x>last first y}[floor sqrt x] snp/kf x };     /     stop at √x
  @[;N] raze @[;1;1+where::] es P }


np2:{[n]                         / nth prime
  es:{                                                /   Eratosthenes' Sieve
    kc:{(1#2;0b,1_x#10b)};                            /     (known primes; flag candidates)
    snp:{(x,n;y&count[y]#i<>til n:1+i:y?1b)}. ;       /     sieve next prime
    {x>last first y}[floor sqrt x] snp/kc x };
  rslv:raze @[;1;1+where@]::;                         /   resolve result
  pt:rslv es::;                                       /   primes to
  pi:{x%log x};                                       /   π(x) first approximation
  @[;n]pt (n>pi@)(2*)/1000 }

/ Jonathan Kane
// Check if a number prime
.math.isPrime:{$[
  0<type x; .z.s each x;
  x<2; 0b; 
  x in p:2 3 5 7; 1b; 
  0 in x mod p; 0b; 
  all x mod raze -1 1+/:(ceiling[sqrt x]>)(6+)\ 6
  ]}

nprimes3:{@[;x-1]last(x>count last@){(x[0]+:1;x[1],n where .math.isPrime n:-1 1+6*x 0)}/(1;2 3)}

nprimes4:{[N]                                     / Nth prime
  is:("i"$1,count::;.math.isPrime;::)@\:2 3;      /   initial state: k:1; 2 3 found
  step:{[x;y;z] 
    b:.math.isPrime n:-1 1+6*first x;             /     test 2 candidates
    (x+1,sum b;b;n)                               /     new state 
  }.;
  fs:{x>y . 0 1}[N;] step/is;                     /   final state
  {[n;kc;b;p] (p where b)@(kc 1)-n}[N;;;] . fs }

/ nprimes4:{
/   {[n;kc;b;p] p where b) (kc 1)-n}[x;;;] . 
/     {x>y . 0 1}[x;] 
/       ({[x;y;z] b:.math.isPrime n:-1 1+6*first x; (x+1,sum"j"$b;b;n) }.)/ (1 2;11b;2 3)
/   }

\
q)\ts nprimes3 10001
365 262784
q)\ts nprimes4 10001
349 5088