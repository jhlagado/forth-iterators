\ state is a closure of the form [vars sink iterator proc]
\ vars is a tuple4 of the form [ completed got1 inloop done ]

: fiSinkLoop                            \ state --
  dup @                                 \ state vars
  begin
    dup 2 [] @                          \ state vars inloop
  while
    dup 1 [] @ invert                   \ state vars !got1
    over @                              \ state vars !got1 completed
    or if                               \ state vars >>>> if (!got || completed)
      2 [] false swap !                 \ state >>>> inloop = false
    else
      dup 1 [] false swap !             \ state vars >>>> got1 = false
      over 2 []                         \ state vars iterator
      0 run                             \ state vars value done? >>>> run iterator
      swap >r                           \ state vars done? >>>> save value
      dup >r                            \ state vars done? >>>> save copy of done?
      over 3 [] !                       \ state vars >>>> done = done?
      r> r> swap                        \ state vars value done?
      if
        drop                            \ drop value
        over 1 []                       \ state vars sink 
        0 destroy                       \ state vars >>>> send a 2 to sink
        2 [] false swap !               \ state >>>> inloop = false
      else
        swap drop                       \ state value
        over 1 []                       \ state value sink
        swap run                        \ state >>>> send a 1 and a value to sink
      then
    then
  repeat
  drop                                  \ drop state
;

: fiSinkData                            \ state -- 
  dup >r                                \ state >>>> save state
  @                                     \ vars
  dup 1 [] true swap !                  \ vars >>>> got1 = true
  dup 2 [] @                            \ vars inloop*
  over 3 [] @                           \ vars inloop* done*
  or invert                             \ if !(inloop || done)
  if                                   
    2 [] true swap !                    \ inloop = true
  then
  r> fiSinkLoop
;

: fiSinkProc                            \ state type arg -- 
    drop                                \ state type
    over @ @                            \ state type completed
    if 
      drop                              \ drop type
      drop                              \ drop state
    else 
      case                              \ state  
        0 of
          drop                          \ drop state
        endof
        1 of
          fiSinkData
        endof
        2 of
          @ true !                      \ completed = true
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



: fromIter_loopproc                     \ state iterator sink -- 
                                        \ where state = [inloop got1 completed res]
    0 s(abc                             \ a = state, b = iterator, c = sink
      true c> 0 []                      \ inloop = true
      begin
        false c> 1 []                   \ got1 = false
        a> run                          \ run iterator
      while
      repeat
      false c> 0 []                     \ inloop = false
    )s
;

: fromIter_sinkproc                     \ state start talkback -- 
                                        \ where state = [inloop got1 completed res]
    0 s(abc                             \ a = state, b = iterator, c = sink
      >a 2 [] @ invert if               \ if !completed
      endif
    )s
;

: fromIter_proc                         \ start sink -- 
    swap invert if                      \ sink >>>>  if start == 0 
        0 0 0 s(a                           \ a = sink          
            false false false NULL tuple4 >b               \ b = [inloop got1 completed res]
            b> 
        )s
    then
;

: fromIter                              \ iterator -- closure
    0 0 ['] fromIter_proc closure       \   -- adr >>>> [iterator 0 0 fromIter_proc]
;

