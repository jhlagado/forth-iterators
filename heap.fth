\ depends on tuple.fth

0 constant NULL
10 constant HEAP_SIZE               \ capacity in tuples

0 value heap_start
0 value heap_end
0 value heap_ptr
0 value free_ptr

: heap_init 
  HEAP_SIZE TUPLE_SIZE * []         \ array capacity * tuple size
  dup to heap_start                 \ adr  
  to heap_ptr                       \ heap ptr to start
  here to heap_end
  NULL to free_ptr
;

: heap_new                          \ n... -- adr
  free_ptr if                       \ if free_ptr is not NULL
    free_ptr dup                    \ save old free_ptr
    @ to free_ptr                   \ get ptr in tuple index 0
                                    \ and store in free_ptr
                                    \ and return old free_ptr
  else
    heap_ptr dup                    \ save old heap_ptr
    TUPLE_SIZE cells + to heap_ptr  \ increase heaptr by tuple size
                                    \ and return old heap_ptr
  then
  >r
  >tuple                            \ initialize tuple from stack
  r>
;

: heap_free 
;
