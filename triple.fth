: >triple 3 >[] ;                 \ n n adr -- 
: triple> 3 []> ;                 \ adr -- n n
: triple here dup >r >triple r> ; \ n n -- adr

: test_triple 
  cr ." test triple" cr
  1 2 3 triple triple>  - + 0 assert
;
