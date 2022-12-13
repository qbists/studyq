/https://adventofcode.com/2022/day/7


inp: read0 `:test/07.txt  

// András Dőtsch
f:{[s;l]
    if[(l~"$ ls")|l like "dir *";:s];
    if[l like "$ cd *";
      d:5_l;
      if[d~"..";:@[s;`path;first` vs]];
      if[d~1#"/";:@[s;`path;:;`:]];
      :@[s;`path;.Q.dd[;`$d]]
    ];
    :.[s;(`m;-1_(first` vs)\[s`path]);+;"J"$first" "vs l]
 }
s:`path`m!(`:;()!())
r:s f/inp
sum r.m where r.m<=100000
min r.m where r.m>=r.m[`:]-40000000

/alternative based on Péter Györök
p:(1#`:) {$[y~"$ cd /";1#x;y~"$ cd ..";-1_x;y like"$ cd *";x,.Q.dd[last x]`$5_y;x]} \ inp
s:"J"$first@'" "vs/:inp
d:exec sum s by p from ungroup ([]p;s)
sum d where d<=100000
min d where d>=d[`:]-40000000
/ ^-- ungroup and exec idea from Péter Györök

// Cillian Reilly
f:{$[y like"$ cd*";($[".."~5_y;(v;enlist"/")""~v:"/"sv(-2_"/"vs x 0),enlist"";x[0],$[enlist["/"]~v:(5_y);v;v,"/"]];x 1);y like"$ ls";x;y like"dir *";(x[0];x[1],enlist[x[0],(last" "vs y)]!enlist 0Nj);(x[0];x[1],enlist[x[0],t[1]]!enlist"J"$(t:" "vs y)0)]}
d:{(where x>0)#x}last f2/[("";()!());] inp
d:{sum each value[x]group "/"sv/:-1_/:"/"vs/:key x}d
d2:{(sum;y)fby x}. flip raze{(enlist each t),'{count[x]#y}[;x 1] t:-1_{"/"sv -1_"/"vs x}\[x 0]}each flip(key;value)@\:d

// part 1
sum d2 where 100001>d2
// part 2
min d2 where d2>(sum d)-40000000


// Péter Györök
d7:{a:" "vs/:x;
    pwd:{$[not y[0]~enlist"$";x;y[1]~"ls";x;y[2]~enlist"/";enlist"";
        y[2]~"..";-1_x;x,enlist last[x],"/",y 2]}\[enlist"";a];
    fs:"J"$first each a;
    exec sum fs by pwd from ungroup ([]pwd;fs)}
{t:d7 x;sum t where t<=100000} inp
{t:d7 x;min t where 30000000<=t+70000000-t[""]} inp

// Nick Psaris & Phineas
t:([]p:(,\')(){$["cd"~y 1;$[".."~y 2;-1_x;x,`$y 2];x]}\x;s:"J"$(x:" "vs/:inp)[;0])
sum (1+s bin 100000)#s:asc value exec sum s by p from ungroup t
s s binr last[s]-40000000

// Tadhg Downey
proc:{[wd;cmds] $["cd"~cmds[0;2 3];cd[wd;first cmds];ls[wd;cmds]]}
ls:{[wd;cmds] @[wd;`files;:;"J"$cmds[;0]where not "dir"~/:(cmds:1_ " "vs/:cmds)[;0]]}
cd:{[wd;cmd] cmd:" "vs cmd;$[".."~last cmd;wd:` sv -1_` vs wd;[wd:` sv wd,`$last cmd;wd set (1#.q),enlist[`files]!enlist 0#0]]}
getCmds:{where["$"=x[;0]]_x}
getTotalSize:{[cur] $[`files in key cur;cur[`files],raze .z.s each` sv/:cur,/:key[cur];0]}
getDirPaths:{[root] $[count key root;root,raze .z.s each` sv/:root,/:key[root]except``files;()]}

