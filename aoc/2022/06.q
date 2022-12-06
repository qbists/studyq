s:raze read0`:06.txt;
// Next until count of distinct first 4 characters is 4
// Original string count - Next string count + 4
f:{c:count x; cn:count trim (next/) [{y<>count distinct y$x}[;y];x]; y+c-cn};

// Part 1
f[s;4]

// Part 2
f[s;14]
