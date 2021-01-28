\ a tuple4 is an array of fixed size

4 constant TUPLE4_SIZE
TUPLE4_SIZE cells constant TUPLE4_CELLS
TUPLE4_SIZE 1 - constant TUPLE4_LAST

: >tuple4 TUPLE4_SIZE >[] ;               \ n n n n adr -- 
: tuple4> TUPLE4_SIZE []> ;               \ adr -- n n n n
: tuple4 dup >r >tuple4 r> ;              \ n n n n adr -- adr

: [last] TUPLE4_LAST [] ;                 \ adr -- n

: test_tuple 
  cr ." test tuple4" cr
  0 1 2 3 here tuple4 
  tuple4>  
  - + + 0 assert
;