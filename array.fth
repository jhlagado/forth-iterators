( adr ofs -- value )
: []@ cells + @ ;                  

( value adr ofs -- ) 
: []! cells + ! ;                  

( n1 n2 ... adr size -- )
: >[] cells over + cell - do i ! cell negate +loop ;  

( adr size -- n1 n2 ...)
: []> cells over + swap do i @ cell +loop ;    

( n1 n2 ... adr size -- )
: ..[] cells over + cell - do i @ . cell negate +loop ;  
: .[] cells over + swap do i @ . cell +loop ;  


0 value test_arr
: test_array 
  here to test_arr
  1000 allot 
  cr ." test array" cr
  1 2 3 
  test_arr 3 >[] 
  test_arr 3 []>  
  - - 2 assert
;
