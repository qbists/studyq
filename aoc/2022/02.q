/ https://adventofcode.com/2022/day/2

/ part 1
ldw:3*cut[2;"BXCYAZAXBYCZCXAYBZ"]!til[3]where 3#3 / lose; draw; win
score:ldw+1+"XYZ"?(key ldw)[;1]

strategy: .[;(::;0 2)]read0 `:input/02.txt
sum score strategy

/ part 2
play:key[score]!(key score)[;0],'"XZYZYXYXZ"
sum score play strategy
