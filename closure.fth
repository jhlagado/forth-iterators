\ depends on heap4 (which needs to be initialized first)

\ a closure is a tuple4 which has a ptr to a procedure in
\ its last index (TUPLE4-LAST). Normally a closure is
\ executed by passing its address on the stack, an arg and a signal
\ a signal can be 0 = :init, 1 = :run, 2 = :destroy
\ and calling send
\ the procedure must deal with all three cases or by default pop the
\ address and arg from the stack

0 constant :init
1 constant :run
2 constant :destroy

\ new closure                           \ n1 n2 n3 proc -- adr
: closure  
  heap4-isfull
    abort" Cannot create closure"
  heap4-new                           
;

\ send a signal to closure              \ adr arg type
: send
  >r                                    \ adr arg  //  save type
  over [last] @                         \ adr arg proc
  r> swap                               \ adr arg type proc 
  execute
; 

: test-closure-proc 
  case 
    :init of
      drop                                \ drop arg
      drop                                \ drop adr
      ." init closure!"
    endof
    :run of 
      drop
      tuple4> drop                        \ n n n
      3 100 assert 2 100 assert 1 100 assert                              
    endof
    :destroy of
      drop                                \ drop arg
      drop                                \ drop adr
      ." destroy closure!"
    endof
  endcase
;

: test-closure 
  100 heap4-init 
  cr cr ." test closure" cr
  1 2 3 ['] test-closure-proc closure
  dup 0 :init send 
  dup 0 :run send 
  0 :destroy send
  cr .s cr
;
