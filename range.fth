\ this iterator proc has a value and a limit in indexes 0 & 1
\ each iteration inc value by step and then compares value with limit

: range                                 \ start end step -- iter
  -rot over -                           \ step start amount
  >r swap                               \ start step >>>> amount
  ['] +                                 \ increment function
  iterate                               \ iter 
  r> 
  take                               \ take <end>
;

: test_range 
  cr ." test range" cr
  1 3 1 range 
  dup run . . 
  dup run . . 
  dup run . . 
  destroy  
;

