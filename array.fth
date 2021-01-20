: []@ cells + @ ;                  ( adr ofs -- value )
: []! cells + ! ;                  ( value adr ofs -- ) 
: >[] over + 1- do i ! -1 +loop ;  ( n1 n2 ... adr size -- )
: []> over + swap do i @ loop ;    ( adr size -- n1 n2 ...)
