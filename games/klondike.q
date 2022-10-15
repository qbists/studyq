/ klondike
/ https://en.wikipedia.org/wiki/Klondike_(solitaire)
/ Usage:  see g:deal[]
/         see g:move[g] `9C`TH
/         see g:move[g] `AS
/         see g:move[g] `KC
/         see g:turn g

SUITS:"SHCD"
NUMBERS:"A23456789TJQK"
SYM:`$NUMBERS cross SUITS  			/ card symbols
SYM,:`$("[]";"__")     	  			/ hidden card; empty stack; blank space
HC:52								/ hidden card 
ES:53								/ empty stack
SP:54                               / blank space

NUMBER:1+til[13]where 13#4			/ card numbers
SUIT:52#SUITS             			/ card suits
COLOR:"RB" SUIT in "SC"           	/ card colors
TURN:3                              / # cards to turn

STOCK:0
WASTE:1
FOUNDATION:2+til 4
TABLEAU:6+til 7

ce:count each
le:last each
tc:til count ::

deal:{[]
  g:()!();
  deck:-52?52;
  / columns: stock, waste, 4 foundations, 7 piles
  g[`c]:13#enlist 0#0;
  g[`c;TABLEAU]:(sums til 7)_ 28#deck; / tableau
  g[`x]:le g[`c;TABLEAU]; / exposed
  g[`c;STOCK]:28_ deck;
  g[`s]:0; / score
  g[`p]:0; / # passes
  turn g }

move:{[g;y] / move y (symbol atom or pair)
  if[not 99h~type g; '"not a game"];
  if[not all `c`p`x`pm in key g; '"not a game"];
  if[abs[type y]<>11; '"type"];
  if[(type[y]>0)and 2<>count y; '"length"];
  if[not all b:y in SYM; '"invalid card: "," "sv string y where not b];
  
  cards:SYM?y;
  / map cards to n,f,t
  cl:ce g`c; / column lengths
  f:first where cl>i:g[`c]?'first cards; / from column
  n:cl[f]-i[f]; / # cards to move
  t:$[2=count cards; first where cl>g[`c]?'cards 1;
    $[1=NUMBER first cards; first[FOUNDATION]+SUITS?SUIT first cards; 
      first[TABLEAU]+first where 0=ce g[`c;TABLEAU] ] 
  ];
  if[not(n,f,t)in g`pm; '"invalid move"];
  move_[g;n;f;t] }

move_:{[g;n;f;t]
  / move n cards in g from g[`c;f] to g[`c;t]
  g[`c;t],:neg[n]#g[`c;f];
  g[`c;f]:neg[n]_ g[`c;f];
  let:le g[`c;TABLEAU];
  g[`s]+:5 0@all let in g`x; / turned over tableau card?
  g[`x]:distinct g[`x],let;
  g[`s]+:$[f=WASTE; 5 10@t in FOUNDATION; 
    f in TABLEAU; 0 10@t in FOUNDATION; 
    f in FOUNDATION; -15; 
    0 ]; / score
  rpm g }

rpm:{[g] / record possible moves
  top:{(y,'i-1)where 0<i:ce x y}[g`c]; / positions of top cards
  / moves to foundation from waste or tableau
  fm:{[c;m]
  	cards:c ./:m[;0 1]; / cards to move
  	nof:SYM?`${(NUMBERS NUMBER x),'SUIT x}le c m[;2]; / next cards on foundation
  	m where(cards=nof)or(NUMBER[cards]=1)and SUIT[cards]=SUITS FOUNDATION?m[;2] 
  }[g`c] top[WASTE,TABLEAU] cross FOUNDATION;
  / moves to tableau from waste, foundation or tableau
  xit:raze TABLEAU cross'where each g[`c;TABLEAU]in g`x; / positions exposed in tableau 
  tm:{[c;m]
  	cards:c ./:m[;0 1];
  	tgts:le c m[;2];
  	m where (.[<>;COLOR(cards;tgts)]and 1=.[-]NUMBER(tgts;cards))
  	 or (tgts=0N)and NUMBER[cards]=13
  }[g`c] (top[WASTE,FOUNDATION],xit) cross TABLEAU;
  / # cards to move
  g[`pm]:{(ce[x y[;0]]-y[;1]),'y[;0 2]}[g`c] fm,tm;
  g }

see:{[g] / display game
  / stock, waste, foundations
  top:{((HC;ES)count[x]=0),ES^y}. 0 1 _ le g[`c;STOCK,WASTE,FOUNDATION];
  show (`$string count[g[`c;STOCK]],g`p),'SYM 2 7#(2#top),SP,(2_ top),7#SP;
  / columns
  show SYM {flip x[;til max ce x]}{x,'(0=ce x)#'ES}{[g;c]g[`c;c]|HC*not g[`c;c]in g[`x]}[g] TABLEAU; 
  show 21#"_";
  show "score: ",string g`s; 
  show $[0=count g`pm; "No moves possible";
    {[g;n;f;t] SYM first each neg[n,1]#'g[`c;f,t]}[g;].'g`pm ]; }

turn:{[g;n]
  trn:0=count g[`c;STOCK];
  g[`c;STOCK,WASTE]:g[`c;trn rotate STOCK,WASTE];
  g[`p]+:trn; / # passes 
  move_[g; n&count g[`c;STOCK]; STOCK; WASTE] }[;TURN]

