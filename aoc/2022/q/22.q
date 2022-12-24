/https://adventofcode.com/2022/day/22

inp: read0`:input/22.txt

//// https://github.com/adotsch/aoc/blob/master/2022/day22.q
// András Dőtsch
i:read0`22.txt
//part 1
I:2 cut get"(0;",(ssr[;"L";";-1;"]ssr[;"R";";1;"]last i),")"
J:(sums[I[;0]] mod 4) where I[;1]
D:(1 0;0 1;-1 0;0 -1)
M:-2_i
M:" ",/:((max count each M)$M),\:" "
M:{enlist[x],y,enlist x}[count[M 0]#" ";M]

f1:{[d]
    x1:X+D[d]0;y1:Y+D[d]1;
    if[" "=M[y1;x1];
        j:50;
        while[M[Y-j*D[d]1;X-j*D[d]0] in ".#";j+:50];
        x1:X-(j-1)*D[d]0; y1:Y-(j-1)*D[d]1;
    ];
    if["."=M[y1;x1];X::x1;Y::y1];
 }

X:X0:1+min M[1]?".#"; Y:1
f1 each J;
sum 1000 4 1 * Y,X,last J   //97356

//part 2

/        --- --- 
/       | 1 | 2 |
/        --- --- 
/       | 3 |
/    --- --- 
/   | 4 | 5 |
/    --- --- 
/   | 6 |
/    --- 

C:(" 12";
   " 3 ";
   "45 ";
   "6  ")

tile:{[X;Y] C[(Y-1) div 50;(X-1) div 50]}

f2:{[d]
    di:">v<^" d0:mod[d+dc;4];
    x1:X+D[d0]0;y1:Y+D[d0]1;dc1:dc;
    if[" "=M[y1;x1];
        t:tile[X;Y];
        if[(t;di)~"1^"; x1:1;     y1:X+100; dc1+:1];    / >6
        if[(t;di)~"1<"; x1:1;     y1:151-Y; dc1+:2];    / >4
        if[(t;di)~"2^"; x1:X-100; y1:200;   dc1+:0];    / ^6
        if[(t;di)~"2>"; x1:100;   y1:151-Y; dc1+:2];    / <5
        if[(t;di)~"2v"; x1:100;   y1:X-50;  dc1+:1];    / <3
        if[(t;di)~"3>"; x1:50+Y;  y1:50;    dc1-:1];    / ^2
        if[(t;di)~"5>"; x1:150;   y1:151-Y; dc1-:2];    / <2
        if[(t;di)~"5v"; x1:50;    y1:100+X; dc1+:1];    / <6
        if[(t;di)~"6>"; x1:Y-100; y1:150;   dc1-:1];    / ^5
        if[(t;di)~"6v"; x1:100+X; y1:1;     dc1+:0];    / v2
        if[(t;di)~"6<"; x1:Y-100; y1:1;     dc1+:3];    / v1
        if[(t;di)~"4<"; x1:51;    y1:151-Y; dc1+:2];    / >1
        if[(t;di)~"4^"; x1:51;    y1:50+X;  dc1+:1];    / >3
        if[(t;di)~"3<"; x1:Y-50;  y1:101;   dc1-:1];    / v4
    ];
    if["."=M[y1;x1];X::x1;Y::y1;dc::dc1];
 }

X:X0; Y:1; dc:0
f2 each J;
sum 1000 4 1 * Y,X,(dc+last J)mod 4     //120175

// Péter Györök
d22p2:{a:"\n\n"vs"\n"sv x;
    map:"\n"vs a 0;
    path:{(0,where 0<>deltas x in "LR")cut x}a 1;
    pos:0,(first where "."=map[0]),0;
    map:max[count each map]$map;
    wrap:.d22.genAdjacency[map];
    pos:{[map;wrap;pos;ins]
        $[ins~enlist"L"; pos[2]:(pos[2]-1)mod 4;
          ins~enlist"R"; pos[2]:(pos[2]+1)mod 4;
          [
            amt:"J"$ins;
            do[amt;
                prevpos:pos;
                pos:$[pos in key wrap;wrap pos;(.d22.direction[pos 2],0)+pos];
                if["#"=map . 2#pos; pos:prevpos];
            ];
          ]
        ];
    pos}[map;wrap]/[pos;path];
    sum 1000 4 1*1 1 0+pos};

.d22.onExterior:{[map;pos](pos[0]<0) or (pos[1]<0) or (pos[0]>=count map) or (pos[1]>=count map 0) or " "=map . pos};
.d22.onInterior:{[map;pos]not .d22.onExterior[map;pos]};

.d22.perimeterStep:{[map;pos;dir]
    nextpos:pos+.d22.direction[dir];
    if[.d22.onExterior[map;nextpos];
        dirL:(dir-1)mod 4;
        nextposL:pos+.d22.direction[dirL];
        dirR:(dir+1)mod 4;
        nextposR:pos+.d22.direction[dirR];
        if[.d22.onInterior[map;nextposL]; :(pos;dirL)];
        if[.d22.onInterior[map;nextposR]; :(pos;dirR)];
    ];
    (nextpos;dir)};

.d22.zipEdgesFromCorner:{[map;pos;dirp]
    dir0:dirp 0;
    dir1:dirp 1;
    dir0p:dir0;
    dir1p:dir1;
    pos0:pos+.d22.direction[dir0];
    pos1:pos+.d22.direction[dir1];
    res:enlist[`int$()]!enlist`int$();
    while[(dir0p=dir0) or dir1p=dir1;
        dir0p:dir0;
        dir1p:dir1;
        normout0:(dir0+1)mod 4;
        if[.d22.onInterior[map;pos0+.d22.direction[normout0]];
            normout0:(dir0-1)mod 4;
        ];
        normout1:(dir1+1)mod 4;
        if[.d22.onInterior[map;pos1+.d22.direction[normout1]];
            normout1:(dir1-1)mod 4;
        ];
        normin0:(normout0+2)mod 4;
        normin1:(normout1+2)mod 4;
        res[pos0,normout0]:pos1,normin1;
        res[pos1,normout1]:pos0,normin0;
        r0:.d22.perimeterStep[map;pos0;dir0];
        r1:.d22.perimeterStep[map;pos1;dir1];
        pos0:first r0; dir0:last r0;
        pos1:first r1; dir1:last r1;
    ];
    1_res};

.d22.genAdjacency:{[map]
    filler:enlist count[first map]#" ";
    diag:((1_(1_/:map),\:" "),filler;
        (1_" ",/:-1_/:map),filler;
        filler,-1_" ",/:-1_/:map;
        filler,-1_(1_/:map),\:" ");
    ortho:(1_/:map,\:" ";
        (1_map),filler;
        " ",/:-1_/:map;
        filler,-1_map);
    corner:raze til[count map],/:'where each(1=sum diag=" ")and 0=sum ortho=" ";
    corner:corner(;)'{x,'(x+1)mod 4}where each " "=diag .\:/:corner;
    raze .d22.zipEdgesFromCorner[map].'corner};

.d22.direction:(0 1;1 0;0 -1;-1 0);

