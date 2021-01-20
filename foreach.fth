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

: dup. dup . . ;

: test_foreach 
  cr ." test foreach" cr
  0 10 range ['] dup. foreach cr
;

