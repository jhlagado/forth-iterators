\ depends on tuple4
\ this heap4 is for dynamically allocating tuple4 objects

0 constant NULL

0 value heap4_start
0 value heap4_end
0 value heap4_ptr
0 value free_ptr

\ allot a new heap4 and init ptrs        ( size -- ) 
: heap4_init                             \ size is number of tuples
  TUPLE4_SIZE * new[]                       \ array capacity * tuple4 size
  dup to heap4_start                     \ adr  
  to heap4_ptr                           \ heap4 ptr to start
  here to heap4_end
  NULL to free_ptr
;

\ checks if heap4 has free space         \ ( -- flag) 
: heap4_isfull
  free_ptr if                       
    false                               \ free list is not empty
  else
    heap4_end heap4_ptr <=                \ check if room left on heap4
  then
;

\ allocate a tuple4 from heap4            ( -- adr )
: heap4_new                          
  heap4_isfull 
    abort" Out of heap4 space"
  free_ptr if                           \ if free list is not empty
    free_ptr dup                        \ free_ptr free_ptr
    @ to free_ptr                       \ free_ptr[0] -> free_ptr 
  else
    heap4_ptr dup                        \ heap4_ptr heap4_ptr
    TUPLE4_CELLS +                       \ heap4_ptr heap4_ptr+tuple4
    to heap4_ptr                         \ -> heap4_ptr
  then
;

\ free tuple4, add to free list          ( adr -- )
: heap4_free                          
  dup                                   \ adr adr
  free_ptr swap !                       \ adr >>>> free_ptr -> adr[0]
  to free_ptr                           \ >>>> adr -> free_ptr
;

0  value t1
0  value t2
0  value t3
0  value t4
: test_heap4 
  cr cr ." test heap4" cr
  2 heap4_init 
  heap4_end heap4_start - 2 TUPLE4_CELLS * assert
  heap4_isfull false assert
  0 0 0 0 heap4_new tuple4 to t1
  heap4_ptr heap4_start - TUPLE4_CELLS assert
  heap4_isfull false assert
  0 0 0 0 heap4_new tuple4 to t2
  heap4_isfull true assert
  t1 heap4_free
  heap4_isfull false assert
  0 0 0 0 heap4_new tuple4 to t3
  heap4_isfull true assert
  t1 t3 = true assert
  t2 heap4_free
  heap4_isfull false assert
  0 0 0 0 heap4_new tuple4 to t4
  heap4_isfull true assert
  t2 t4 = true assert
;

