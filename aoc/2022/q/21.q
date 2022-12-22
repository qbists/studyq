/https://adventofcode.com/2022/day/21

inp: read0`:input/21.txt

//// k4 Topicbox
// Igor Khorkov
/ part 1
value each ssr/[;(": ";"/");("::";"%")]@'inp;`long$root

//// https://github.com/adotsch/AOC
// András Dőtsch
//part 1
(v:`$4#'i)set'0;
I:ssr[;"/";"%"]@'inp
f:{value@'I;`. v};f/[];
"j"$root
//part 2
`va`vb set' `$(" "vs I v?`root)1 3;
I:I where not I like "humn*"
F:{v set' 0;humn::x;f/[];get[va]-get vb}
"j"${x - .1 * Fx % F[x+.1] - Fx:F x}/[0]   //Newton–Raphson method

//// #adventofcode
// Péter Györök
d21p1:{a:": "vs/:x;
    val:(`$a[;0])!"F"$a[;1];
    op:raze{d:" "vs x 1;$[3=count d;enlist[`$x 0]!enlist(("+-*/"!(+;-;*;%))d[1;0]),`$d 0 2;()]}each a;
    val:{[op;val]val^:key[op]!value[op][;0].'val 1_/:value[op];val}[op]/[val];
    val`root};
d21p2:{a:": "vs/:x;
    val:enlist[::]!enlist();
    val,:(`$a[;0])!"F"$a[;1];
    val[`humn]:`humn;
    op:raze{d:" "vs x 1;$[3=count d;enlist[`$x 0]!enlist(("+-*/"!(+;-;*;%))d[1;0]),`$d 0 2;()]}each a;
    op[`root;0]:(=);
    val:{[op;val]val,:key[op]!value[op][;0]{$[any -9h<>type each y;x,y;x . y]}'val 1_/:value[op];val}[op]/[val];
    if[0h<>type val[`root;1]; val[`root;1 2]:val[`root;2 1]];
    goalNum:val[`root;2];
    goalOp:val[`root;1];
    while[0h=type goalOp;
        $[-9h=type goalOp 2;[
            goalNum:$[(%)=first goalOp; goalNum*goalOp[2];
                (*)=first goalOp; goalNum%goalOp[2];
                (+)=first goalOp; goalNum-goalOp[2];
                (-)=first goalOp; goalNum+goalOp[2]];
            goalOp:goalOp 1;
        ];[
            goalNum:$[(%)=first goalOp; goalOp[1]%goalNum;
                (*)=first goalOp; goalNum%goalOp[1];
                (+)=first goalOp; goalNum-goalOp[1];
                (-)=first goalOp; goalOp[1]-goalNum];
            goalOp:goalOp 2;
        ]];
    ];
    goalNum};

//// https://github.com/CillianReilly/AOC
// Cillian Reilly
\P 0
npt:{first[x]!ssr[;"/";"%"]each last x}("S*";":")0:inp

// part 1
o:(10h in type each value@){key[x]set'value x:{$[any -7 -9h in type x;x;any -7 -9h in type @[value;x;x];value x;any all each -7 9h=\:type each{@[value;x;x]}each -2#parse x;value x;x]}each x;x}/npt
o`root

// part 2
delete humn from`.;
npt:{first[x]!trim ssr[;"/";"%"]each last x}("**";":")0:`21.txt
npt:@[npt;"humn";:;"humn"]
root:ssr[npt"root";"+";"="]
f:{$[y~"humn";y;any y in .Q.a;"(",,[;")"]string[first p]sv .z.s[x;] each x string -2#p:parse y;y]}
step:{eval raze undo[;y]0 1 cut@[last x;y;:;first x]}
g:{,[;enlist x[1;i]]step[first[x],enlist t;]i:?[;0h]type each t:{@[eval;x;x]}each last x}

undo:{  op:2 first/x;
    $[(%)~op;
        $[y=1;(*;last x);(%;last x)];
      (-)~op;
        $[y=1;(+;last x);(-;last x)];
      (+)~op;
        $[y=1;(-;last x);(-;reverse last x)];
      (*)~op;
        $[y=1;(%;last x);(%;reverse last x)]
       ]}

o:asc{parse@[string value@;x;x]}each"="vs -1_1_f[npt;root]
{step[first[x],enlist t;]?[;`humn]t:{@[eval;x;x]}each last x}(not`humn in last@)g/o