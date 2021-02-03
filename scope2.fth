\ depends on heap4 (which needs to be initialized first)
\ scopes are tuples which are linked together with pointers 
\ in the last index (TUPLE4-LAST). A pointer to the head of 
\ this list is stored in scope-ptr

0 value scopestack-start
0 value scopestack-end
0 value scope-ptr

\ allot a new scopes and init ptrs        ( size -- ) 
: scopestack-init                             \ size is number of tuples
  TUPLE4-SIZE * new[]                    \ array capacity * tuple4 size
  dup to scopestack-start                     \ adr  
  to scope-ptr                           \ heap4 ptr to start
  here to scopestack-end
;

\ checks if scopes has free space         \ ( -- flag) 
: scopestack-isfull
    scopestack-end scope-ptr <=                \ check if room left on heap4
;

: s(                                 \ n n n n --- adr 
  scopestack-isfull
    abort" Cannot create scope"
  scope-ptr >tuple4
  scope-ptr TUPLE4-CELLS +              
  to scope-ptr                          
;

: )s  
  scope-ptr TUPLE4-CELLS -              
  to scope-ptr                          
;

: >a scope-ptr -4 [] ! ;                      \ ( -- n ) 
: >b scope-ptr -3 [] ! ;
: >c scope-ptr -2 [] ! ;
: >d scope-ptr -1 [] ! ;
: a> scope-ptr -4 [] @ ;                      \ ( n -- )
: b> scope-ptr -3 [] @ ;
: c> scope-ptr -2 [] @ ;
: d> scope-ptr -1 [] @ ;

: test-scopestack-1 
  0 0 0 0 s(
    100 >a
    200 >b
    300 >c
    400 >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test-scopestack-2 
  0 0 s(
     3 >c
     4 >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test-scopestack-3a 
  s(
    a> b> c> d> + + +
  )s 
;

: test-scopestack-3 
  0 0 s(
    400 >c
    100 100 100 100 test-scopestack-3a >d
    a> b> c> d> - + - 0 assert
  )s 
;

: test-scope
  cr cr ." test scope" cr
  10 scopestack-init 
  test-scopestack-1
  1 2 test-scopestack-2
  500 500 test-scopestack-3
;