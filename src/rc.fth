\ refence counting 
\ this library augments the heap4 references with a count value so that
\ deallocation can occur if this value falls to 0. This is meant to work in
\ concert with closures which are in control of their own life cycles and 
\ that of their child references. 

\ initialize the heap via this rc-init
\ when creating a new tuple (or closure) or assigning a value to variable or tuple
\ it is the responsibility of the: 
\ creator of the closure to increase the rc
\ creator of the closure to decrease the rc
\ mutating routines to change the rc (assign rc+, remove rc-)
\ :destroy routines to decrease rc of children

0 value rc-start
0 value rc-end

\ TODO: replace with inlined words ;
: c+!                                   \ n adr --
  swap over                             \ adr n adr
  c@                                    \ adr n c1
  + swap                                \ c2 adr
  c!                                     \ 
;

\ allot a new to-rc array                   size --  
: rc-init                              
  dup heap4-init												\ allocate a heap of given capacity
	new[]                                 \ allocate a to-rc array matching capacity 
  to rc-start                          	\ save start adr 
  here to rc-end												\ save end adr
	rc-end rc-start do 0 i ! loop					\ initalize to zeroes
;

\ convert ref address to rc address
: to-rc 					      								\ adr -- adr rc-adr
	dup
  heap4-start -													\ delta
	4 rshift															\ todo: divide by 16
	rc-start +
;

: rc+																		\ adr -- adr									// inc ref count
	to-rc 													    	\ adr adr-rc
  dup c@                                \ adr adr-rc c1
  1 +                                   \ adr adr-rc c+1
  swap c!                               \ adr
;

\ print adr and its reference count
: .ref                                  \ adr -- adr
  dup cr . to-rc c@ ." ( " . ." ) "
;

: rc-																		\ adr -- adr									// dec ref count
	to-rc 														    \ adr adr-rc
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
		  drop                              \ drop proc
      ." :init rc!"
    endof
    :run of 
      drop
      dup tuple4> drop                	\ n n n
      3 100 assert 2 100 assert drop   
			drop                           
		  drop                              \ drop proc
    endof
    :destroy of
      drop                              \ drop arg
			dup @ rc- drop                    \ rc- tuple
			drop                              \ drop adr
		  drop                              \ drop proc
      ." :destroy closure!"
    endof
  endcase
;

: test-rc-creator
  ['] test-rc-proc1 
  10 20 30 40 heap4-new rc+ 
  .ref ." allocate tuple " cr
	2 3 4
	closure 
  .ref ." allocate closure " cr
;

: test-rc
  cr cr ." test ref 2 count" cr
  10 rc-init 

  test-rc-creator
  rc+ 

  to-rc @ 1 100 assert

	2dup 0 :init send2 
	to-rc @ 1 200 assert

	2dup 0 :run send2 
	to-rc @ 1 300 assert 

	2dup 0 :destroy send2
	dup @ to-rc c@ 0 400 assert 
	drop

  rc-
	to-rc @ 0 500 assert drop
  drop

  cr .s cr
;
