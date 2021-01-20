: triple! tuck 2 []! tuck 1 []! ! ;         \ (n n n adr -- )
: triple> dup @ swap dup 1 []@ swap 2 []@ ; \ (adr -- n n n)
: triple -rot swap here >r , , , r> ;       \ (n n n -- adr)
