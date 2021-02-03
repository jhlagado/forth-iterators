\ this iterator proc has a value and a limit in indexes 0 & 1
\ each iteration inc value by step and then compares value with limit

: range                                 \ start end step -- iter
  -rot over -                           \ step start amount
  >r swap                               \ start step  //  amount
  ['] +                                 \ increment function
  iterate                               \ iter 
  r> 
  take                               \ take <end>
;

: test-range 
  cr cr ." test range" cr
  1 3 1 range 
  dup 0 run 0 assert 1 assert 
  dup 0 run 0 assert 2 assert 
  dup 0 run -1 assert 3 assert 
  0 destroy  
;

