( iterator effect -- )
: foreach                             
>r                                      \ store effect
begin
  iterate                               \ value done?
  invert                                \ if done terminate
while
  r> dup >r execute                     \ execute effect
repeat
r> drop                                 \ drop the effect
drop                                    \ drop last value
drop                                    \ drop iter
;

: dup. dup . . ;                        \ example effect

: test_foreach 
  cr ." test foreach" cr
  0 10 range ['] dup. foreach cr
;

