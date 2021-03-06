\ a source of numbers all the same

: constant-proc 
  case 
    :start of
      drop                             	\ drop sink
		  drop                              \ drop adr
      ." :start rc!"
    const instance: FromConstantInstance = {
        ...state,
        sink,
        vars: {}
    }
    const tb = closure(instance, fromConstantTB);
    sink(Mode.init, tb);


    endof
    drop                              \ drop arg
    drop                              \ drop adr
  endcase
;

: test-constant-creator                 \ n -- 
  0 0 0 closure                        \ allocates the tuple
  ['] test-rc-proc                      \ pushes the proc
  swap
;

: test-rc
  cr cr ." test constant" cr
  10 rc-init 

  1000 test-rc-creator
  rc+

  to-rc @ 1 100 assert

	dup 0 :start send 
	to-rc @ 1 200 assert

	dup 0 :run send 
	to-rc @ 1 300 assert 

	dup 0 :stop send
	dup @ to-rc c@ 0 400 assert 
	drop

  rc-
	to-rc @ 0 500 assert drop

  cr .s cr
;
