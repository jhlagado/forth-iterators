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

variable arr
1000 allot 

: test_array 
  cr ." test array" cr
  1 2 3 
  arr 3 >[] 
  arr 3 []>  
  - - 2 assert
;
