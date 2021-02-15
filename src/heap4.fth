\ depends on tuple4
\ this heap4 is for dynamically allocating tuple4 objects

0 constant NULL

0 value heap4-start
0 value heap4-end
0 value heap4-ptr
0 value free-ptr

\ allot a new heap4 and_init ptrs        ( size -- ) 
: heap4-init                             \ size is number of tuples
  TUPLE4-SIZE * new[]                    \ array capacity * tuple4 size
  dup to heap4-start                     \ adr  
  to heap4-ptr                           \ heap4 ptr to start
  here to heap4-end
  NULL to free-ptr
;

\ checks if heap4 has free space         \ ( -- flag) 
: heap4-isfull
  free-ptr if                       
    false                               \ free list is not empty
  else
    heap4-end heap4-ptr <=                \ check if room left on heap4
  then
;

\ allocate a tuple4 from heap4            ( n1 n2 n3 n4 -- adr )
: heap4-new                          
  heap4-isfull 
    abort" Out of heap4 space"
  free-ptr if                           \ if free list is not empty
    free-ptr dup                        \ free-ptr free-ptr
    [last] @ to free-ptr                \ free-ptr[last] -> free-ptr 
  else
    heap4-ptr dup                       \ heap4-ptr heap4-ptr
    TUPLE4-CELLS +                      \ heap4-ptr heap4-ptr+tuple4
    to heap4-ptr                        \ -> heap4-ptr
  then
  tuple4
;

\ free tuple4, add to free list          ( adr -- )
: heap4-free                          
  dup                                   \ adr adr
  free-ptr swap [last] !                \ adr  //  free-ptr -> adr[last]
  to free-ptr                           \  //  adr -> free-ptr
;

\ detect a heap ptr
: heap4-is-ptr                          \ adr -- bool
    dup heap4-start >=                  \ adr bool
    over heap4-end <=                   \ adr bool bool
    and                                 \ adr bool
    swap 15 and                         \ bool bool                  // mask bottom 4 bits
    and                                 \ bool
;

0  value t1
0  value t2
0  value t3
0  value t4
: test-heap4 
  cr cr ." test heap4" cr
  2 heap4-init 
  heap4-end heap4-start - 2 TUPLE4-CELLS * 100 assert

  heap4-isfull false 100 assert

  0 0 0 0 heap4-new to t1
  heap4-ptr heap4-start - TUPLE4-CELLS 100 assert

  heap4-isfull false 100 assert

  0 0 0 0 heap4-new to t2
  heap4-isfull true 100 assert

  t1 heap4-free
  heap4-isfull false 100 assert

  0 0 0 0 heap4-new to t3
  heap4-isfull true 100 assert

  t1 t3 = true 100 assert

  t2 heap4-free
  heap4-isfull false 100 assert

  0 0 0 0 heap4-new to t4
  heap4-isfull true 100 assert

  t2 t4 = true 100 assert
  cr .s cr

;

