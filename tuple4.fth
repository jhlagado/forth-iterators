\ a tuple4 is an array of fixed size

4 constant TUPLE4-SIZE
TUPLE4-SIZE cells constant TUPLE4-CELLS
TUPLE4-SIZE 1 - constant TUPLE4-LAST

: >tuple4 TUPLE4-SIZE >[] ;               \ n n n n adr -- 
: tuple4> TUPLE4-SIZE []> ;               \ adr -- n n n n
: tuple4 dup >r >tuple4 r> ;              \ n n n n adr -- adr

: [last] TUPLE4-LAST [] ;                 \ adr -- n

: test-tuple 
  cr cr ." test tuple4" cr
  0 1 2 3 here tuple4 
  tuple4>  
  - + + 0 100 assert

;