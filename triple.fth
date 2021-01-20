( n n n adr -- )
: triple! tuck 2 []! tuck 1 []! ! ;         

( adr -- n n n)
: triple> dup @ swap dup 1 []@ swap 2 []@ ; 

( n n n -- adr)
: triple -rot swap here >r , , , r> ;       
