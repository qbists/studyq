/https://projecteuler.net/problem=4
/A palindromic number reads the same both ways. 
/The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
/Find the largest palindrome made from the product of two 3-digit numbers.

c:prd each distinct asc each {x cross x} 1 _ til 1000  / candidate products
ip:{x~reverse x}                                       / is palindrome?

/ solutions
max c where ip each string c
i:count C:asc c; while[not ip string C i-:1;]; C i
/.[@]({not{x~reverse x}string x@y}.) @[;1;-1+]/(asc c;count[c]-1)
lastitem:{[test;list].[@] ({x y z}[test].) @[;1;-1+]/ (list;-1+count list)}
lastitem[not ip string@] asc c

