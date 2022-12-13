// maximum contiguous subarray
// https://leetcode.com/problems/maximum-subarray/

/ exemplary problems
/ https://martin-thoma.com/maximum-subarray-sum/
E0: 11 -5 -5 -2 1 2 3 4 5 0 1 / 16
E1: 9 -5 -5 -2 1 2 -1 4 5 0 1 / 12
E2: -1 -2 -3 -4 -5 / -1
E3: 1#-2 / -2
E4: 1#3 / 3

M9: -10+9000000?20

/ brute force: generate and sum all subarrays
mcs0:{max sum each raze x tcx+neg[tcx]_\:til each 1+tcx:til count x}

/ simple adaptation of Kadane's algorithm
mcs1: max ((0|+)\) @

/ also track current max and actual max
mcs2:{{(y;z)z<0}.(0,2#x 0) {(0|y+x 0;x[1]|0|y+x 0; y|x 2)}/x}

/ https://stackoverflow.com/questions/74508773
mcs3:{max s-mins 0^prev s:sums x}
/ mcs4:{max s-mins 0f,1_prev s:sums x}
/ mcs5:{max s-mins 0,1_prev s:sums x}

examples:(E0;E1;E2;E3;E4)

show (mcs0;mcs1;mcs2;mcs3)@/:\:examples
/ show (mcs0;mcs1;mcs2;mcs3;mcs4;mcs5)@/:\:examples

show (mcs1;mcs2;mcs3)@\:M9
/ show (mcs1;mcs2;mcs3;mcs4;mcs5)@\:M9

show{flip`f`t`s!flip x,'(system raze("ts ";;" M9")@)each string x}`mcs1`mcs2`mcs3
