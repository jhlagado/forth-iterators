\ refence counting 
\ this library augments the heap4 references with a count value so that
\ deallocation can occur if this value falls to 0. This is meant to work in
\ concert with closures which are in control of their own life cycles and 
\ that of their child references. 

\ initialize the heap via this rc-init
\ when creating a new tuple (or closure) or assigning a value to variable or tuple
\ it is the responsibility of the assigner to increase the rc

0 value rc-start
0 value rc-end

\ allot a new >rc array                   size --  
: rc-init                              
  dup heap4-init												\ allocate a heap of given capacity
	new[]                                 \ allocate a >rc array matching capacity 
  to rc-start                          	\ save start adr 
  here to rc-end												\ save end adr
	rc-end rc-start do 0 i ! loop					\ initalize to zeroes
;

: >rc 					      								  \ adr -- rc-adr
	heap4-start -													\ delta
	4 rshift															\ todo: divide by 16
	rc-start +
;

: rc+																		\ adr -- adr									// inc ref count
	dup >rc 														  \ adr adrr
	1 swap +!														  \ adr													// sub 1 from ref count
;

: rc-																		\ adr -- adr									// dec ref count
	dup >rc 														  \ adr adrr
  heap4-isfull 
    abort" ref count already at 0!"
	-1 swap +!														\ adr													// sub 1 from ref count
;

: test-rc-proc1 
  case 
    0 of
      drop                             	\ drop arg
			rc- drop                          \ drop adr
      ." init rc!"
    endof
    1 of 
      drop
      dup tuple4> drop                	\ n n n
      3 100 assert 2 100 assert drop   
			rc- drop                           
    endof
    2 of
      drop                              \ drop arg
			dup @ rc- drop
			rc-                               \ reduce ref count 
			rc- drop                          \ drop adr
      ." destroy closure!"
    endof
  endcase
;

: test-rc
  cr cr ." test ref count" cr
  10 rc-init 
  10 20 30 40 heap4-new rc+
	2 3 ['] test-rc-proc1 
	
	closure rc+ 
	dup >rc @ 1 100 assert

	dup rc+ 0 init 
	dup >rc @ 1 200 assert

	dup rc+ 0 run 
	dup >rc @ 1 300 assert 

	dup rc+ 0 destroy

	dup @
  dup >rc @ 0 400 assert 
	drop
	
	dup >rc @ 0 500 assert drop
;
