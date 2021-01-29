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

const fromIter = iterator => (start, sink) => {
  if (start !== 0) return;
  let inloop = false;
  let got1 = false;
  let completed = false;
  let res;
  function loop() {
    inloop = true;
    while (got1 && !completed) {
      got1 = false;
      res = iterator.next();
      if (res.done) {
        sink(2);
        break;
      }
      else sink(1, res.value);
    }
    inloop = false;
  }
  sink(0, t => {
    if (completed) return

    if (t === 1) {
      got1 = true;
      if (!inloop && !(res && res.done)) loop();
    } else if (t === 2) {
      completed = true;
    }
  });
};

const fromIter = iterator => (start, sink) => {
  if (start !== 0) return;
  let inloop = false;
  let got1 = false;
  let completed = false;
  let res;
  function loop() {
    inloop = true;
    while (got1 && !completed) {
      got1 = false;
      res = iterator.next();
      if (res.done) {
        sink(2);
        break;
      }
      else sink(1, res.value);
    }
    inloop = false;
  }
  sink(0, t => {
    if (completed) return

    if (t === 1) {
      got1 = true;
      if (!inloop && !(res && res.done)) loop();
    } else if (t === 2) {
      completed = true;
    }
  });
};