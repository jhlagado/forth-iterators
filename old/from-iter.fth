\ state is a closure of the form [vars sink fi.iterator proc]
\ vars is a tuple4 of the form [ completed got1 inloop done ]

: fi.vars ;
: fi.sink 1 [] ;
: fi.iterator 2 [] ;
: fi.completed ;
: fi.got1 1 [] ;
: fi.inloop 2 [] ;
: fi.done 3 [] ;

: fi.iterator-next                      \ state -- value done?
  dup fi.vars @ swap                    \ vars state 
  fi.iterator                           \ vars fi.iterator
  0 :run send                                 \ vars value done?            // :run send fi.iterator
  swap >r                               \ vars done?                  // save value
  dup >r                                \ vars done?                  // save copy done?
  swap fi.done !                        \ --                          // statefi.varsfi.done = done?
  >r >r swap                            \ value done?
;

: fi.sink-destroy                       \ state -- 
  dup fi.sink                           \ state sink 
  0 :destroy send                             \ state                       //  send a 2 to sink
  fi.vars @ fi.inloop                   \ inloop
  false swap !                          \                             //  inloop = false
;

: fi.sink-send                          \ state value done? -- state
  if
    drop                                \ state                       // drop value
    dup fi.sink-destroy                 \ state
  else
    over fi.sink                        \ state value sink
    swap :run send                            \ state                       //  send a 1 and a value to sink
  then
;

: fi.sink-loop                          \ state --
  begin
    dup fi.vars @ fi.inloop @           \ state inloop
  while
    dup fi.vars @                       \ state vars
    dup fi.got1 @ invert                \ state vars !got1
    over fi.completed @                 \ state vars !got1 completed
    or if                               \ state vars                  //  if (!got || completed)
      fi.inloop false swap !            \ state                       //  statefi.varsfi.inloop = false
    else
      fi.got1 false swap !              \ state                       //  statefi.varsfi.got1 = false
      fi.iterator-next                  \ state value done?           //  :run send fi.iterator
      fi.sink-send                      \ state
    then
  repeat
  drop                                  \ drop state
;

: fi.sink-run                           \ state -- 
  dup >r                                \ state                       //  save state
  fi.vars @                             \ vars
  dup fi.got1 true swap !               \ vars                        //  got1 = true
  dup fi.inloop @                       \ vars inloop
  over fi.done @                        \ vars inloop done
  or invert                             \ if !(inloop || done)
  if                                   
    fi.inloop true swap !               \ inloop = true
  then
  r>                                    \ state 
  fi.sink-loop                          \
;

: fi.sink-proc                          \ state arg type -- 
    swap drop                           \ state type
    over fi.vars @ fi.completed @       \ state type completed
    if 
      drop                              \ drop type
      drop                              \ drop state
    else 
      case                              \ state  
        :init of
          drop                          \ --                          //  drop state
        endof
        :run of
          fi.sink-run                  \ --
        endof
        :destroy of
          fi.vars @ 
					fi.completed true ! 				  \ --                        //  completed = true
        endof
      endcase
    then
;    
    
: fi.proc																\ state sink type
		case                                
			:init of													\ state sink
				dup >r  												\															// save sink
			  swap 														\ sink state
				@																\ sink iterator
				false false false false 
				heap4-new       								\ sink iterator vars
				rot															\ vars sink iterator
				['] fi.sink-proc 					  		\ vars sink iterator proc
				closure													\ tb
				r> swap													\ sink tb
			  :init send 											\ --
			endof
			:run of 
        drop                            \ drop sink
        drop                            \ drop state
      endof
			:destroy of 
        drop                            \ drop sink
        drop                            \ drop state
      endof
		endcase
;

: from-iter															\ iterator -- cb
	0 0 ['] fi.proc closure rc+
;
