\ depends on heap (which needs to be initialized first)

\ a closure is a tuple which has a ptr to a procedure in
\ its last index (TUPLE_LAST). Normally a closure is
\ executed by passing its address on the stack and calling run
\ the run task consumes the adr of the closure

\ a closure may also be run a destroy task, where the procedure
\ is executed with a 0 on the top of stack
\ the destroy must not consume the adr of the closure 
\ but instead pass it back to destroy

\ new closure                           \ n1 n2 n3 proc -- adr
: closure  
  heap_isfull
    abort" Cannot create closure"
  heap_new tuple                           
;

\ run a closure                         \ adr
: run
  dup [last] @
  execute
;  

\ destroys a closure                    \ adr
: destroy
  dup
  [last] @
  0 swap
  execute 
  heap_free
;  

: test_proc 
  dup if 
    tuple> drop
    . . .
  else
    drop                                \ drop the zero
    ." destroy!"
  then 
;

: test_closure 
  cr ." test closure" cr
  1 2 3 ['] test_proc 
  closure dup
  run destroy cr
;
