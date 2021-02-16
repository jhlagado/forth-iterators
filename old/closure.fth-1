\ depends on heap4 (which needs to be initialized first)

\ a closure is a pair of stack items: an xt ptr and a tuple4 
\ Normally a closure executed calling send with a mode and an arg  
\ see send (xt tuple arg mode -- )
\ a mode can be 0 = :start, 1 = :run, 2 = :stop
\ the procedure must deal with all three cases or by default pop the
\ address and arg from the stack

0 constant :start
1 constant :run
2 constant :stop

\ new closure                           \ proc n1 n2 n3 n4 -- proc adr
: closure  
  heap4-isfull
    abort" Cannot create closure"
  heap4-new                           
;

\ send a signal to closure              \ proc adr arg type
: send2
  3 pick                                \ proc adr arg type proc
  execute                               \ proc adr
; 

: test-closure-proc 

  case 
    :start of
      drop                              \ drop arg
      ." init closure!"
    endof
    :run of 
      drop                              \ drop arg
      ." run closure!"
      dup
      tuple4>                           \ n n n n
      4 100 assert 
      3 101 assert 
      2 102 assert 
      1 103 assert                              
    endof
    :stop of
      drop                              \ drop arg
      ." destroy closure!"
    endof
  endcase
  drop                                  \ drop adr
  drop                                  \ drop proc
;

: test-closure 
  100 heap4-init 
  cr cr ." test closure" cr

  ['] test-closure-proc
  1 2 3 4 
  closure

  2dup  0   :start send2 
  2dup  0   :run send2 
        0   :stop send2
  cr .s cr
;
