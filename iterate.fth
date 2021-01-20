\ gets next state from an iterator
\ this proc is to enable inversion of control 

: iterate                              \ iterator -- val done
dup 2 []@                              \ iter_proc 
execute                                \ value done?
;

: test_iterate 
  cr ." test iterate" cr
  0 2 range iterate . . iterate . . iterate . . drop cr
;
