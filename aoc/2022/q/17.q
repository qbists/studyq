/https://adventofcode.com/2022/day/17

ROCKS: (
  0,'til 4; 
  (0 1;1 0;1 1;1 2;2 1); 
  (0 2;1 2;2 0;2 1;2 2); 
  til[4],'0; 
  0 1 cross 0 1 )

JETS: -1 1 "<>"?first read0`:input/17.txt

is:`stack`posn`nr`nj`dr!(4 7#0b;0 2;0;0;0)                     /initial state

step: {[s]                                                     /state
  xy: rc s: puff s;                                            /  jet puff
  $[overlap[xy+\:1 0;s`stack];                                 /  blocked?
    new @[s;`stack;:;] ./[;xy;1b|] s`stack;                    /  fuse in place; next rock
    @[s;`posn;1 0+] ] }                                        /  fall

overlap: {[xy;stack]
  any xy in 
    0W 7 vs/: where raze(2+first[max xy])#stack,1 7#1b }

top: sum not any flip::                                        /# empty rows

new: {[s]                                                      /state
  s[`nr]+:1;                                                   /  next rock
  rh: 1+ max ROCKS . (mod[s`nr;5];::;0);                       /  rock height 
  nnr: 0|rh+3-t:top s`stack;                                   /  # new rows
  s: @[s;`stack;] $[nnr;,[(nnr,7)#0b;];::];                    /  lengthen stack?
  s: @[s;`posn;:;] (top[s`stack]-rh+3),2;                      /  posn rock
  dr: count[s`stack]-max flip[s`stack]?'1b;                    /  # dropped rows
  @[;`stack;neg[dr]_] @[;`dr;dr+] s }

puff: {[s]                                                     /state
  j: JETS s[`nj]mod count JETS;                                /  next jet
  xy: rc[s]+\:0,j;                                             /  proposed new coords
  s[`posn]+: 0,j*$[all xy[;1]within 0 6;
    not overlap[xy]s`stack; 0b];                               /  move sideways?
  @[s;`nj;1+] }                                                /  # jets

rc: {[s] s[`posn]+/:ROCKS s[`nr]mod 5}                         /  rock coords

