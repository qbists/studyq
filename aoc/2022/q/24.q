/https://adventofcode.com/2022/day/24

inp: read0`:input/24.txt

//// #adventofcode
// Péter Györök
d24:{[part;x]
    w:count first x; h:count x;
    mapbase:".#"x="#";  //for visual only
    s:0,first where"."=first x;
    t:(count[x]-1),first where"."=last x;
    bdirm:">v<^"?x;
    bpos:raze til[count x],/:'where each 4>bdirm;
    bdir:bdirm ./:bpos;
    moves:(0 1;1 0;0 -1;-1 0;0 0);
    squeue:$[part=1;enlist s;(s;t;s)];
    tqueue:$[part=1;enlist t;(t;s;t)];
    round:0;
    while[count squeue;
        s:first squeue; t:first tqueue;
        squeue:1_squeue; tqueue:1_tqueue;
        queue:enlist s;
        found:0b;
        while[not found;
            if[0=count queue; '"no solution?!"];
            round+:1;
            bpos+:moves bdir;
            bpos[where bpos[;0]=0;0]:h-2;
            bpos[where bpos[;1]=0;1]:w-2;
            bpos[where bpos[;0]=h-1;0]:1;
            bpos[where bpos[;1]=w-1;1]:1;
            dbpos:distinct bpos;
            queue:distinct raze queue+/:\:moves;
            queue:queue except dbpos;
            queue:queue where all each queue within\:(0 0;(h-1;w-1));
            queue:queue where "#"<>x ./:queue;
            if[1b;  //set to 1b to enable visual
                map:mapbase;
                map:.[;;:;]/[map;bpos;">v<^"bdir];
                gbpos:{(where 1<x)#x}count each group bpos;
                if[count gbpos; map:.[;;:;]/[map;key gbpos;?[9<value gbpos;"*";first each string value gbpos]]];
                map:.[;;:;"E"]/[map;queue];
                -1"\nMinute ",string[round],":";
                -1 map;
            ];
            if[t in queue; found:1b];
        ];
    ];
    round};

// András Dőtsch
d:">v<^"!(1 0;0 1;-1 0;0 -1)
sx:count[inp 0]-2;sy:count[inp]-2;
c:sx*1+first where 0=mod[sx*1+til sy;sy]
M:c#enlist("#><^v."!"#.....")inp
f:{
    t:i[y;x];
    $[t in "#.";();[
        xs:1+mod[(x-1)+d[t;0]*til c;sx];
        ys:1+mod[(y-1)+d[t;1]*til c;sy];
        .[`M;;:;"#"]@'til[c],'ys,'xs
    ]]
 }
.[f] each cross[1+til sx;1+til sy];
F:{[j;T]
    T:distinct T,update x:x mod(sx+2),y:y mod(sy+2) from raze(
        update x-1 from T; update x+1 from T;
        update y-1 from T; update y+1 from T);
    (j+1;delete from T where "#"=M[j mod c]'[y;x])
 }
r1:  -1 + first .[{not (sx;sy+1) in y}] .[F]/ (  0;enlist`x`y!1 0)
show r1 //part 1
r21: -1 + first .[{not ( 1;   0) in y}] .[F]/ ( r1;enlist`x`y!(sx;sy+1))
r2:  -1 + first .[{not (sx;sy+1) in y}] .[F]/ (r21;enlist`x`y!1 0)
show r2 //part 2


