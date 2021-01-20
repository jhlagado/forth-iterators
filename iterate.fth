\ gets next state from an iterator
\ this proc is to enable inversion of control 

: iterate                              \ iterator -- val done
dup 2 []@                              \ iter_proc 
execute                                \ value done?
;
