/https://adventofcode.com/2022/day/14

inp: read0`:input/14.txt

//// k4 Topicbox

//// #adventofcode

// Péter Györök
1 2 {[part;x]
    a:"J"$","vs/:/:" -> "vs/:x;
    f:{if[0=count y;:()];c:asc(x;y);x:c 0;y:c 1;$[x[0]=y[0];
        x[0],/:x[1]+til 1+y[1]-x[1];(x[0]+til 1+y[0]-x[0]),\:x[1]]};
    c:reverse each distinct raze raze f':'[a];
    start:min enlist[0 500],c;
    size:1+max[c]-min[c];
    maxh:max[c[;1]];
    if[part=2; start[1]:min(start 1;500-maxh)];
    b:c-\:start;
    origin:0 500-start;
    end:max b;
    if[part=2; end[0]+:1;end[1]:max(end 1;origin[1]+maxh)];
    map:.[;;:;"#"]/[(1+end)#" ";b];
    if[part=2; map,:enlist (1+end[1])#"#"];
    drop:{[pos;x]
        i:x 0;
        map:x 1;
        moved:1b;
        finish:0b;
        while[moved;
            moved:0b;
            nudge:$[" "=map[pos[0]+1;pos[1]];0;
                " "=map[pos[0]+1;pos[1]-1];-1;
                " "=map[pos[0]+1;pos[1]+1];1;
                0N];
            if[not[" "=map . pos] or (pos[0]>=count map) or
                (pos[1]<0) or (pos[1]>=count first map);
                nudge:0N; finish:1b];
            if[not null nudge;
                moved:1b;
                pos+:(1;nudge);
                pos[0]:count[map]^pos[0]+first where
                    not" "=(1+pos[0])_map[;pos[1]];
            ];
        ];
        if[not finish;i+:1;map:.[map;pos;:;"o"]];
        (i;map)};
    first drop[origin]/[(0;map)]}\: inp

// András Dőtsch
I:raze{1_(;)':[x]}@'get'' " -> "vs/:inp
fl:last max raze I
M:(fl+3;1000)#"."
{.[`M;reverse min[x]+til@'1+max[x]-min x;:;"#"]} each I;
f:{[stopy]
  while[1b;
    cx:500;cy:0;stop:0b;
    while[not stop;
      $["."=M[cy+1;cx]  ; cy+:1;
        "."=M[cy+1;cx-1];[cy+:1;cx-:1];
        "."=M[cy+1;cx+1];[cy+:1;cx+:1];
                         stop:1b
      ];
      if[cy=stopy;:()]
    ];
    M[cy;cx]:"o";
  ]
 }
f[fl];2 sum/"o"=M      // 1
M[fl+2]:1000#"#"
f[0];1+2 sum/"o"=M     // 2

//// Vector Dojo

// Cillian Reilly
npt:"J"$","vs'/:" -> "vs/: inp
rocks:reverse each'raze{flip -1_/:1 next\x}each npt
offset:0 499&min raze rocks
start:0 500-offset
rocks:rocks-\:\:offset
map:#[;0b]1+(-/)(max;min)@\:raze[rocks],enlist start
smear:{x|sums[x]mod 2}
horizontal:{(0<abs(-/)x)?1b}
mark:{./[x;y;:;1b]}
draw:{$[horizontal y;smear each mark[x;y];reverse flip smear each flip reverse mark[x;y]]}
map:not any draw[map;]each rocks

move:{$[not any m:x ./:n:y+/:(1 0;1 -1;1 1);[$[not 2 all/n within'\:(0,-1+count x;0,-1+first count each x);0N;y]];n m?1b]}
pour:{$[0N~n:move[y;]/[x];y;.[y;n;:;0b]]}

// part 1
{(2 sum/y)-2 sum/pour[x;]/[y]}[start;map]

// part 2
height:3+3 max/rocks
offset:(0,height)-start
start:start+offset
rocks:rocks+\:\:offset
map:(1+(height-1),2*height)#0b
map:not any draw[map;]each rocks
map:@[map;-1+height;:;(count first map)#0b]
{(2 sum/y)-2 sum/pour[x;]/[y]}[start;map]