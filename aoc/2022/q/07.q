/https://adventofcode.com/2022/day/7

/ingestion
inp: read0 `:input/07.txt  
cr: where[inp[;0]="$"]_ inp  /command:response list


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
