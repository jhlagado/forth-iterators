: expect_then drop drop ." OK" ;
: expect_else ." ERROR: expected " . ." got " . cr ;
: expect 2dup = if expect_then else expect_else then cr ;

: []@ cells + @ ;                  \ adr ofs -- value 
: []! cells + ! ;                  \ value adr ofs --  
: >[] over + 1- do i ! -1 +loop ;  \ n1 n2 ... adr size --
: []> over + swap do i @ loop ;    \ adr size -- n1 n2 ...

10 constant HEAP_SIZE 
4 constant TUPLE_SIZE

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

: >tuple TUPLE_SIZE >[] ;           \ adr

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

: pair! tuck 1 []! ! ;       \ (n n adr -- )
: pair> dup @ swap 1 []@ ;   \ (adr -- n n)
: pair swap here >r , , r> ;       \ (n n -- adr)

: triple! tuck 2 []! tuck 1 []! ! ;         \ (n n n adr -- )
: triple> dup @ swap dup 1 []@ swap 2 []@ ; \ (adr -- n n n)
: triple -rot swap here >r , , , r> ;                   \ (n n n -- adr)

: range_iter                        \ iter -- val done?
dup @ >r                                           
dup dup 1 swap +!                                  
cell+ @ r> dup rot =               
;

: range ['] range_iter triple ;     \ n n -- iter

: foreach                           \ iterator effect  
>r                                  \ store effect
begin
  dup 2 []@                   \ iter_proc
  execute                           \ value done?
  invert                            \ if done terminate
while
  r> dup >r execute                 \ execute effect
repeat
r> drop                             \ rdrop effect
drop                                \ drop last value
drop                                \ drop iter
;

\ gets next state from an iterator
\ this proc is to enable inversion of control 
: iterate                                     \ iterator -- val done
dup 2 []@                               \ iter_proc 
execute                                       \ value done?
;

variable arr
1000 allot 

: dup. dup . . ;
: 2print . . ;                      \ print top 2 items

 : test 
  cr ." testing..." cr cr
  1 2 3 arr 3 >[] cr .s
  arr 3 []> cr 
  .s
  1 2 pair pair>  - -1 expect
  1 2 3 triple triple>  - + 0 expect
  0 3 range range_iter . . range_iter . . range_iter . . drop cr
  0 10 range ['] dup. foreach cr
  0 2 range iterate 2print iterate 2print iterate 2print drop cr
;

test




: hi S" Hi" ;
: hello S" Hello" ;
: there S" there" ;
: add1 1 + ;
: sub1 1 - ;

: getc dup @ >R swap 1 + swap 1 - R> ;
: str_iter ' getc triple ;
: iter_get dup 2 + @ execute ; 

\ : getc over @ >R swap 1 + swap 1 - R> ;
\ : iter dup >R execute over swap R> -rot ;
\ : proxy_get iter ;
\ : piter dup >R execute R> -rot ;

\ hello 
\ ' getc
\ ' proxy_get
\ piter .S