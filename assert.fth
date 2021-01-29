: assert_then drop drop ." OK" ;
: assert_else ." ERROR: asserted " . ." got " . cr abort ;
: assert 2dup = if assert_then else assert_else then cr ;

\ see: simple-tester 
\ http://www.euroforth.org/ef19/papers/hoffmanna.pdf

\ utility words
\ report the test number to a numeric output device
: T.
 . \ for gforth testing
;

\ halt the system
: halt
 quit \ for gforth testing
;

\ compute h1 by hashing x1 and h0
: hash2 ( x1 h0 -- h1 )
 swap 1+ xor
;

\ hash n items from the stack and return the hash code
: hash-n ( x1 x2 ... xn n -- h )
 0 >R
 BEGIN
 dup 0 >
 WHILE
 swap R> hash2 >R
 1-
 REPEAT
 drop R>
;

variable Tcount \ the current test number
variable Tdepth \ saved stack depth

\ start testing
: Tstart
 0 Tcount !
;

\ start a unit test
: T{ ( -- )
 Tcount @ 1+ dup T. Tcount !
 depth Tdepth !
;

\ finish a unit test,
: }T ( y1 y2 ... yn -- hy )
 depth Tdepth @ - ( y1 y2 ... yn Ny )
 hash-n ( hy )
 depth Tdepth ! ( hy )
;

\ compare actual output with expected output
: == ( hy x1 x2 ... xn -- )
 depth Tdepth @ - ( hy x1 x2 .. xn Nx )
 hash-n ( hy hx )
 = 0= IF halt THEN
;

\ signal end of testing
: Tend ( -- )
 65535 ( 0xFFFF) T.
;