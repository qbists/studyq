/https://adventofcode.com/2022/day/19

inp: read0`:input/19.txt

//// https://github.com/adotsch/AOC
// András Dőtsch

I:("J"$" "vs/: inp)[;`ore`cla`obs`geo!((1#`ore)!1#6;(1#`ore)!1#12;`ore`cla!18 21;`ore`obs!27 30)]

system"gcc -std=gnu99 -DKXVER=3 -O3 -fPIC -c 19.c";
system"gcc -shared -fPIC 19.o -o 19.so";
ff:`19 2:`ff,2

\t show sum (1+til count I) * r: ff[24] peach I      //1199
\t show prd ff[32] peach 3#I                         //13*18*15

//// #adventofcode
// Péter Györök
.d19.checkRecipe:{[mt;r]
    queue:enlist`time`b0`b1`b2`b3`m0`m1`m2`m3!@[9#0;1;:;1];
    maxb0:max r 0 1 2 4;
    top:0;
    round:0;
    while[count queue;
        queue:update ub:m3+rmt*(b3+b3+rmt-1)%2 from update rmt:mt-time from queue;
        queue:update ptop:m3+rmt*b3 from queue;
        round+:1;
        top|:exec max ptop from queue;
        queue:delete from queue where ub<top;
        qtmp:update b0t:0 or(r[0]-m0)%b0, b1t:0 or(r[1]-m0)%b0, b2t:0 or((r[2]-m0)%b0)or(r[3]-m1)%b1, b3t:0 or((r[4]-m0)%b0)or(r[5]-m2)%b2 from queue;
        q0:update dtime:ceiling b0t+1, m0-r[0], bt:`b0 from select from qtmp where 0w>b0t, b0<maxb0;
        q1:update dtime:ceiling b1t+1, m0-r[1], bt:`b1 from select from qtmp where 0w>b1t, b1<r 3;
        q2:update dtime:ceiling b2t+1, m0-r[2], m1-r[3], bt:`b2 from select from qtmp where 0w>b2t, b2<r 5;
        q3:update dtime:ceiling b3t+1, m0-r[4], m2-r[5], bt:`b3 from select from qtmp where 0w>b3t;
        queue:delete b0t,b1t,b2t,b3t from q0,q1,q2,q3;
        if[0<count queue;
            queue:update time+dtime, m0:m0+dtime*b0, m1:m1+dtime*b1, m2:m2+dtime*b2, m3:m3+dtime*b3 from queue;
            queue:delete dtime,bt from @[;;+;1]'[queue;exec bt from queue];
            queue:distinct delete from queue where time>mt;
        ];
    ];
    top};
d19:{[time;x]a:("J"$(" "vs/:x))except\:0N;
    .d19.checkRecipe[time] each a};
d19p1:{sum(1+til[count x])*d19[24;x]};
d19p2:{prd d19[32;3 sublist x]};

