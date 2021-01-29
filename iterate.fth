\ iterate takes a function and an initial value and returns a sequence
\ in which each value is calculated by passing the previous value to  the function
\ eg. 
\ : integer 0 ['] + iterate ;

: iterate_iter                            \ iter -- val done?
  case 
    2 of
      drop                                \ drop the adr
      ." destroy iterate!"
    endof
    1 of 
      dup @ dup >r swap                   \ value iter >>>> save value   
      dup 1 [] @ swap                     \ value arg iter
      dup 2 [] @ swap                     \ value arg func iter
      >r                                  \ value arg func >>>> save iter
      execute                             \ value'
      r> !                                \ >>>> iter[0] = value'
      r> 0                                \ value notdone
    endof
  endcase 
;

: iterate ['] iterate_iter closure ;     \ initial arg func -- iter

: test_iterate 
  cr ." test iterate" cr
  0 2 ['] + iterate 
  dup run . . 
  dup run . . 
  dup run . . 
  destroy  
  cr
;