{[x]
  proc/[`root;getCmds x];
  sum value[sizes]where value 100000>sizes::d!sum each getTotalSize each d:getDirPaths ` sv `root,`$"/"
  } inp
{[t;m] first l where m<=l+t-last l:asc sizes}[inp;40000000]

// Stephen Taylor
cr: where[inp[;0]="$"]_ inp  /command:response list

//Solution 1
/shell commands
fp: {[sep;p]p,(sep<>last p)#sep}["/"]  /full path
cd: {[p;s]$["/"=s 0;s;".."~2#s;"/"sv -1_"/"vs p;fp[p],s]}  /new path
ls: {[path;strings]
  m: " "vs'strings;
  typ: `f`d null siz: "J"$m[;0];
  pth: fp[path],/:m[;1];
  ([pth]typ;siz) }

/shell explorer
se: {[state;cr]  /state; commend/response
  fs: state 0; path: state 1; cmd: cr[0;2 3];
  if[cmd~"cd"; path: cd[path] 5_first cr];
  if[cmd~"ls"; fs,: ls[path] 1_cr];
  (fs;path) }  

fst: 1!flip `pth`typ`siz!enlist each(1#"/";`d;0N)  /file system template
FS:first (fst;"") se/ cr  /discover file system

/directory sizes
dp: {x idesc count each x}exec pth from FS where typ=`d  /dir paths
ds: (0!FS){sum x[`siz]where (`f=x`typ)&x[`pth]like fp[y],"*"}/:dp
FS: FS upsert([pth:dp]siz:ds)

/part 1
exec sum siz from FS where siz<=100000,typ=`d
/part 2
reqd: 0|30000000-70000000-FS[enlist"/";`siz]  /required space
first exec siz from `siz xasc select from FS where typ=`d,siz>reqd

//Solution 2
/ András Dőtsch and Péter Györök
p:(1#`:) {$[y~"$ cd /";1#x;y~"$ cd ..";-1_x;y like"$ cd *";x,.Q.dd[last x]`$last" "vs y;x]} \ inp
s:"J"$first@'(" "vs/:inp)
d:exec sum s by p from ungroup ([]p;s)
sum d where d<=100000
min d where d>=d[`:]-40000000

// Ahmed Shahbaz
/preprocess for absolute paths
cd:"";
j:(1#i),{$[x~"$ cd .."; cd::{(last x ss"/")#x}cd;
           x like"$ cd *"; [xo:x; x:raze"$ cd ",cd,"/",-1#" "vs x; cd::raze cd,"/",-1#" "vs xo];
           x like "dir *"; x:raze"dir ",cd,"/",-1#" "vs x];
         x}'[1_inp]
/calculate dir sizes
dirs:{x where x like "*ls*"}"@$ cd" vs "@","@"sv j
/note- fs = file system; d = dir; s = size
fs:{([]d:key x; s:value x)}"J"$string`${(`$x 1)!x 0}@'{flip@'" "vs''"@"vs'x}{(`$x 0)!x 1}flip{"@$ ls@"vs x}@'dirs
fs:{x:update sum'[s] from x where (all not null::)@'s;
    xx:exec d!s from x where (all not null::)@'s;
    update s:{key[y]#x^y}[xx;]@'s from x where (any null::)@'s}/[fs]
/part 1
exec sum s from fs where s<=100000
/part 2
capacity:70000000; required:30000000; used:first fs`s /first fs`s is root
exec min s from fs where s>= required + used - capacity

// Michael Turkington
d:()!()
path:()
f:{x:" "vs x;$["cd"~x[1];
  $[".."~x[2];path::-1_path;path::path,enlist x[2]];
  "ls"~x[1];:();"dir"~x[0];:();
  d[$[1=count path;path;{"/" sv (x;y)}\[path]]]+::"J"$x[0]]}
f each inp
/p1
sum d where d<=100000

// Phineas
/p1
t:update p:{$[y=`$"..";-1_x;x,y]} scan `$@'[;2]n from ([]n:" "vs/:inp) where inp like "$ cd*"
t:select {$[count y;y;(),x]} scan p,s:"J"$n[;0],r:`$n[;1],n from t
t:([]p:1 0#`;s:0N;r:`$"/"),select p,s,r from t where n[;0;0]<>"$"
f:{x lj select s:(sum s;0N)any null s by p:-1_/:p, r:last each p from x}
select sum s from t:f over (update d:null s from t) where d,s<100000
/p2
select min s from t where s>30000000-70000000-first s 