: map-iter                              \ iter -- val done?
  case 
    :init of
      drop                                \ drop arg
      drop                                \ drop adr
      ." :init send map!"
    endof
    :run of 
      drop                                \ drop arg
      dup                                 \ iter iter[0]  
      @                                   \ iter iter0
      0 :run send >r                              \ iter value  //  save done
      swap 1 [] @                         \ value effect
      execute                             \ value1 done
      r>
    endof
    :destroy of
      drop                                \ drop arg
      @ 0 :destroy send
      ." :destroy send map!"
    endof
  endcase 
;

: map 0 ['] map-iter closure ;         \ iter0 effect0 -- iter

: add10 10 + ;                        \ example effect

: test-map 
  cr cr ." test map" cr
  0 2 1 range ['] add10 map 
  dup 0 :init send
  dup 0 :run send 0 100 assert 10 100 assert

  dup 0 :run send 0 100 assert 11 100 assert

  dup 0 :run send -1 100 assert 12 100 assert

  0 :destroy send
  cr .s cr
;

