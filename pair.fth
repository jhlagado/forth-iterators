: pair! tuck 1 []! ! ;       \ (n n adr -- )
: pair> dup @ swap 1 []@ ;   \ (adr -- n n)
: pair swap here >r , , r> ;       \ (n n -- adr)
