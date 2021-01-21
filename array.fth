\ array
\ an array is denoted by either (adr) or (adr size)
\ address ranges are from adr1 to adr2-1  

\ array to address range    ( adr size -- adr1 adr2 )
: >adr_range 
  cells over +               
;    

\ get value from offset     ( adr ofs -- value )
: []@ cells + @ ;                  

\ set value at offset       ( value adr ofs -- ) 
: []! cells + ! ;                  

\ stack items to array      ( n1 n2 ... adr size -- )   
: >[] 
  >adr_range
  cell - 
  do i ! cell negate +loop  \ count down
;  

\ array to stack items      ( adr size -- n1 n2 ...)
: []> 
  >adr_range
  swap do i @ cell +loop 
;    

\ print array               ( adr size -- )
: .[] 
  >adr_range
  swap do i @ . cell +loop  \ print from adr1 to adr2-1
;  

\ Allocate an array         ( size -- adr )
: [] 
  here >r                   \ save here
  cells allot               \ allot size * cell 
  r>                        \ return address of array
;

0 value test_arr
: test_array 
  cr ." test array" cr
  1000 [] to test_arr 
  1 2 3 
  test_arr 3 >[] 
  test_arr 3 []>  
  - - 2 assert
;
