\ take takes a function and an initial value and returns a sequence
\ in which each value is calculated by passing the previous value to  the function
\ eg. 
\ : integer 0 ['] + take ;

: take_iter                            \ iter -- val done?
  case 
    1 of 
      drop                                \ drop arg
      dup @                               \ iter iter0
      0 run                                 \ iter value0 done0?  
      swap >r >r                          \ iter  >>>> save value0 done0 
      dup 2 []                            \ iter iter[2] 
      dup @ >r                            \ iter iter[2] >>>> save index
      1 swap +!                           \ iter  >>>>   iter[2]++  
      1 [] @                              \ limit 
      r>                                  \ limit index
      <= r> or                            \ DONE  (ie. done? || done0?)
      r> swap                             \ value0 DONE
    endof
    2 of
      drop                                \ drop arg
      @ 0 destroy
      ." destroy take!"
    endof
  endcase 
;

: take 0 ['] take_iter closure ;          \ iter limit -- iter

: test_take 
  cr cr ." test take" cr
  0 1 ['] + iterate 2 take 
  dup 0 run 0 assert 0 assert 
  dup 0 run 0 assert 1 assert 
  dup 0 run -1 assert 2 assert 
  0 destroy 
  cr 
;
