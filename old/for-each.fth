: fi.source ;
: fi.operation 1 [] ;

: fe.source-proc                        state arg type
		case                                
			:init of															\ state tb
        swap fe.talkback !
			endof
			:run of															\ state data
        swap fe.operation @             \ data operation
        execute
			endof
			drop                              \ drop sink
      drop                              \ drop state
		endcase
;

: fe.proc
		case                                
			:init of															\ state source
			  swap    												\ source state
        @                               \ source operation
				0
        ['] fe.source-proc 					  	\ source operation 0 proc
				closure													\ tb
			:init send 														\ --
			endof
			drop                              \ drop sink
      drop                              \ drop state
		endcase
;

: for-each								\ operation -- cb
	0 0 ['] fe.proc closure
;

: print-op . ;

: test-for-each 
  cr cr ." test for-each" cr
  
  10 50 10 range from-iter
  ['] print-op for-each
  :run send
  
  cr .s cr
;

