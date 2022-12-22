/https://adventofcode.com/2022/day/4

inp: read0`:input/04.txt  /assignments
test: read0`:test/04.txt  /assignments

// András Dőtsch	
i:("jj";"-")0:/:("**";",")0: inp
sum {0>=.[*]x-y} . i
sum {0>=.[*]x-reverse y} . i

// Péter Györök
d4:{asc each "J"$"-"vs/:/:","vs/:x} 
{a:d4 x;sum(a[;1;1]<=a[;0;1]) or a[;0;0]=a[;1;0]} inp
{a:d4 x;sum a[;1;0]<=a[;0;1]} inp

// Cillian Reilly
sum{any(all;any)@\:/:(within)./:(reverse\)x}each "J"$"-"vs/:/:","vs/: inp

// Tadhg Downey
{sum{all[(in/)reverse x]|all (in/)x:("J"$"-"vs'x)[;0]+til each 1+abs value each x}each csv vs'x} inp
{sum{any (in/)x:("J"$"-"vs'x)[;0]+til each 1+abs value each x}each csv vs'x} inp

// Sujoy Rakshit
l:{(::;rotate[1;])@\: flip ("II";"-")0: "," vs x} each inp
sum {any (all')(within') . x} each l
sum {any (any')(within') . x} each l

// Stephen Taylor
/part 1
ass:desc each "J"$''"-"vs''","vs'inp 
sum ({$[any b:x=y;1b;x[1]<y 1]}.) each ass
/part 2
sum ({x[0]<=y 1}.) each ass

// David Crossey
count each where each max each' (all';any') each\: (within/) each' 2 cut' (,').(::;reverse each)@\:asc each "I"$"-" vs'' "," vs' inp