\ depends on tuple

0 constant NULL

0 value heap_start
0 value heap_end
0 value heap_ptr
0 value free_ptr

\ allot a new heap and init ptrs    ( size -- ) 
: heap_init                         \ size is number of tuples
  TUPLE_SIZE * []                   \ array capacity * tuple size
  dup to heap_start                 \ adr  
  to heap_ptr                       \ heap ptr to start
  here to heap_end
  NULL to free_ptr
;

\ checks if heap has free space     \ ( -- flag) 
: heap_isfull
  free_ptr if                       
    false                           \ free list is not empty
  else
    heap_end heap_ptr <=            \ check if room left on heap
  then
;

\ allocate a tuple from heap        ( n... -- adr )
: heap_new                          
  heap_isfull 
    abort" Out of heap space"
  free_ptr if                       \ if free list is not empty
    free_ptr dup                    \ free_ptr free_ptr
    @ to free_ptr                   \ free_ptr[0] -> free_ptr 
  else
    heap_ptr dup                    \ heap_ptr heap_ptr
    TUPLE_CELLS +                   \ heap_ptr heap_ptr+tuple
    to heap_ptr                     \ -> heap_ptr
  then
  dup >r                            \ adr >>> save copy
  >tuple                            \ initialize tuple from stack
  r>                                \ adr
;

\ free tuple, add to free list      ( adr -- )
: heap_free                          
  dup                               \ adr adr
  free_ptr swap !                   \ adr >>>> free_ptr -> adr[0]
  to free_ptr                       \ >>>> adr -> free_ptr
;

: test_heap 
  cr ." test heap" cr
  2 heap_init 
  heap_end heap_start - 2 TUPLE_CELLS * assert
  heap_isfull false assert
  0 0 0 0 heap_new
  heap_ptr heap_start - TUPLE_CELLS assert
;

