\ this iterator proc has a value and a limit in indexes 0 & 1
\ each iteration inc value by 1 and then compares value with limit
: range_iter                            \ iter -- val done?
  dup @ >r                              \ iter  >>>>   save value   
  dup dup                               \ iter iter->value 
  1 swap +!                             \ iter  >>>>   iter->value + 1  
  cell+ @                               \ limit 
  r>                                    \ limit value
  dup rot                               \ value value limit
  =                                     \ value done?
;

: range 0 ['] range_iter here tuple ;   \ n n -- iter

: test_range 
  cr ." test range" cr
  0 2 range range_iter . . range_iter . . range_iter . . drop cr
;

