
( iterator -- val done )
: iterate                               
  dup [last]@                           \ iter_proc 
  execute                               \ value done?
;

: test_iterate 
  cr ." test iterate" cr
  0 2 range iterate . . iterate . . iterate . . drop cr
;
