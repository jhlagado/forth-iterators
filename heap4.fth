\ depends on tuple4
\ this heap4 is for dynamically allocating tuple4 objects

0 constant NULL

0 value heap4-start
0 value heap4-end
0 value heap4-ptr
0 value free-ptr

\ allot a new heap4 and init ptrs        ( size -- ) 
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

\ allocate a tuple4 from heap4            ( -- adr )
: heap4-new                          
  heap4-isfull 
    abort" Out of heap4 space"
  free-ptr if                           \ if free list is not empty
    free-ptr dup                        \ free-ptr free-ptr
    @ to free-ptr                       \ free-ptr[0] -> free-ptr 
  else
    heap4-ptr dup                        \ heap4-ptr heap4-ptr
    TUPLE4-CELLS +                       \ heap4-ptr heap4-ptr+tuple4
    to heap4-ptr                         \ -> heap4-ptr
  then
;

\ free tuple4, add to free list          ( adr -- )
: heap4-free                          
  dup                                   \ adr adr
  free-ptr swap !                       \ adr  //  free-ptr -> adr[0]
  to free-ptr                           \  //  adr -> free-ptr
;

\ detect a heap ptr
: heap4-is-ptr                          \ adr -- bool
    dup heap4-start >=                   \ adr bool
    over heap4-end <=                    \ adr bool bool
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
  heap4-end heap4-start - 2 TUPLE4-CELLS * assert
  heap4-isfull false assert
  0 0 0 0 heap4-new tuple4 to t1
  heap4-ptr heap4-start - TUPLE4-CELLS assert
  heap4-isfull false assert
  0 0 0 0 heap4-new tuple4 to t2
  heap4-isfull true assert
  t1 heap4-free
  heap4-isfull false assert
  0 0 0 0 heap4-new tuple4 to t3
  heap4-isfull true assert
  t1 t3 = true assert
  t2 heap4-free
  heap4-isfull false assert
  0 0 0 0 heap4-new tuple4 to t4
  heap4-isfull true assert
  t2 t4 = true assert
;

