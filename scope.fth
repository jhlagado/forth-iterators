\ depends on heap (which needs to be initialized first)
\ scopes are tuples which are linked together with pointers 
\ in the last index (TUPLE_LAST). A pointer to the head of 
\ this list is stored in scope_ptr

0 value scope_ptr 

\ link tuple to scope 
: link_scope                            \ (adr --)
  dup scope_ptr swap                    \ adr scope_ptr adr
  [last]!                               \ adr >>>> adr[3] = scope_ptr
  to scope_ptr                          \ scope_ptr = adr
;

\ unlink tuple from scope
: unlink_scope  
  scope_ptr dup                         \ save old scope_ptr
  [last]@ to scope_ptr
;

\ allocates a new scope 
: s(abc                                 \ n n n --- adr 
  heap_isfull
    abort" Cannot create scope"
  scope_ptr heap_new tuple              \ adr >>>> adr[3] = scope_ptr
  to scope_ptr                          \ scope_ptr = adr
;

\ allocates a new scope 
\ and inits a, b from stack. c with 0
: s(ab 0 s(abc ;                        \ adr

\ allocates a new scope 
\ and inits a from stack. b, c with 0
: s(a 0 0 s(abc ;                       \ adr

\ allocates a new scope 
\ and inits a, b, c with 0
: s( 0 0 0 s(abc ;                      \ adr

: )s  
  unlink_scope
  heap_free
;

: >a scope_ptr ! ;                      \ ( -- n ) 
: >b scope_ptr 1 []! ;
: >c scope_ptr 2 []! ;
: a> scope_ptr @ ;                      \ ( n -- )
: b> scope_ptr 1 []@ ;
: c> scope_ptr 2 []@ ;

: test_scope_1 s(
  100 >a
  200 >b
  300 >c
  a> b> c> - + 0 assert
)s ;

: test_scope_2 s(ab
  3 >c
  a> b> c> - + 0 assert
)s ;

: test_scope_3a s(abc
  a> b> c> + -
)s ;

: test_scope_3 s(ab
  100 200 300 test_scope_3a
  a> + 
  b> +
  100 assert
)s ;

: test_scope
  cr ." test scope" cr
  10 heap_init 
  test_scope_1
  test_scope_1
  1 2 test_scope_2
  300 200 test_scope_3
;