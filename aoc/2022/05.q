// Create a list of lists from the first 8 lines
// Add a empty string to mimmic position
d:(enlist ""),(reverse')[l where {any .Q.A in x} each l:(trim')flip 8#i:read0`aoc_5.txt];

// move a from b to c
n:flip (" I I I";" ")0: 10_ i;

// From list at 'b' position take 'a' characters from the list and reverse the order
// Append the same to 'c'
// Remove the characters from 'b'
f:{[x;a;b;c] @[@[x;c;,;a#reverse x b];b;neg[a]_]};

// From list at 'b' position take 'a' characters from end of the list
// Append the same to 'c'
// Remove the characters from 'b'
f2:{[x;a;b;c] @[@[x;c;,;neg[a]#x b];b;neg[a]_]};

// Part 1 traverse through the list, for each entry in n
(last')f/[d;n[;0];n[;1];n[;2]]

// Part 2 traverse through the list, for each entry in n
(last')f2/[d;n[;0];n[;1];n[;2]]
