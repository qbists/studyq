/https://projecteuler.net/problem=4
/A palindromic number reads the same both ways. 
/The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
/Find the largest palindrome made from the product of two 3-digit numbers.

c:prd each distinct asc each {x cross x} 1 _ til 1000  / candidate products
ip:{x~reverse x}                                       / is palindrome?

/ Solution 1
max c where ip each string c
i:count C:asc c; while[not ip string C i-:1;]; C i
/.[@]({not{x~reverse x}string x@y}.) @[;1;-1+]/(asc c;count[c]-1)
lastitem:{[test;list].[@] ({x y z}[test].) @[;1;-1+]/ (list;-1+count list)}
lastitem[not ip string@] asc c


/ Solution 2
sol2:{
    // Create all palindromes in reverse order
    digits:reverse string til 10;
    palindromes:{[x;y;z]raze x,/:'y,\:/:x}[digits]/[;til x-1];
    pals:"J"$palindromes 2#/:digits;

    // create all  x-digit numbers
    nums:reverse r[1]+til(-/)r:`long$10 xexp 0 -1+x;
    
    // Recursively check each palindrome, early exit if found
    {[pals;nums]
        p:first pals;
        b:and[first[nums]>n]not mod[;1]n:p%nums mod[p;nums]?0;
        $[b;p;.z.s[1_pals;nums]]
    }[pals;nums]
 }
