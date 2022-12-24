/https://adventofcode.com/2022/day/23

inp: read0`:input/23.txt

//// #adventofcode
// Péter Györök
d23:{[part;x]
    map:"#"=x;
    round:0;
    moveDirs:(6 3 0;7 4 1;2 0 1;5 3 4);
    moveDeltas:(-1 0;1 0;0 -1;0 1);
    while[1b;
        round+:1;
        filler:enlist (2+count first map)#0b;
        mapp:filler,(0b,/:map,\:0b),filler;
        mapr:-1_raze -1 1 0 rotate\:/:-1 1 0 rotate/:\:mapp;  //NW, SW, W, NE, SE, E, N, S
        noMove:0=sum mapr;
        pmv:3=sum each not[mapr] moveDirs;
        noMove:not[mapp] or noMove or 0=sum pmv;
        pmv2:(0N,/:-1+til 5)@'enlist[noMove],pmv;
        prop:^/[reverse pmv2];
        propCoord:raze til[count prop],/:'where each prop>-1;
        propDir:prop ./:propCoord;
        propDest:propCoord+moveDeltas propDir;
        validDest:where propDest in where 1=count each group propDest;
        if[(part=2) and 0=count validDest; :round];
        propCoord:propCoord validDest;
        propDest:propDest validDest;
        mapp:.[;;:;0b]/[mapp;propCoord];
        mapp:.[;;:;1b]/[mapp;propDest];
        while[0b=max first mapp; mapp:1_mapp];
        while[0b=max last mapp; mapp:-1_mapp];
        while[0b=max mapp[;0]; mapp:1_/:mapp];
        while[0b=max mapp[;count[first mapp]-1]; mapp:-1_/:mapp];
        map:mapp;
        moveDirs:1 rotate moveDirs;
        moveDeltas:1 rotate moveDeltas;
        if[(part=1) and round=10;
            :`long$sum sum not map;
        ];
    ];
    };

// András Dőtsch
I:`y`x!/:raze til[count inp],/:'where@'"#"=inp
m:{[t;dx;dy] select y+dy,x+dx from t}
f:{[t;i]
    //can move n,s,w,e
    mn: t except m[t; 1; 1],m[t; 0; 1],m[t;-1; 1];
    ms: t except m[t; 1;-1],m[t; 0;-1],m[t;-1;-1];
    mw: t except m[t; 1; 1],m[t; 1; 0],m[t; 1;-1];
    me: t except m[t;-1; 1],m[t;-1; 0],m[t;-1;-1];
    done: mn inter ms inter mw inter me;
    //choosing direction in the right order
    mvs:i rotate (mn;ms;mw;me) except\: done;
    mvs[1]: mvs[1] except mvs[0];
    mvs[2]: mvs[2] except mvs[0],mvs[1];
    mvs[3]: mvs[3] except mvs[0],mvs[1],mvs[2];
    mvs:neg[i] rotate mvs;
    mn: mvs 0; mnm: m[mn; 0;-1];
    ms: mvs 1; msm: m[ms; 0; 1];
    mw: mvs 2; mwm: m[mw;-1; 0];
    me: mvs 3; mem: m[me; 1; 0];
    //can move unless others want to go there
    mn: mn except m[    msm,mwm,mem; 0; 1];
    ms: ms except m[mnm    ,mwm,mem; 0;-1];
    mw: mw except m[mnm,msm    ,mem; 1; 0];
    me: me except m[mnm,msm,mwm    ;-1; 0];
    //move
    :raze(
        t except mn,ms,mw,me;
        m[mn; 0;-1];
        m[ms; 0; 1];
        m[mw;-1; 0];
        m[me; 1; 0])
 }

{prd[1+max[x]-min x]-count x} I f/ til 10
i:0;{i+::1;f[x;i-1]}/[I];i

//// #vector-dojo
// Rory Kemp
elves:asc flip {(count first x) vs where raze x}"#"=read0 `23.txt
dirs:`SE`S`SW`E`Z`W`NE`N`NW!{x cross x}1 0 -1
adj:`N`S`W`E`Z!dirs(`N`NW`NE;`S`SW`SE;`W`NW`SW;`E`NE`SE;key[dirs]except `Z)
L:10000; elves:L sv'5000+elves; dirs:L sv'dirs; adj:L sv''adj
d:`E`N`S`W
upd:{
 n:{dirs x 0^{first where all each x} each not in[;y] y +\: adj x}[`Z,d::1 rotate d; x];
 asc x+n*1={(count each group x)x}x+n}
({(prd 1+max[x]-min x)-count x}flip L vs r 10; count r:upd scan elves)


