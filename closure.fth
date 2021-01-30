\ depends on heap4 (which needs to be initialized first)

\ a closure is a tuple4 which has a ptr to a procedure in
\ its last index (TUPLE4_LAST). Normally a closure is
\ executed by passing its address on the stack, an arg and a signal
\ a signal can be 0 = INIT, 1 = RUN, 2 = DESTROY
\ and calling send
\ the procedure must deal with all three cases or by default pop the
\ address and arg from the stack

\ new closure                           \ n1 n2 n3 proc -- adr
: closure  
  heap4_isfull
    abort" Cannot create closure"
  heap4_new tuple4                           
;

\ send a signal to closure              \ adr arg type
: send
  >r                                    \ adr arg >>>> save type
  over [last] @                         \ adr arg proc
  r> swap                               \ adr arg type proc 
  execute
; 

\ init a closure                        \ adr arg
: init 0 send ; 

\ run a closure                         \ adr arg
: run 1 send ; 

\ destroys a closure                    \ adr arg
: destroy
  over >r                               \ adr arg
  2 send
  r> heap4_free
;  

: test_proc 
  case 
    0 of
      drop                                \ drop arg
      drop                                \ drop adr
      ." init closure!"
    endof
    1 of 
      drop
      tuple4> drop                        \ n n n
      3 assert 2 assert 1 assert                              
    endof
    2 of
      drop                                \ drop arg
      drop                                \ drop adr
      ." destroy closure!"
    endof
  endcase
;

: test_closure 
  100 heap4_init 
  cr cr ." test closure" cr
  1 2 3 ['] test_proc closure
  dup 0 init 
  dup 0 run 
  0 destroy
  cr
;
