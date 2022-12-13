/https://adventofcode.com/2022/day/11

// ingestion
/ test: read0`:test/11.txt
/ inp: read0`:input/11.txt

/part 1
is: {  /initial state
  w: get each .[;(::;1)]":"vs'x[;1]; /item worry levels
  o: get each
    ({"{",x,"}"}ssr[;"old";"x"]except[;" "]::) 
    each .[;(::;1)] "="vs'x[;2]; /op
  d: first("   J";" ")0:2_'x[;3]; /divisor
  t: get each raze each -2#''x[;4 5]; /to monkeys
  n: count[w]#0; /# inspected
  ([]w;o;d;t;n) } {(where x like "Monkey *")_ x} ::

test:  read0`:test/11.txt
input: read0`:input/11.txt

monkey: {[rlx;s;i]  /relaxation; state; monkey#
  m: s i;  /monkey dict
  w: div[;rlx]m[`o]@m`w; /new worry levels
  t: w group m[`t]0<mod[;m`d] w; //what to throw where
  s: .[;(i;`w);0#] .[;(i;`n);count[w]+] .[s;(key t;`w);{x,y};value t];  /throw
  s }

round: {[rlx;s] s monkey[rlx]/til count s}

prd 2#desc@[;`n] 20 round[3]/is test

/part2
is: {  /initial state
  d: first("   J";" ")0:2_'x[;3]; /divisor
  w: (mod\:[;d](),get ::)each .[;(::;1)]":"vs'x[;1]; /item worry levels
  o: get each
    ({"{",x,"}"}ssr[;"old";"x"]except[;" "]::) 
    each .[;(::;1)] "="vs'x[;2]; /op
  t: get each raze each -2#''x[;4 5]; /to monkeys
  n: count[w]#0; /# inspected
  ([]w;o;d;t;n) } {(where x like "Monkey *")_ x} ::

test:  read0`:test/11.txt
input: read0`:input/11.txt

monkey: {[s;i]  /relaxation; state; monkey#
  m: s i;  /monkey dict
  w: mod\:[;s`d] m[`o]@m`w; /new worry levels
  c: (s`d)?m`d; 
  t: w[;c]@group m[`t]@0<w[;c]; //what to throw where
  s: .[;(i;`w);0#] .[;(i;`n);count[w]+] .[s;(key t;`w);{x,y};value t];  /throw
  s }

round: {x monkey/til count x}

prd 2#desc@[;`n] fs: 10000 round/is test


/
