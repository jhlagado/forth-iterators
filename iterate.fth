\ iterate takes a function and an initial value and returns a sequence
\ in which each value is calculated by passing the previous value to  the function
\ eg. 
\ : integer 0 ['] + iterate ;

: iterate-iter                            \ iter -- val done?
  case 
    0 of
      drop                                \ drop arg
      drop                                \ drop adr
      ." init iterate!"
    endof
    1 of 
      drop                                \ drop arg
      dup @ dup >r swap                   \ value iter  //  save value   
      dup 1 [] @ swap                     \ value arg iter
      dup 2 [] @ swap                     \ value arg func iter
      >r                                  \ value arg func  //  save iter
      execute                             \ value'
      r> !                                \  //  iter[0] = value'
      r> 0                                \ value notdone
    endof
    2 of
      drop                                \ drop arg
      drop                                \ drop adr
      ." destroy iterate!"
    endof
  endcase 
;

: iterate ['] iterate-iter closure ;     \ initial arg func -- iter

: test-iterate 
  cr cr ." test iterate" cr
  0 2 ['] + iterate 
  dup 0 run 0 100 assert 0 100 assert 
  dup 0 run 0 100 assert 2 100 assert 
  dup 0 run 0 100 assert 4 100 assert 
  0 destroy  
  cr
;
