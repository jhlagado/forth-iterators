\ array
\ an array is denoted by either (adr) or (adr size)
\ address ranges are from adr1 to adr2-1  

\ array to address range                ( adr size -- adr1 adr2 )
: >adr-range 
  cells over +               
;    

\ get offset adress                     ( adr ofs -- value )
: [] cells + ;                  

\ stack items to array                  ( n1 n2 ... adr size -- )   
: >[] 
  >adr-range
  cell - 
  do i ! cell negate +loop              \ count down
;  

\ array to stack items                  ( adr size -- n1 n2 ...)
: []> 
  >adr-range
  swap do i @ cell +loop 
;    

\ print array                           ( adr size -- )
: .[] 
  >adr-range
  swap do i @ . cell +loop              \ print from adr1 to adr2-1
;  

\ Allocate an array                     ( size -- adr )
: new[] 
  here >r                               \ save here
  cells allot                           \ allot size * cell 
  r>                                    \ return address of array
;

0 value test-arr
: test-array 
  cr cr ." test array" cr
  1000 new[] to test-arr 
  1 2 3 
  test-arr 3 >[] 
  test-arr 3 []>  
  - - 2 assert
;
