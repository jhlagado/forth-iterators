\ -reference counting 
\ this library augments the heap4 references with a count value so that
\ deallocation can occur if this value falls to 0. This is meant to work in
\ concert with closures which are in control of their own life cycles and 
\ that of their child references. 

\ initialize the heap via this rc_init

0 value rc4-start
0 value rc4-end

\ allot a new rc4 array                   size --  
: rc4-init                              
  dup heap4_init												\ allocate a heap of given capacity
	new[]                                 \ allocate a rc4 array matching capacity 
  to rc4-start                          \ save start adr 
  here to rc4-end												\ save end adr
;

: to-rc4						      							\ adr -- radr
	heap4_start -													\ delta
	16 /																	\ todo: use shift right 4 bits
	rc4-start +
;

: rc4+																	\ adr -- adr									// inc ref count
	dup to-rc4														\ adr radr
	1 +!																	\ adr													// sub 1 from ref count
;

: rc4-																	\ adr -- adr									// dec ref count
	dup to-rc4														\ adr radr
	-1 +!																	\ adr													// sub 1 from ref count
;

: get-val                               \ ref -- val    							// ref RC-
	rc4- @
;

: get-ref                               \ ref -- ref         					// ref RC- -ref RC+
	get-val rc4+
;

: set-val                               \ val ref --    							// ref RC-
	rc4- !
;

: set-ref                               \ ref1 ref2 --         				// ref1 RC- ref2 RC-
	swap rc4- swap
	set-val
;

: dup-ref                               \ ref -- ref ref      				// ref RC+
	dup rc4+ 
;

: over-ref                              \ ref val -- ref val ref      // ref RC+
	over rc4+
;

: drop-ref                              \ ref --                      // ref RC-
	rc4- drop
;