disp: {[s]
  xy: s[`posn]+/:ROCKS s[`nr]mod 5;                            /  rock coords
  ,[;1 9#"+-+"where 1 7 1] 1 rotate'"||",/:
    ./[;xy;:;"@"] ".#"@s`stack }

s: {x[`nr]<2022}step/is
s[`dr]+.[-](count;top)@\:s`stack                               /Part 1

/
////#adventofcode
// Péter Györök
.d17.shape:{raze til[count x],/:'where each x}each not null
    (enlist"####";(" # ";"###";" # ");("  #";"  #";"###");
    enlist each"####";("##";"##"));
.d17.ssz:1+max each .d17.shape;

d17:{[lim;x]
    dir:-1+2*">"=first x;
    dc:count dir;
    field:();
    i:-1;
    pcs:0;
    top:0N;
    flog:enlist[()]!enlist `int$(); //field log
    hlog:`int$();   //height log
    while[1b;
        i+:1;
        d:dir[i mod dc];
        if[null top;
            m:0; while[$[m=count field;0b;0=sum field m]; m+:1];
            field:m _field;
            if[pcs>=lim; :count[field]];
            hlog,:count field;
            snap:0b,raze 12 sublist field;
            flog[snap],:pcs;
            if[3<=count st:flog[snap];
                if[1=count pers:distinct 1_deltas st;
                    per:first pers;
                    hfst:hlog[st 0];    //height in first partial period
                    hper:hlog[st 2]-hlog[st 1]; //height per period
                    fullPers:(lim-st 0)div per; //number of full periods
                    plst:(lim-st 0)mod per;  //pieces in last partial period
                    hlst:hlog[plst+st 1]-hlog[st 1]; //height in last partial period
                    :hfst+(fullPers*hper)+hlst;
                ];
            ];
            shape:.d17.shape pcs mod 5;
            ssz:.d17.ssz pcs mod 5;
            field:((ssz[0]+3)#enlist 7#0b),field;
            top:0;
            left:2;
            pcs+:1;
        ];
        left+:d;
        if[7<left+ssz 1; left-:1];
        if[0>left; left+:1];
        if[any field ./:(top;left)+/:shape; left-:d];
        top+:1;
        hit:0b;
        if[count[field]<top+ssz 0; hit:1b];
        if[any field ./:(top;left)+/:shape; hit:1b];
        if[hit;
            top-:1;
            field:.[;;:;1b]/[field;(top;left)+/:shape];
            top:0N;
        ];
    ];
    };
d17p1:{d17[2022;x]};
d17p2:{d17[1000000000000;x]};

// An
//
i:first read0`17.txt

{x}S:flip@'(
    (0 0;0 1;0 2;0 3);
    (0 1;1 0;1 1;1 2;2 1);
    (2 2;1 2;0 0;0 1;0 2);
    (0 0;1 0;2 0;3 0);
    (0 0;0 1;1 0;1 1));
ws:4 3 3 1 2
hs:count each S

free:{[j;x;y]
    if[x<0;:0b];
    if[7<x+ws j;:0b];
    :0=count C inter flip`y`x!(y;x)+S j;
 }

f:{[j]
    ws:4 3 3 1 2;
    y0:y:(exec max y from C)+4;
    x:2;
    move:1b;
    while[move;
        //gas
        mx:("<>"!-1 1)i mi mod count i;
        if[free[j;x+mx;y];
            x+:mx];
        mi+::1;
        //fall
        $[free[j;x;y-1];y-:1;move:0b]
    ];
    `C upsert flip`y`x!(y;x)+S j;
    R[y+S[j;0]]+:1;
    if[1<count fr:where 7=R;
        delete from `C where y<max fr;
        R :: til[max fr] _ R;
    ]
 }

//part 1
C:([]y:0;x:til 7);R:(1#0)!1#7;mi:0
f each til[2022] mod 5;
max C.y

//part 2
C:([]y:0;x:til 7);R:(1#0)!1#7;mi:0
t:{r:`j`I`mi`H!(x mod 5;x;mi mod count i;max C.y);f x mod 5;r}
    each til count i; // 3*count i for test input

rep:first select from t where 1<(count;I)fby([]j;mi)

rep:(1#.q),first select from 
    (select j,I,dI:deltas I,mi,H,dH:deltas H from t where j=rep`j,mi=rep`mi) 
    where 
        dI in (where 1<count each group dI), 
        dH in (where 1<count each group dH);

h:rep.H + rep.dH * div[1000000000000 - rep.I; rep.dI];
rem:mod[1000000000000 - rep.I; rep.dI];
h+: t[rep.I+rem;`H] - rep.H;
show h


//// Vector Dojo

// Cillian Murphy
gas:0,'neg 61-7h$first read0`17t.txt
grid:3 7#1b
rocks:((0 2;0 3;0 4;0 5);(2 3;1 2;1 3;1 4;0 3);(2 2;2 3;2 4;1 4;0 4);(0 2;1 2;2 2;3 2);(0 2;0 3;1 2;1 3))

height:{1+(-/)(max;min)@\:x[;0]}
draw:{./[x;y;:;0b]}
push:{p:$[all x ./:p:y+\:first gas;p;y];gas::1 rotate gas;p}
fall:{$[b:all x ./:f:y+\:1 0;(f;b);(y;b)]}
move:{$[last m:fall[x;]push[x;first y];m;(first m;0b)]}
justify:{((3,count first x)#1b),((all each x)?0b)_x}
drop:{x:((height first y;count first x)#1b),x;justify draw[x;]first(last)move[x;]/y}

// part 1
-3+count{drop[x;(y;1b)]}/[grid;2022#rocks]


