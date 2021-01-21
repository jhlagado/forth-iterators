\ depends on heap (which needs to be initialised first)

0 value frame_ptr 

: scope_begin  
  0 0 0 frame_ptr heap_new

;

: scope_end  
;

: :: : compile frame_ptr-> ;
: ;; compile <-frame_ptr [compile] ; ; immediate

: >a ( n -- ) frame_ptr ! ;
: >b ( n -- ) frame_ptr 2+ ! ;
: >c ( n -- ) frame_ptr 4 + ! ;
: a> ( -- n ) frame_ptr @ ;
: b> ( -- n ) frame_ptr 2+ @ ;
: c> ( -- n ) frame_ptr 4 + @ ;
