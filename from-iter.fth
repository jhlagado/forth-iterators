\ state is a closure of the form [vars sink iterator proc]
\ vars is a tuple4 of the form [ completed got1 inloop done ]
\ TODO use offsets https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Why-explicit-structure-support_003f.html#Why-explicit-structure-support_003f

: .vars ;
: .sink 1 [] ;
: .iterator 2 [] ;
: .completed ;
: .got1 1 [] ;
: .inloop 2 [] ;
: .done 3 [] ;

: fiInteratorNext                       \ state -- value done?
  dup .vars @ swap                      \ vars state 
  .iterator                             \ vars iterator
  0 run                                 \ vars value done?            // run iterator
  swap >r                               \ vars done?                  // save value
  dup >r                                \ vars done?                  // save copy done?
  swap .done !                          \ --                          // state.vars.done = done?
  >r >r swap                            \ value done?
;

: fiSinkDestroy                         \ state -- 
  dup .sink                             \ state sink 
  0 destroy                             \ state                       //  send a 2 to sink
  .vars @ .inloop                       \ inloop
  false swap !                          \                             //  inloop = false
;

: fiSinkSend                            \ state value done? -- state
  if
    drop                                \ state                       // drop value
    dup fiSinkDestroy                   \ state
  else
    over .sink                          \ state value sink
    swap run                            \ state                       //  send a 1 and a value to sink
  then
;

: fiSinkLoop                            \ state --
  begin
    dup .vars @ .inloop @               \ state inloop
  while
    dup .vars @                         \ state vars
    dup .got1 @ invert                  \ state vars !got1
    over .completed @                   \ state vars !got1 completed
    or if                               \ state vars                  //  if (!got || completed)
      .inloop false swap !              \ state                       //  state.vars.inloop = false
    else
      .got1 false swap !                \ state                       //  state.vars.got1 = false
      fiInteratorNext                   \ state value done?           //  run iterator
      fiSinkSend                        \ state
    then
  repeat
  drop                                  \ drop state
;

: fiSinkData                            \ state -- 
  dup >r                                \ state                       //  save state
  .vars @                               \ vars
  dup .got1 true swap !                 \ vars                        //  got1 = true
  dup .inloop @                         \ vars inloop
  over .done @                          \ vars inloop done
  or invert                             \ if !(inloop || done)
  if                                   
    .inloop true swap !                 \ inloop = true
  then
  r>                                    \ state 
  fiSinkLoop                            \
;

: fiSinkProc                            \ state type arg -- 
    drop                                \ state type
    over .vars @ .completed @           \ state type completed
    if 
      drop                              \ drop type
      drop                              \ drop state
    else 
      case                              \ state  
        0 of
          drop                          \ --                          //  drop state
        endof
        1 of
          fiSinkData                    \ --
        endof
        2 of
          .vars @ .completed true !     \ --                        //  completed = true
        endof
      endcase
    then
;    
    
    

: fromIterSinkTB = (state: FromIterState): CB => {
    return { state, proc: fromIterSinkProc };
};

: fromIterProc: Proc = (state, type, sink): void => {
    if (type !== 0) return;
    const state = state as FromIterState;
    state.sink = sink as CB;
    state.vars = { inloop: false, got1: false, completed: false, done: false };
    const tb = fromIterSinkTB(state as FromIterState);
    send(sink as CB, 0, tb);
};

: fromIter = (iterator: any): CB => {
    const state = {
        iterator,
    };
    return {
        state,
        proc: fromIterProc,
    };
};

: forEachSourceProc: Proc = (state, type, data?) => {
    const feState = state as ForEachState;
    if (type === 0) feState.talkback = data as CB;
    if (type === 1) feState.operation(data as string);
    if ((type === 1 || type === 0) && feState.talkback) send(feState.talkback, 1);
};

: forEachSourceTB = (state: ForEachState): CB => {
    return { state, proc: forEachSourceProc };
};

: forEach = (operation: (value: string) => void) => (source: CB) => {
    const state: ForEachState = {
        operation,
    };
    const tb = forEachSourceTB(state);
    send(source, 0, tb);
};

: printOp = (x) => console.log(x) ;

10 50 10 range
const source = fromIter(iterator);

forEach(printOp)(source);
