: range_iter                        \ iter -- val done?
dup @ >r                                           
dup dup 1 swap +!                                  
cell+ @ r> dup rot =               
;

: range ['] range_iter triple ;     \ n n -- iter

: test_range 
  cr ." test range" cr
  0 2 range range_iter . . range_iter . . range_iter . . drop cr
;

