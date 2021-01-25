\ this iterator proc has a value and a limit in indexes 0 & 1
\ each iteration inc value by step and then compares value with limit

: range                                 \ start end step -- iter
  swap >r                               \ start inc >>>> save end
  over >r                               \ start inc >>>> save start
  ['] +                                 \ increment function
  iterate                               \ iter 
  r> r> swap - take                     \ take <end>
;

: test_range 
  cr ." test range" cr
  1 2 1 range 
  dup run . . 
  dup run . . 
  dup run . . 
  destroy  
;

