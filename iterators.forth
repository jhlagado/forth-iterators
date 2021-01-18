: expect_then drop drop ." OK" ;
: expect_else ." ERROR: expected " . ." got " . cr ;
: expect 2dup = if expect_then else expect_else then cr ;

10 constant HEAP_SIZE 
4 constant TUPLE_SIZE

0 value heap_start
0 value heap_end
0 value heap_ptr
0 value free_ptr

: tuple_get cells + @ ;        \ (adr ofs -- value )
: tuple_set cells + ! ;        \ (value adr ofs -- ) 
: >tuple dup TUPLE_SIZE + do i ! -1 +loop ;

: theap_init 
  here to heap_start
  here to heap_ptr
  THEAP_SIZE TUPLE_SIZE * allot
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
  >tuple                            \ initialize tuple from stack
  r>
;

: theap_free 
;

: pair! tuck 1 tuple_set ! ;       \ (n n adr -- )
: pair> dup @ swap 1 tuple_get ;   \ (adr -- n n)
: pair swap here >r , , r> ;       \ (n n -- adr)

\ test
1 2 pair pair>  - -1 expect

: triple! tuck 2 tuple_set tuck 1 tuple_set ! ;         \ (n n n adr -- )
: triple> dup @ swap dup 1 tuple_get swap 2 tuple_get ; \ (adr -- n n n)
: triple -rot swap here >r , , , r> ;                   \ (n n n -- adr)

\ test
1 2 3 triple triple>  - + 0 expect

: range_iter                        \ iter -- val done?
dup @ >r                                           
dup dup 1 swap +!                                  
cell+ @ r> dup rot =               
;

: range ['] range_iter triple ;     \ n n -- iter

\ test
0 3 range range_iter . . range_iter . . range_iter . . drop cr

: foreach                           \ <iterator> foreach <effect> 
' >r                                \ store effect
begin
  dup 2 tuple_get execute           \ execute iter_proc
  invert                            \ if done terminate
while
  r> dup >r execute                 \ execute effect
repeat
r> drop                             \ rdrop effect
drop                                \ drop last value
drop                                \ drop iter
;

\ test
: dup. dup . . ;
0 10 range foreach dup. cr

\ gets next state from an iterator
\ this proc is to enable inversion of control 
: iterate                                     \ iter -- val done
dup 2 tuple_get                               \ iter iter_proc
execute                                       \ value done?
' execute
;

: 2print . . ;                      \ print top 2 items
0 3 range iterate 2print iterate 2print iterate 2print drop cr



: hi S" Hi" ;
: hello S" Hello" ;
: there S" there" ;
: add1 1 + ;
: sub1 1 - ;

: getc dup @ >R swap 1 + swap 1 - R> ;
: str_iter ' getc triple ;
: iter_get dup 2 + @ execute ; 

\ hello
\ pair



\ : getc over @ >R swap 1 + swap 1 - R> ;
\ : iter dup >R execute over swap R> -rot ;
\ : proxy_get iter ;
\ : piter dup >R execute R> -rot ;

\ hello 
\ ' getc
\ ' proxy_get
\ piter .S
