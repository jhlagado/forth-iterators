4 constant TUPLE_SIZE
TUPLE_SIZE cells constant TUPLE_CELLS

: >tuple TUPLE_SIZE >[] ;           \ adr
: tuple> TUPLE_SIZE []> ;           \ adr -- n*
: tuple here dup >r >tuple r> ;     \ n* -- adr
