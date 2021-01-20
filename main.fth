include tester.fth
include array.fth
include tuple.fth
include heap.fth
include pair.fth
include triple.fth
include range.fth
include foreach.fth
include iterate.fth

variable arr
1000 allot 
: test_array 
  ." test array" cr cr
  1 2 3 arr 3 >[] cr .s
  arr 3 []> cr 
  .s cr
;

: test_pair 
  ." test pair" cr cr
  1 2 pair pair>  - -1 expect
;

: test_triple 
  ." test triple" cr cr
  1 2 3 triple triple>  - + 0 expect
;

: dup. dup . . ;
: 2print . . ;                      \ print top 2 items
: test_range 
  ." test range" cr cr
  0 3 range range_iter . . range_iter . . range_iter . . drop cr
  0 10 range ['] dup. foreach cr
  0 2 range iterate 2print iterate 2print iterate 2print drop cr
;

cr

test_array 
test_pair
test_triple
test_range

cr cr cr cr cr
