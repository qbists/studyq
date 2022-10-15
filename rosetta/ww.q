/
  Word wheel
  http://rosettacode.org/wiki/Word_wheel
\
ce:count each
lc:ce group@
vocab:"\n"vs .Q.hg "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
v39:{x where(ce x)within 3 9}{x where all each x in .Q.a}vocab

grid:9?.Q.a

solve:{[g;v]                                                   / grid; vocabulary
  i:where(g 4)in'v;                                            /   find words that contain the mid letter
  v i where all each 0<=(lc g)-/:lc each v i }[;v39]           /   select those composable from the grid

bust:{[v]                                                      / vocabulary
  grids:distinct raze(til 9)rotate\:/:v where(ce v)=9;         /   all the grids that matter
  wc:(count solve@)each grids;                                 /   their word counts
  grids where wc=max wc }                                      /   the winners

best:{[v]                                                      / vocabulary
  vlc:lc each v;                                               /   letter counts of vocabulary
  ig:where(ce v)=9;                                            /   find grids (9-letter words)
  igw:where each(all'')0<=(vlc ig)-/:\:vlc;                    /   find words composable from each grid (length ig)
  / igw:where each(all'')0<={x-/:y}[;vlc] peach vlc ig;        /   find words composable from each grid: d9xvoc
  grids:raze(til 9)rotate\:/:v ig;                             /   9 permutations of each grid
  iaz:(.Q.a)!where each .Q.a in'\:v;                           /   find words containing a, b, c etc
  ml:4 rotate'v ig;                                            /   mid letters for each grid
  wc:ce raze igw inter/:'iaz ml;                               /   word counts for grids
  distinct grids where wc=max wc }                             /   grids with most words


