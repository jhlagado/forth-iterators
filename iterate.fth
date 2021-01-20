TUPLE_SIZE 1 - constant PROC_INDEX

( iterator -- val done )
: iterate                               
  dup PROC_INDEX []@                     \ iter_proc 
  execute                                \ value done?
;

: test_iterate 
  cr ." test iterate" cr
  0 2 range iterate . . iterate . . iterate . . drop cr
;
