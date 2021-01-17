: pair! 1 cells + dup -rot ! cell- ! ; \ (n n n adr -- )
: pair> 1 cells + dup @ >r cell- @ r> ; \ (adr -- n n n)
: pair here dup >r 2 cells allot pair! r> ;  \ (n n -- adr)

1 2 pair pair> + 3 = . cr

: triple! 2 cells + dup -rot ! cell- dup -rot ! cell- ! ; \ (n n n adr -- )
: triple> 2 cells + dup @ >r cell- dup @ >r cell- @ r> r> ; \ (adr -- n n n)
: triple here dup >r 3 cells allot triple! r> ;  \ (n n n -- adr)

\ test
1 2 3 triple triple> + + 6 = . cr

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
  dup 2 cells + @ execute           \ execute iter_proc
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
0 10 range foreach dup.

\ gets next state from an iterator
\ this proc is to enable inversion of control 
: iterate                                     \ iter -- val done
dup 2 cells + @                               \ iter iter_proc
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
