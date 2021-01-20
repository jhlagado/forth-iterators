include tester.fth
include array.fth
include theap.fth
include pair.fth
include triple.fth
include range.fth
include foreach.fth
include iterate.fth

variable arr
1000 allot 

: dup. dup . . ;
: 2print . . ;                      \ print top 2 items

: test 
  cr ." testing..." cr cr
  1 2 3 arr 3 >[] cr .s
  arr 3 []> cr 
  .s
  1 2 pair pair>  - -1 expect
  1 2 3 triple triple>  - + 0 expect
  0 3 range range_iter . . range_iter . . range_iter . . drop cr
  0 10 range ['] dup. foreach cr
  0 2 range iterate 2print iterate 2print iterate 2print drop cr
;

test cr cr cr cr cr
