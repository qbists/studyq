/https://adventofcode.com/2022/day/16

inp: read0`:input/16.txt

//// #adventofcode

// Péter Györök
d16:{[part;dur;x]
    a:(" "vs/:x except\:";,");
    n:`$a[;1]; flow:n!"J"$5_/:a[;4]; edge:n!`$9_/:a;
    n:asc n; flow2:flow n; edge2:n?edge n;
    c:count n;
    edge3:raze til[c],/:'edge2;
    dist:(c;c)#4000000000000000000;
    dist:.[;;:;0]/[dist;{x,'x}til c];
    dist:.[;;:;1]/[dist;edge3];
    dist:{[x;i]x&x[;i]+/:\:x[i;]}/[dist;til c];
    pfi:distinct 0,where 0<flow2;
    dist2:{x[y;y]}[dist;pfi];
    pf:flow2 pfi;
    cpf:count pf;
    queue:enlist`on`pos`time`tflow!(0=til cpf;0;0;0);
    maxflows:enlist[cpf#0b]!enlist 0;
    while[count queue;
        nq:queue;
        nq:raze{x,/:([]npos:where not x`on)}each nq;
        if[count nq;
            nq:update on:@[;;:;1b]'[on;npos], pos:npos, time:1+time+dist2 ./:(pos,'npos) from nq;
            nq:delete from nq where time>=dur;
            nq:update tflow:tflow+(dur-time)*pf npos from nq;
            maxflows|:exec on!tflow from nq;
        ];
        queue:nq;
    ];
    if[part=1; :max maxflows];
    kf:1_/:key maxflows;
    vf:value maxflows;
    max max (0=sum each/:kf and/:\:kf)*vf+/:\:vf};
d16p1:{d16[1;30;x]};
d16p2:{d16[2;26;x]};

x:enlist"Valve AA has flow rate=0; tunnels lead to valves DD, II, BB";
x,:enlist"Valve BB has flow rate=13; tunnels lead to valves CC, AA";
x,:enlist"Valve CC has flow rate=2; tunnels lead to valves DD, BB";
x,:enlist"Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE";
x,:enlist"Valve EE has flow rate=3; tunnels lead to valves FF, DD";
x,:enlist"Valve FF has flow rate=0; tunnels lead to valves EE, GG";
x,:enlist"Valve GG has flow rate=0; tunnels lead to valves FF, HH";
x,:enlist"Valve HH has flow rate=22; tunnel leads to valve GG";
x,:enlist"Valve II has flow rate=0; tunnels lead to valves AA, JJ";
x,:enlist"Valve JJ has flow rate=21; tunnel leads to valve II";

d16p1[x]    //1651
d16p2[x]    //1707


// András Dőtsch
//part 1
i:read0`16.txt
I:1!`fr`rt`to!/:{x:" "vs x;"SJS"$(x 1;(.Q.n!.Q.n)x[4];","vs raze 9_x)} each i
R:desc exec fr!rt from I where 0<rt

//part 1

start:`minute`pos`opened`score!(1;`AA;0#`;0)

pot:{
    v:(div[;2]30-x`minute) sublist value x[`opened] _ R;
    @[x;`pot;:;sum v * (30-x`minute)-2*til count v]
 }

opt:{
    o:flip 4#key[x]!();
    if[(x[`pos] in key R);
        if[not x[`pos] in x`opened;
            o:o upsert (x[`minute]+1;x`pos;x[`opened],x`pos;x[`score]+(30-x[`minute])*R x`pos);
        ]
    ];
    o:o upsert (x[`minute]+1;;x`opened;x`score) each I[x`pos;`to];
    o:o upsert (x[`minute]+1;x`pos;x`opened;x`score);
    pot each o
 }

BB:{[S]
    S:delete from S where (score+pot)<max score;
    S:select from S where score=(max;score)fby([]minute;pos;opened);
    ni:exec i from S where minute<30;
    if[0=count ni;:S];
    S:(delete from S where i in ni),raze opt each S ni;
    S:distinct S;
    if[maxScore[`score]<=ms:max S`score;ms:first S where ms=S`score; if[not maxScore~ms;maxScore::ms;show enlist ms]];
    S
 }

maxScore:``score!0 0

{first x`score}BB/[enlist pot start]

