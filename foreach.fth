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
