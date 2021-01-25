: map_iter                              \ iter -- val done?
  case 
    0 of
      @ destroy
      ." destroy map!"
    endof
    1 of 
      dup                                 \ iter iter[0]  
      @                                   \ iter iter0
      run >r                              \ iter value >>>> save done
      swap 1 [] @                         \ value effect
      execute                             \ value1 done
      r>
    endof
  endcase 
;

: map 0 ['] map_iter closure ;         \ iter0 effect0 -- iter

: add10 10 + ;                        \ example effect

: test_map 
  cr ." test map" cr
  0 2 range ['] add10 map 
  dup run . .
  dup run . .
  dup run . .
  destroy
  cr
;

