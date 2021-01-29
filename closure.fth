\ depends on heap4 (which needs to be initialized first)

\ a closure is a tuple4 which has a ptr to a procedure in
\ its last index (TUPLE4_LAST). Normally a closure is
\ executed by passing its address on the stack and calling run
\ the run task consumes the adr of the closure

\ a closure may also be run a destroy task, where the procedure
\ is executed with a 0 on the top of stack
\ the destroy must not consume the adr of the closure 
\ but instead pass it back to destroy

\ new closure                           \ n1 n2 n3 proc -- adr
: closure  
  heap4_isfull
    abort" Cannot create closure"
  heap4_new tuple4                           
;

\ run a closure                         \ adr
: run
  dup [last] @                          \ adr proc
  1 swap                                \ adr 1 proc 
  execute
;  

\ destroys a closure                    \ adr
: destroy
  dup                                   \ adr adr
  dup [last] @                          \ adr adr proc
  2 swap                                \ adr adr 0 proc
  execute                               \ adr
  heap4_free
;  

: test_proc 
  if 
    tuple4> drop                        \ n n n
    . . .                               
  else
    drop                                \ drop the adr
    ." destroy!"
  then 
;

: test_closure 
  cr ." test closure" cr
  1 2 3 ['] test_proc closure
  dup run destroy 
  cr
;
