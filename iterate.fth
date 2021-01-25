\ iterate takes a function and an initial value and returns a sequence
\ in which each value is calculated by passing the previous value to  the function
\ eg. 
\ : integer 0 ['] + iterate ;

: iterate_iter                            \ iter -- val done?
  case 
    0 of
      drop                                \ drop the adr
      ." destroy iterate!"
    endof
    1 of 
      dup dup                             \ iter iter iter  
      @ dup >r                            \ iter iter value  >>>>   save value   
      swap 1 [] @                         \ iter value func
      execute                             \ iter value'
      swap !
      r> 0                                \ value notdone
    endof
  endcase 
;

: iterate 0 ['] iterate_iter closure ;     \ initial func -- iter

: test_iterate 
  cr ." test iterate" cr
  0 ['] 1+ iterate 
  dup run . . 
  dup run . . 
  dup run . . 
  destroy  
  cr
;
