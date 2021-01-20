\ depends on tuple.fth

10 constant HEAP_SIZE 

0 value heap_start
0 value heap_end
0 value heap_ptr
0 value free_ptr

: theap_init 
  here to heap_start
  here to heap_ptr
  HEAP_SIZE TUPLE_SIZE * allot
  here to heap_end
;

: theap_new                         \ n n n -- adr
  free_ptr if                       \ if free_ptr is not NULL
    free_ptr dup                    \ save old free_ptr
    @ to free_ptr                   \ get ptr in tuple index 0
                                    \ and store in free_ptr
                                    \ and return old heap_ptr
  else
    heap_ptr dup                    \ save old heap_ptr
    cell TUPLE_SIZE * + to heap_ptr \ increase heaptr
                                    \ and return old heap_ptr
  then
  >r
  >[]                            \ initialize tuple from stack
  r>
;

: theap_free 
;
