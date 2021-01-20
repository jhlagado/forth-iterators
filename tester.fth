: expect_then drop drop ." OK" ;
: expect_else ." ERROR: expected " . ." got " . cr ;
: expect 2dup = if expect_then else expect_else then cr ;
