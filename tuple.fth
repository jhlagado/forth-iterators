4 constant TUPLE_SIZE

: >tuple TUPLE_SIZE >[] ;           \ adr
: tuple> TUPLE_SIZE []> ;           \ adr -- n*
: tuple here dup >r >tuple r> ;     \ n* -- adr
