4 constant TUPLE_SIZE
TUPLE_SIZE cells constant TUPLE_CELLS

: >tuple TUPLE_SIZE >[] ;           \ n n n adr -- 
: tuple> TUPLE_SIZE []> ;           \ adr -- n n n

: tuple dup >r >tuple r> ;          \ n n n adr -- adr

: test_tuple 
    cr ." test tuple" cr
    0 1 2 3 here tuple tuple>  - + 0 assert
;