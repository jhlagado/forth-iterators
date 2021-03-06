\ take takes a function and an initial value and returns a sequence
\ in which each value is calculated by passing the previous value to  the function
\ eg. 
\ : integer 0 ['] + take ;

: take-iter                            \ iter -- val done?
  case 
    :init of
      drop                                \ drop arg
      drop                                \ drop adr
      ." :init send take!"
    endof
    :run of 
      drop                                \ drop arg
      dup @                               \ iter iter0
      0 :run send                                 \ iter value0 done0?  
      swap >r >r                          \ iter   //  save value0 done0 
      dup 2 []                            \ iter iter[2] 
      dup @ >r                            \ iter iter[2]  //  save index
      1 swap +!                           \ iter   //    iter[2]++  
      1 [] @                              \ limit 
      r>                                  \ limit index
      <= r> or                            \ DONE  (ie. done? || done0?)
      r> swap                             \ value0 DONE
    endof
    :destroy of
      drop                                \ drop arg
      @ 0 :destroy send
      ." :destroy send take!"
    endof
  endcase 
;

: take 0 ['] take-iter closure ;          \ iter limit -- iter

: test-take 
  cr cr ." test take" cr
  0 1 ['] + iterate 2 take 
  dup 0 :init send
  dup 0 :run send 0 100 assert 0 100 assert 
  dup 0 :run send 0 100 assert 1 100 assert 
  dup 0 :run send -1 100 assert 2 100 assert 
  0 :destroy send 
  cr .s cr
;
