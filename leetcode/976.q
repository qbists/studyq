ex1:2 1 2                 / LeetCode example 1: triangle
ex2:1 2 1                 / LeetCode example 2: not
ex3:8 1 9 5 4 6 6 1 8 5   / short test
ex4:10000?1000000         / per LeetCode constraints

/ Cillian Reilly
c0:{sum w first where{x<y+z}./:w:distinct 2_{1_x,y}\[3#0;]desc{raze value[x]#'key x}3&count each group x}
c1:{(r;0)0<type r:(2<count::){(1_x;sum s){x<y+z}. s:3#x}/desc x}

/ George Berkeley
g2:{[nums]  
  perim:{[i;ns](0;sum s){x<y+z}. s:3#i _ns}.;
  s0:(0;desc nums;neg[2]+count nums;0);
  :last {[s](s[0]<s[2]) and s[3]=0}{[s;p](s[0]+1;s[1];s[2];p 2#s)}[;perim]/s0}

/ Stephen Taylor
s0:sum{$[x[0]<sum x 1 2;3#x;.z.s 1_ x]}desc@                        / recursion

s1:{i:til 3; 
  while[(not all null x i)and(x i 0)>=sum x i 1 2; i+:1]; 
  sum x i } desc@                                                   / while 1

s2:sum .[@] {({{x[0]>=sum x 1 2}x y}.) @[;1;1+]/x} (;til 3) desc@   / while 2
