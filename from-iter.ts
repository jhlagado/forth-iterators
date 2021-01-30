type CB = (type: number, tb?: CB | string) => void;
const send = (cb: CB, type: number, arg?: CB) => cb(type, arg);
interface FromIterState {
  completed: boolean;
  got1: boolean;
  inloop: boolean;
  done: boolean;
}

function fromInterLoop(
  iterator: any,
  sink: CB,
  { completed, got1, inloop, done }: FromIterState
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

const fromIterSinkTB = (
  iterator: any,
  sink: CB,
  { completed, got1, inloop, done: iterdone }: FromIterState
): CB => (type: number) => {
  if (completed) return;
  if (type === 1) {
    got1 = true;
    if (!inloop && !iterdone)
      fromInterLoop(iterator, sink, {
        completed,
        got1,
        inloop,
        done: iterdone,
      });
  } else if (type === 2) {
    completed = true;
  }
};

const fromIter = (iterator: any): CB => (
  type: number,
  sink?: CB | string
): void => {
  if (type !== 0) return;
  const state: FromIterState = {
    inloop: false,
    got1: false,
    completed: false,
    done: false,
  };
  const tb = fromIterSinkTB(iterator, sink as CB, state);
  send(sink as CB, 0, tb);
};

interface ForEachState {
  talkback?: CB;
}

type Operation = (value: string) => void;

const forEachSourceTB = (operation: Operation, state: ForEachState): CB => (
  type,
  data
) => {
  if (type === 0) state.talkback = data as CB;
  if (type === 1) operation(data as string);
  if (type === 1 || type === 0) state.talkback?.(1);
};

const forEach = (operation: (value: string) => void) => (source: CB) => {
  const state: ForEachState = {};
  const tb = forEachSourceTB(operation, state);
  send(source, 0, tb);
};

const iterator = [10, 20, 30, 40][Symbol.iterator]();
const source = fromIter(iterator);

forEach((x) => console.log(x))(source);
