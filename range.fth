\ this iterator proc has a value and a limit in indexes 0 & 1
\ each iteration inc value by 1 and then compares value with limit

: range_iter                            \ iter -- val done?
  if 
    dup @ >r                            \ iter  >>>>   save value   
    dup                                 \ iter iter[0]  
    1 swap +!                           \ iter  >>>>   iter[0]++  
    1 [] @                              \ limit 
    r> swap over                        \ value limit value
    =                                   \ value done?
  else
    drop                                \ drop the adr
    ." destroy!"
  then 
;

: range 0 ['] range_iter closure ;     \ n n -- iter

: test_range 
  cr ." test range" cr
  0 2 range 
  dup run . . 
  dup run . . 
  dup run . . 
  destroy  
;

