( iterator effect -- )
: foreach                             
>r                                      \ store effect
begin
  dup run                               \ iter value done?
  invert                                \ if done terminate
while
  r> dup >r execute                     \ execute effect on value
repeat
drop                                    \ drop last value
r> drop                                 \ drop the effect
;

: dup. dup . . ;                        \ example effect

: test_foreach 
  cr ." test foreach" cr
  0 10 range ['] dup. foreach 
  destroy
  cr
;

