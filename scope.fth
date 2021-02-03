\ depends on heap4 (which needs to be initialized first)
\ scopes are tuples which are linked together with pointers 
\ in the last index (TUPLE4-LAST). A pointer to the head of 
\ this list is stored in scope-ptr

0 value scope-ptr 

\ link tuple4 to scope 
: link-scope                            \ (adr --)
  dup                                   \ adr adr
  scope-ptr swap [last] !               \ adr        //  adr[last] = scope-ptr
  to scope-ptr                          \            //  scope-ptr = adr
;

\ unlink tuple4 from scope
: unlink-scope  
  scope-ptr dup                         \ save old scope-ptr
  [last] @ to scope-ptr
;

\ allocates a new scope 
: s(abc                                 \ n n n --- adr 
  heap4-isfull
    abort" Cannot create scope"
  scope-ptr heap4-new tuple4              \ adr  //  adr[3] = scope-ptr
  to scope-ptr                          \ scope-ptr = adr
;

\ allocates a new scope 
\ and inits a, b from stack. c with 0
: s(ab 0 s(abc ;                        \ n n -- adr

\ allocates a new scope 
\ and inits a from stack. b, c with 0
: s(a 0 0 s(abc ;                       \ n -- adr

\ allocates a new scope 
\ and inits a, b, c with 0
: s( 0 0 0 s(abc ;                      \ -- adr

: )s  
  unlink-scope
  heap4-free
;

: >a scope-ptr ! ;                      \ ( -- n ) 
: >b scope-ptr 1 [] ! ;
: >c scope-ptr 2 [] ! ;
: a> scope-ptr @ ;                      \ ( n -- )
: b> scope-ptr 1 [] @ ;
: c> scope-ptr 2 [] @ ;

: test-scope-1 s(
  100 >a
  200 >b
  300 >c
  a> b> c> - + 0 assert
)s ;

: test-scope-2 s(ab
  3 >c
  a> b> c> - + 0 assert
)s ;

: test-scope-3a s(abc
  a> b> c> + -
)s ;

: test-scope-3 s(ab
  100 200 300 test-scope-3a
  a> + 
  b> +
  100 assert
)s ;

: test-scope
  cr cr ." test scope" cr
  10 heap4-init 
  test-scope-1
  test-scope-1
  1 2 test-scope-2
  300 200 test-scope-3
;