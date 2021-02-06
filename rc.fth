\ refence counting 
\ this library augments the heap4 references with a count value so that
\ deallocation can occur if this value falls to 0. This is meant to work in
\ concert with closures which are in control of their own life cycles and 
\ that of their child references. 

\ initialize the heap via this rc-init
\ when creating a new tuple (or closure) or assigning a value to variable or tuple
\ it is the responsibility of the mutator to change the rc
\ it is the responsibility of the creator of a data item to increase the rc
\ it is the responsibility of the :destroy case to reduce the rc 

0 value rc-start
0 value rc-end

\ TODO: replace with inlined words ;
: c+!                                   \ n adr --
  swap over                             \ adr n adr
  c@                                    \ adr n c1
  + swap                                \ c2 adr
  c!                                     \ 
;

\ allot a new >rc array                   size --  
: rc-init                              
  dup heap4-init												\ allocate a heap of given capacity
	new[]                                 \ allocate a >rc array matching capacity 
  to rc-start                          	\ save start adr 
  here to rc-end												\ save end adr
	rc-end rc-start do 0 i ! loop					\ initalize to zeroes
;

\ convert ref address to rc address
: >rc 					      								  \ adr -- rc-adr
	heap4-start -													\ delta
	4 rshift															\ todo: divide by 16
	rc-start +
;

: rc+																		\ adr -- adr									// inc ref count
	dup >rc 														  \ adr adr-rc
  dup c@                                \ adr adr-rc c1
  1 +                                   \ adr adr-rc c+1
  swap c!                               \ adr
;

\ print adr and its reference count
: .ref                                  \ adr -- adr
  dup cr . dup >rc c@ ." ( " . ." ) "
;

: rc-																		\ adr -- adr									// dec ref count
	dup >rc 														  \ adr adr-rc
  dup c@  
  case
    0 of 
      over .ref
      abort" ref count already at 0!"
    endof
    1 of 
      over .ref ." deallocating " cr drop
      over heap4-free
    endof
  endcase
  dup c@                                \ adr adr-rc c1
  1 -                                   \ adr adr-rc c2
  swap c!                               \ adr
;

: test-rc-proc1 
  case 
    :init of
      drop                             	\ drop arg
		  drop                              \ drop adr
      ." :init rc!"
    endof
    :run of 
      drop
      dup tuple4> drop                	\ n n n
      3 100 assert 2 100 assert drop   
			drop                           
    endof
    :destroy of
      drop                              \ drop arg
			dup @ rc- drop                    \ rc- tuple
			rc-                               \ rc- state 
			drop                              \ drop adr
      ." :destroy closure!"
    endof
  endcase
;

: test-rc
  cr cr ." test ref count" cr
  10 rc-init 

  10 20 30 40 heap4-new rc+ .ref ." allocate tuple " cr
	2 3 ['] test-rc-proc1 
	closure rc+ .ref ." allocate closure " cr

  dup >rc @ 1 100 assert

	dup 0 :init send 
	dup >rc @ 1 200 assert

	dup 0 :run send 
	dup >rc @ 1 300 assert 

	dup 0 :destroy send
	dup @
  dup >rc @ 0 400 assert 
	drop
	
	dup >rc @ 0 500 assert drop

  cr .s cr
;
