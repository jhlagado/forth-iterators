: >pair 2 >[] ;               \ n n adr -- 
: pair> 2 []> ;               \ adr -- n n
: pair here dup >r >pair r> ; \ n n -- adr

: test_pair 
  cr ." test pair" cr
  1 2 pair pair>  - -1 assert
;
