/https://adventofcode.com/2022/day/15

inp: read0`:input/15.txt

//// #adventofcode

// András Dőtsch
//part 1
i:j:get@'(.Q.n!.Q.n) inp
i[;0 2]+:1000000
Y:2000000
L:10000000#"."
f1:{
    s:x 0 1;b:x 2 3;
    d:sum abs s-b;
    r:s[0]+(abs[Y-s 1]-d;d-abs[Y-s 1]);
    if[.[<=]r;L[r[0]+til 1+r[1]-r 0]:"#"];
    if[Y=b 1;L[b 0]:"B"];
 }
f1 each i;
0+sum"#"=L
//part 2
L1:L2:L3:L4:([]x:();y:())
f2:{[x0;y0;x1;y1]
    d:1+abs[x0-x1]+abs[y0-y1];
    l:til d;
    `L1 upsert ([]x:x0+l    ;y:(y0-d)+l);
    `L2 upsert ([]x:(x0+d)-l;y:y0+l);
    `L3 upsert ([]x:x0-l    ;y:(y0+d)-l);
    `L4 upsert ([]x:(x0-d)+l;y:y0-l);
 }
.[f2] each j;
sum 4000000 1 * (raze/) L1 inter L2 inter L3 inter L4