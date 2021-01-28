\ depends on heap4 (which needs to be initialized first)
\ scopes are tuples which are linked together with pointers 
\ in the last index (TUPLE4_LAST). A pointer to the head of 
\ this list is stored in scope_ptr

0 value scopestack_start
0 value scopestack_end
0 value scope_ptr

\ allot a new scopes and init ptrs        ( size -- ) 
: scopestack_init                             \ size is number of tuples
  TUPLE4_SIZE * new[]                    \ array capacity * tuple4 size
  dup to scopestack_start                     \ adr  
  to scope_ptr                           \ heap4 ptr to start
  here to scopestack_end
;

\ checks if scopes has free space         \ ( -- flag) 
: scopestack_isfull
    scopestack_end scope_ptr <=                \ check if room left on heap4
;

: s(                                 \ n n n n --- adr 
  scopestack_isfull
    abort" Cannot create scope"
  scope_ptr >tuple4
  scope_ptr TUPLE4_CELLS +              
  to scope_ptr                          
;

: )s  
  scope_ptr TUPLE4_CELLS -              
  to scope_ptr                          
;

: >a scope_ptr -4 [] ! ;                      \ ( -- n ) 
: >b scope_ptr -3 [] ! ;
: >c scope_ptr -2 [] ! ;
: >d scope_ptr -1 [] ! ;
: a> scope_ptr -4 [] @ ;                      \ ( n -- )
: b> scope_ptr -3 [] @ ;
: c> scope_ptr -2 [] @ ;
: d> scope_ptr -1 [] @ ;

: test_scopestack_1 
  0 0 0 0 s(
    100 >a
    200 >b
    300 >c
    400 >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test_scopestack_2 
  0 0 s(
     3 >c
     4 >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test_scopestack_3a 
  s(
    a> b> c> d> + + +
  )s 
;

: test_scopestack_3 
  0 0 s(
    400 >c
    100 100 100 100 test_scopestack_3a >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test_scope
  cr ." test scope" cr
  10 scopestack_init 
  test_scopestack_1
  1 2 test_scopestack_2
  500 500 test_scopestack_3
;