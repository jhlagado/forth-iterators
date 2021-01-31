: fi.source ;
: fi.operation 1 [] ;

: fe.source-proc                        state arg type
		case                                
			0 of															\ state tb
        swap fe.talkback !
			endof
			1 of															\ state data
        swap fe.operation @             \ data operation
        execute
			endof
			drop                              \ drop sink
      drop                              \ drop state
		endcase
;

: fe.proc
		case                                
			0 of															\ state source
			  swap    												\ source state
        @                               \ source operation
				0
        ['] fe.source-proc 					  	\ source operation 0 proc
				closure													\ tb
				init 														\ --
			endof
			drop                              \ drop sink
      drop                              \ drop state
		endcase
;

: for-each															\ operation -- cb
	0 0 ['] fe.proc closure
;

: print-op . ;

: test_for-each 
  cr cr ." test for-each" cr
  
  ['] print-op from-iter
  10 50 10 range
  run
  
  cr
;

