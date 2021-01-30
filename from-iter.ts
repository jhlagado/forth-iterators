type CB = (type: number, tb?: CB | string) => void;

interface State {
  completed: boolean;
  got1: boolean;
  inloop: boolean;
  done: boolean;
}

const send = (cb: CB, type: number, arg?: CB) => cb(type, arg);

function loop(
  iterator: any,
  sink: CB,
  { completed, got1, inloop, done }: State
) {
  inloop = true;
  while (inloop) {
    if (!got1 || completed) {
      inloop = false;
      break;
    } else {
      got1 = false;
      const result = iterator.next();
      done = result.done;
      const value = result.value;
      if (done) {
        send(sink, 2);
        inloop = false;
      } else {
        send(sink, 1, value);
      }
    }
  }
}

const tbSink = (
  iterator: any,
  sink: CB,
  { completed, got1, inloop, done: iterdone }: State
) => (t: number) => {
  if (completed) return;
  if (t === 1) {
    got1 = true;
    if (!inloop && !iterdone)
      loop(iterator, sink, { completed, got1, inloop, done: iterdone });
  } else if (t === 2) {
    completed = true;
  }
};

const fromIter = (iterator: any): CB => (
  type: number,
  sink?: CB | string
): void => {
  if (type !== 0) return;
  const state: State = {
    inloop: false,
    got1: false,
    completed: false,
    done: false,
  };
  const tb = tbSink(iterator, sink as CB, state);
  send(sink as CB, 0, tb);
};

const forEach = (operation: (value: string) => void) => (source: CB) => {
  let talkback: CB;
  source(0, (t, d) => {
    if (t === 0) talkback = d as CB;
    if (t === 1) operation(d as string);
    if (t === 1 || t === 0) talkback(1);
  });
};

const iterator = [10, 20, 30, 40][Symbol.iterator]();
const source = fromIter(iterator);

forEach((x) => console.log(x))(source);

///////////////////////////////////////////////////////////////

// const fromIter = (iterator) => (start, sink) => {
//   if (start !== 0) return;
//   let inloop = false;
//   let got1 = false;
//   let completed = false;
//   let res;
//   function loop() {
//     inloop = true;
//     while (got1 && !completed) {
//       got1 = false;
//       res = iterator.next();
//       if (res.done) {
//         sink(2);
//         break;
//       } else sink(1, res.value);
//     }
//     inloop = false;
//   }
//   sink(0, (t) => {
//     if (completed) return;

//     if (t === 1) {
//       got1 = true;
//       if (!inloop && !(res && res.done)) loop();
//     } else if (t === 2) {
//       completed = true;
//     }
//   });
// };
