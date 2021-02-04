: map-iter                              \ iter -- val done?
  case 
    0 of
      drop                                \ drop arg
      drop                                \ drop adr
      ." init map!"
    endof
    1 of 
      drop                                \ drop arg
      dup                                 \ iter iter[0]  
      @                                   \ iter iter0
      0 run >r                              \ iter value  //  save done
      swap 1 [] @                         \ value effect
      execute                             \ value1 done
      r>
    endof
    2 of
      drop                                \ drop arg
      @ 0 destroy
      ." destroy map!"
    endof
  endcase 
;

: map 0 ['] map-iter closure ;         \ iter0 effect0 -- iter

: add10 10 + ;                        \ example effect

: test-map 
  cr cr ." test map" cr
  0 2 1 range ['] add10 map 
  dup 0 init
  dup 0 run 0 100 assert 10 100 assert

  dup 0 run 0 100 assert 11 100 assert

  dup 0 run -1 100 assert 12 100 assert

  0 destroy
  cr
;

