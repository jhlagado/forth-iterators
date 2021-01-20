4 constant TUPLE_SIZE

: >tuple TUPLE_SIZE >[] ;           \ adr
: tuple> TUPLE_SIZE []> ;           \ adr -- n n
: tuple here dup >r >tuple r> ;     \ n n -- adr
