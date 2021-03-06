( iterator effect -- )
: foreach                             
  >r                                      \ store effect
  begin
    dup 0 :run send                               \ iter value done?
    invert                                \ if done terminate
  while
    r> dup >r execute                     \ execute effect on value
  repeat
  drop                                    \ drop last value
  r> drop                                 \ drop the effect
;

0 value x 
0 value y 
0 value c 
: dup. dup to x to y c 1+ to c ;                        \ example effect

: test-foreach 
  cr cr ." test foreach" cr
  0 3 1 range ['] dup. foreach
  x 2 100 assert 
  y 2 100 assert 
  c 3 100 assert 
  0 :destroy send
  cr .s cr
;

