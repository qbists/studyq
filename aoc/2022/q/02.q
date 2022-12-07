/ https://adventofcode.com/2022/day/2

/ ingestion
inp:read0 `:input/02.txt
strategy: inp[;0 2]

/ part 1
rounds: string`BX`CY`AZ`AX`BY`CZ`CX`AY`BZ
/ ldw:3*rounds!til[3]where 3#3 / lose; draw; win
/ score:ldw+1+"XYZ"?(key ldw)[;1]
score: sum 1+ rounds? ::

score strategy

/ part 2
play:rounds!rounds[;0],'"XZYZYXYXZ"
score play strategy

/parts 1 & 2
score each 1 play\strategy


/ András & Nick

i:flip ("CC";" ") 0: `:test/02.txt
k:"ABC" cross "XYZ"
/ part 1
s:k!raze 1 2 3+/:2 rotate[-1]\ 3 6 0
sum s i
/ part 2
s:k!raze 0 3 6+/:2 rotate[1]\ 3 1 2
sum s i