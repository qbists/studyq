f:{$[count[x]<3;0;x[0]<sum x 1 2;sum 3#x;.z.s 1_x]} desc@  / SJT
f1:{sum w first where{x<y+z}./:w:distinct 2_{1_x,y}\[3#0;]desc{raze value[x]#'key x}3&count each group x}  / Cillian
f2:{(r;0)0<type r:(2<count::){(1_x;sum s){x<y+z}. s:3#x}/desc x}

sol2:{[nums]  / George
  perim:{[i;ns](0;sum s){x<y+z}. s:3#i _ns}.;
  s0:(0;desc nums;neg[2]+count nums;0);
  :last {[s](s[0]<s[2]) and s[3]=0}{[s;p](s[0]+1;s[1];s[2];p 2#s)}[;perim]/s0}