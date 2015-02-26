Module: priority-queue

define macro swap!
    { swap!(?a:expression, ?b:expression) }
 => { let c = ?a;
      ?a := ?b;
      ?b := c }
end macro swap!;

define class <priority-queue> (<deque>)
  constant slot heap :: <vector> = make(<stretchy-vector>);
  constant slot hash :: <table> = make(<custom-hash-table>);
end class <priority-queue>;

define method size
    (pq :: <priority-queue>)
 => (size :: <integer>)
  pq.heap.size
end method size;

define method empty?
    (pq :: <priority-queue>)
 => (is-empty :: <boolean>)
  pq.heap.empty?
end method empty?;

define method pop
    (pq :: <priority-queue>)
 => (top)
  if (pq.empty?)
    error(make(<simple-error>,
               format-string: "POP empty priority-queue %=",
               format-arguments: list(pq)))
  end if;

  let top = pq.heap[0];

  remove-key!(pq.hash, pq.heap[0]);

  pq.heap[0] := pq.heap[pq.heap.size - 1];
  pq.heap.size := pq.heap.size - 1;

  if (~ pq.empty?)
    heapify(pq, 0)
  end if;

  top
end method pop;

define method push
    (pq :: <priority-queue>, new-value)
 => (new-value)
  if (element(pq.hash, new-value, default: #f) ~== #f)
    // If the element is already in the queue, get the current index of the
    // item in the heap from the hash table
    let i = pq.hash[new-value];

    if (new-value < pq.heap[i])
      // If the new instance of the element has a lower priority than the
      // instance already in the queue, we can more efficiently change the
      // priority by replacing it on the heap and performing a push-up from
      // the index.
      pq.heap[i] := new-value;
      push-up(pq, i)
    else
      // Doesn't work in the opposite direction, so we just remove it and
      // put it back on with the new priority.
      remove!(pq, new-value);
      push(pq, new-value)
    end if
  else
    // Add the new element to the bottom of the heap and the hash table and
    // perform a push-up from the bottom.
    let i = pq.heap.size;
    add!(pq.heap, new-value);
    pq.hash[new-value] := i;
    push-up(pq, i)
  end if;
  new-value
end method push;

define method add!
    (pq :: <priority-queue>, new-value)
 => (pq :: <priority-queue>)
  push(pq, new-value);
  pq
end method add!;

define method remove!
    (pq :: <priority-queue>, value, #key test, count)
 => (pq :: <priority-queue>)
  let i = pq.hash[value];
  pq.heap[i] := pq.heap[pq.heap.size - 1];
  pq.heap.size := pq.size - 1;
  if (pq.size > 1 & pq.size > i)
    heapify(pq, i)
  end if;
  remove-key!(pq.hash, value);
  pq
end method remove!;

define method push-up
    (pq :: <priority-queue>, position :: <integer>)
 => ()
  block (exit)
    while (position > 0)
      let np = ash(position - 1, -1);
      if (pq.heap[position] < pq.heap[np])
        pq.hash[pq.heap[np]] := position;
        pq.hash[pq.heap[position]] := np;
        swap!(pq.heap[np], pq.heap[position]);
        position := np
      else
        exit()
      end if
    end while
  end block
end method push-up;

define method heapify
    (pq :: <priority-queue>, position :: <integer>)
 => ()
  block (exit)
    while (#t)
      let mpos = position;
      let l = ash(position + 1, 1) - 1;
      let r = ash(position + 1, 1);

      if (l < pq.heap.size & pq.heap[l] < pq.heap[mpos])
        mpos := l
      end if;
      if (r < pq.heap.size & pq.heap[r] < pq.heap[mpos])
        mpos := r
      end if;
      if (mpos = position)
        exit()
      end if;

      pq.hash[pq.heap[position]] := mpos;
      pq.hash[pq.heap[mpos]] := position;
      swap!(pq.heap[position], pq.heap[mpos]);
      position := mpos
    end while
  end block
end method heapify;

define method element
    (pq :: <priority-queue>, key, #key default)
 => (element)
  element(pq.heap, key, default: default)
end method element;
