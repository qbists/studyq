/https://projecteuler.net/problem=11

V:raze M:flip(20#"J";" ")0:`11.txt              / ingest and raze
i:shp#til prd shp:count each 1 first\M 			/ indices into V
nc:shp 1										/ # cols

N:4  											/ # cells to multiply
ri:raze[(N-1)_'i]+\:til N  						/ row indices
ci:raze[(N-1)_i]+\:nc*til N  					/ col indices
tlbr:(raze neg[N]_ neg[N]_'i)+\:(1+nc)*til N 	/ TL-BR diag indices
trbl:(raze neg[N]_ N _'i)+\:(-1+nc)*til N  		/ TR-BL indices

max prd each V ri,ci,tlbr,trbl

