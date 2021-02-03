\ rerence counting 
\ this library augments the heap4 references with a count value so that
\ deallocation can occur if this value falls to 0. This is meant to work in
\ concert with closures which are in control of their own life cycles and 
\ that of their child references. 

\ initialize the heap via this rc-init

0 value rc-start
0 value rc-end

\ allot a new rc array                   size --  
: rc-init                              
  dup heap4-init												\ allocate a heap of given capacity
	new[]                                 \ allocate a rc array matching capacity 
  to rc-start                          	\ save start adr 
  here to rc-end												\ save end adr
;

: rc						      								  \ adr -- adrr
	heap4-start -													\ delta
	4 rshift															\ todo: divide by 16
	rc-start +
;

: rc-peek 															\ adr -- adr
	dup rc @ 									   					\ 														// print rc value
;

: rc+																		\ adr -- adr									// inc ref count
	dup rc															  \ adr adrr
	1 swap +!																	\ adr													// sub 1 from ref count
;

: rc-																		\ adr -- adr									// dec ref count
	dup rc															  \ adr adrr
	-1 swap +!														\ adr													// sub 1 from ref count
;

: get-val                               \ ref -- val    							// ref RC-
	rc- @
;

: getr                               		\ ref -- ref         					// ref RC- ref RC+
	get-val rc+
;

: set-val                               \ val ref --    							// ref RC-
	rc- !
;

: setr                               		\ ref1 ref2 --         				// ref1 RC- ref2 RC-
	swap rc- swap
	set-val
;

: dupr                               		\ ref -- ref ref      				// ref RC+
	dup rc+ 
;

: overr                              		\ ref val -- ref val ref      // ref RC+
	over rc+
;

: dropr                              		\ ref --                      // ref RC-
	rc- drop
;

\ new ref counted closure               \ n1 n2 n3 proc -- adr
: rc-closure  
  heap4-isfull
    abort" Cannot create closure"
  heap4-new tuple4                           
	rc+
;

: test-rc-proc1 
  case 
    0 of
      drop                             	\ drop arg
			dropr                             \ drop adr
      ." init rc!"
    endof
    1 of 
      drop
      dup tuple4> drop                	\ n n n
      3 assert 2 assert 1 assert   
			dropr                           
    endof
    2 of
      drop                              \ drop arg
			rc-
      dropr                             \ drop adr
      ." destroy closure!"
    endof
  endcase
;

: test-rc
  cr cr ." test ref count" cr
  10 rc-init 
  1 2 3 ['] test-rc-proc1 rc-closure 
	rc-peek 1 assert
	
	dupr 0 init 
	rc-peek 1 assert
  
	dupr 0 run 
	rc-peek 1 assert
	
	dupr 0 destroy
  rc-peek 0 assert
	drop
;