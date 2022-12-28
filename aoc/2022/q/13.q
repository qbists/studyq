/https://adventofcode.com/2022/day/13

inp: read0`:input/13.txt

I: 2 cut .j.k each inp where count[inp]#110b

b: {x@/:(y;z)}  / 'both' combinator

cmp:{
  $[all b[type;x;y]<0;      `long$x-y;
    any b[count;x;y]=0;     .[-] b[count;x;y];
    r:cmp . b[first;x;y];   r;
                            cmp . b[1_(),;x;y] ] }

sum 1+where 1>cmp .' I              /part 1

qs: {$[2>count x; x;    
  raze(.z.s;::;.z.s)@'x(group signum x cmp\:first x)@-1 0 1
  ]}

`A`B set'b[.j.k;"[[2]]";"[[6]]"];
J: qs(A;B),raze I
prd 1+b[where ~/:[;J]::; A; B]     /part 2


\
// András Dőtsch
I:2#'3 cut p@'inp
cmp:{
    $[(0>type x)&0>type y;      `long$x-y;
      (0=count x)|0=count y;    count[x]-count y;
      r:cmp[first x;first y];   r;
                                cmp[1_(),x;1_(),y]]
 }
sum 1+where 1>cmp .' I              //1
qs:{$[2>count x;x;qs[x where 0>r],(x where 0=r),qs[x where 0<r:x cmp\: x 0]]}
J:qs(a:p"[[2]]";b:p"[[6]]"),raze I
prd 1+(where a~/:J;where b~/:J)     //2

// Péter Györök
/no need to write your own JSON parser if we have one built in
d13:{[part;x]
    a:.j.k each/:"\n"vs/:"\n\n"vs"\n"sv x;
    cmp:{$[-9 -9h~tt:type each (x;y);signum x-y;
        -9h=tt 0; .z.s[enlist x;y];
        -9h=tt 1; .z.s[x;enlist y];
        [c:min count each (x;y);
            tmp:.z.s'[c#x;c#y];
            $[0<>tr:first (tmp except 0),0;tr;
            signum count[x]-count[y]]
        ]]};
    if[part=1; :sum 1+where -1=.[cmp]'[a]];
    b:raze[a],dl:(enlist enlist 2f;enlist enlist 6f);
    sort:{[cmp;b]
        if[1>=count b; :b];
        cr:cmp[first b]'[1_b];
        left:b 1+where 1=cr;
        right:b 1+where -1=cr;
        .z.s[cmp;left],(1#b),.z.s[cmp;right]};
    b2:sort[cmp;b];
    prd 1+where any b2~\:/:dl}
d13[1] inp
d13[2] inp

// Sean Ang
prse:{get ssr[;"[[]";"enlist("] ssr[;"]";")"] ssr[;",";";"] x}
pairs:2 cut packets:prse each {x where not x~\:""} inp
cmp:{
    while[any count each (x;y);
        if[0=count x;:1b];
        if[0=count y;:0b];
        a:first x; b:first y;
        $[any 0<=(type a;type b);
            [
                if[0>type a;a:enlist a];
                if[0>type b;b:enlist b];
                res:.z.s[a;b];
                if[not (::)~res;:res]
            ];
            [
                if[a<b;:1b];
                if[a>b;:0b];
            ]
        ];
        x:1_x; y:1_y
    ];
 }
/ p1
sum 1+where cmp ./: pairs
/ p2
prd {1+where in[;0 1] iasc sum each 1b~''x cmp\:/:x}(enlist enlist 2;enlist enlist 6),packets

