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

\ new closure                             \ proc n1 n2 n3 n4 -- proc adr
: closure  
  heap4-isfull
    abort" Cannot create closure"
  heap4-new                           
;

\ send a signal to closure                \ proc adr arg type
: send2
  3 pick                                     \ proc adr arg type proc
  execute                                 \ proc adr
; 

: test-closure-proc 

  case 
    :init of
      drop                                \ drop arg
      ." init closure!"
    endof
    :run of 
      drop                                \ drop arg
      ." run closure!"
      dup
      tuple4>                             \ n n n n
      4 100 assert 
      3 101 assert 
      2 102 assert 
      1 103 assert                              
    endof
    :destroy of
      drop                                \ drop arg
      ." destroy closure!"
    endof
  endcase
  drop                                \ drop adr
  drop                                \ drop proc
;

: test-closure 
  100 heap4-init 
  cr cr ." test closure" cr

  ['] test-closure-proc
  1 2 3 4 
  closure

  2dup  0   :init send2 
  2dup  0   :run send2 
        0   :destroy send2
  cr .s cr
;
