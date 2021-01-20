include tester.fth
include array.fth
include theap.fth
include pair.fth
include triple.fth
include range.fth

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