/https://adventofcode.com/2022/day/18

inp: read0`:input/18.txt

//// k4 Topicbox
// András Dőtsch
I:get@'inp
//part 1
D:(1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1)
s:{[I] sum count@'I except/:D+/:\:I}
s I
//part 2
I+:1
U:cross/[til@'2+max I]
f:{[C] distinct C,U inter raze[D+/:\:C] except I}
s U except f/[1 3#0]

/The shortest alternative I've found to generate D:
D:(0-1_4#)\[1 0 0]

//// #adventofcode
// Péter Györök
.d18.dirs:(1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1);
d18p1:{a:"J"$","vs/:x;
    count raze[a+/:\:.d18.dirs]except a};
d18p2:{a:"J"$","vs/:x;
    b:raze[a+/:\:.d18.dirs]except a;
    disp:min[b];
    b:b-\:disp;
    a:a-\:disp;
    size:max b;
    bg:count each group b;
    found:0;
    visited:(1+size)#0b;
    queue:enlist 0 0 0;
    while[count queue;
        visited:.[;;:;1b]/[visited;queue];
        found+:sum bg queue;
        queue:(distinct raze queue+/:\:.d18.dirs)except a;
        queue:queue where all each queue within\:(0 0 0;size);
        queue:queue where not visited ./:queue;
    ];
    found};


//// Vector Dojo
// George Berkeley
s:value each inp
dirs:(1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1)
sum raze {not in[;s] x +/:dirs} each s / part 1
minps:-1+min s
maxps:1+max s
inbox:{all (x;y;z){[d;i](d>=minps[i]-1)&d<=maxps[i]+1}'(0 1 2)}.
v:enlist -1+minps
q0:enlist (-1+min s),3#0
surface:()
run:{[q]
  p:first q;
  $[in[;s] 3#p;
    {surface,:x; 1_ y}[p;q];
    in[3#p;v];
    1_ q;
    {v,:enlist x; (1_ y),ps where {inbox 3#x} each ps:{(x+/:dirs),'dirs} x}[3#p;q]]};
(0<count@)run/ q0
count distinct 6 cut surface / part 2

//// https://github.com/CillianReilly/AOC
cubes:value each read0`18t.txt
d1:(1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1)

// part 1
p1:(6*count cubes)-sum count each(cubes+/:\:d1)inter\:cubes

// part 2
// 6 neighbours listed - trapped air

// d2:(2 0 0;1 1 0;1 -1 0;1 0 1;1 0 -1)
// gaps:except[;cubes]1 0 0+/:cubes where 5=count each(cubes+/:\:d2)inter\:cubes

// (gaps+/:\:d1)except\:cubes
// need bfs in 3d to not revisit gaps
cubes:value each read0`18t.txt
d1:(1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1)

// part 1
p1:(6*count cubes)-sum count each(cubes+/:\:d1)inter\:cubes

// part 2
// 6 neighbours listed - trapped air

// d2:(2 0 0;1 1 0;1 -1 0;1 0 1;1 0 -1)
// gaps:except[;cubes]1 0 0+/:cubes where 5=count each(cubes+/:\:d2)inter\:cubes

// (gaps+/:\:d1)except\:cubes
// need bfs in 3d to not revisit gaps

