/ https://adventofcode.com/2022/day/2

/ ingestion
inp:read0 `:input/02.txt

// András Dőtsch & Nick Psaris
i:flip ("CC";" ") 0: `:test/02.txt
k:"ABC" cross "XYZ"
/ part 1
s:k!raze 1 2 3+/:2 rotate[-1]\ 3 6 0
sum s inp
/ part 2
s:k!raze 0 3 6+/:2 rotate[1]\ 3 1 2
sum s inp

// András Dőtsch
/A shorter vesion with less insights.
i:read0`02.txt
s1:asc[distinct i]!3 6 0 0 3 6 6 0 3+9#1 2 3 
sum s1 inp
s2:asc[distinct i]!3 1 2 1 2 3 2 3 1+9#0 3 6
sum s2 inp


// Attila Vrabecz
i:-88h+7h$("cc";" ")0:inp
sum 1+i[1]+3*mod[;3]2-(-/)i
sum(3 1 2 mod[;3]sum 3 2+i)+3*i 1

// Zsolt Venczel
r1: `A`B`C!(`X`Y`Z!(4; 8; 3); `X`Y`Z!(1; 5; 9); `X`Y`Z!(7; 2; 6))
r2: `A`B`C!(`X`Y`Z!(3; 4; 8); `X`Y`Z!(1; 5; 9); `X`Y`Z!(2; 6; 7))
fn: {sum {x[first -1_y][first 1_y]}[x] each {`$" " vs x} each inp}
fn each (r1; r2)

// Tadgh Downey
/Calculated all the outcomes by hand :joy:
p1Score:`A`B`C`X`Y`Z!(1 2 3 1 2 3)
p1Outcome:(rps cross rps:1+til 3)!3 6 0 0 3 6 6 0 3
p2Score:`A`B`C`X`Y`Z!(1 2 3 0 3 6)
p2Outcome:(1 2 3 cross 0 3 6)!(3 1 2 1 2 3 2 3 1)
d2:{[f;s;o] sum scores[1]+o flip scores:s("SS";" ")0:inp}

// George Berkeley
s:(" " vs) each inp
m:{neg["i"$x]+"i"$y}
p1:(4 8 3;1 5 9;7 2 6).
p2:(3 4 8;1 5 9;2 6 7).
sum {p1 ("A";"X")m'x} each s / part 1
sum {p2 ("A";"X")m'x} each s / part 2

// Cillian Reilly
i:7h$("CC";" ")0: inp
2 sum/(3*mod[;3]2+neg(-).;-87+last@)@\:i
2 sum/({x+3*not x}mod[;3]sum 2 1+;3*-88+last@)@\:i

// Attila Vrabecz
i:-88h+7h$("cc";" ")0:`02.txt
sum 1+i[1]+3*mod[;3]2-(-/)i
sum(3 1 2 mod[;3]sum 3 2+i)+3*i 1

// Stephen Taylor
strategy: inp[;0 2]
rounds: string`BX`CY`AZ`AX`BY`CZ`CX`AY`BZ
score: sum 1+ rounds? ::
play:rounds!rounds[;0],'"XZYZYXYXZ"
score each 1 play\strategy  /parts 1 & 2

