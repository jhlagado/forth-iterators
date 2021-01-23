4 constant TUPLE_SIZE
TUPLE_SIZE cells constant TUPLE_CELLS

: >tuple TUPLE_SIZE >[] ;           \ n* adr -- 
: tuple> TUPLE_SIZE []> ;           \ adr -- n*

: tuple dup >r >tuple r> ;           \ n* adr -- adr

: test_tuple 
    cr ." test tuple" cr
    0 1 2 3 here tuple tuple>  - + 0 assert
;