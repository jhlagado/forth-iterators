\ depends on iterate
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
  dup 0 :run send 0 100 assert 1 100 assert 
  dup 0 :run send 0 100 assert 2 100 assert 
  dup 0 :run send -1 100 assert 3 100 assert 
  0 :destroy send  
  cr .s cr
;

