\ depends on heap4 (which needs to be initialized first)

\ a closure is a tuple4 which has a ptr to a procedure in
\ its last index (TUPLE4_LAST). Normally a closure is
\ executed by passing its address on the stack and calling run
\ the run task consumes the adr of the closure

\ a closure may also be run a destroy task, where the procedure
\ is executed with a 2 on the top of stack
\ the destroy must not consume the adr of the closure 
\ but instead pass it back to destroy

\ new closure                           \ n1 n2 n3 proc -- adr
: closure  
  heap4_isfull
    abort" Cannot create closure"
  heap4_new tuple4                           
;

\ init a closure                        \ adr arg
: init
  over [last] @                         \ adr arg proc
  0 swap                                \ adr arg 0 proc 
  execute
; 

\ run a closure                         \ adr arg
: run
  over [last] @                         \ adr arg proc
  1 swap                                \ adr arg 1 proc 
  execute
; 

\ destroys a closure                    \ adr arg
: destroy
  over >r                               \ adr arg
  over [last] @                         \ adr arg proc
  2 swap                                \ adr arg 0 proc
  execute                               
  r> heap4_free
;  

: test_proc 
  case 
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
  dup 
  0 run 
  0 destroy
  cr
;
