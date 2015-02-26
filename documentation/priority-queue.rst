**************************
The priority-queue library
**************************

.. current-library:: priority-queue


The priority-queue module
*************************

.. current-module:: priority-queue


.. class:: <priority-queue>

   :superclasses: :class:`<deque>`

   Priority is determined using simple \< comparisons. This method should
   be specialized for any object subclasses being added to the queue.

   <priority-queue> also uses a hash table to keep track of elements on
   the queue, which enables efficient promotion of elements (decreasing
   their priority). This hash table uses \= and a custom-hash function
   to compare and hash the objects placed on it, so objects which should
   use a custom comparator and hash function must specialize these methods.

   Example:

.. code-block:: dylan

   /* library.dylan */

   module: dylan-user

   define library test
     use common-dylan;
     use io;
     use collections, import: { table-extensions };
     use priority-queue;
     use custom-hash;
   end library test;

   define module test
     use common-dylan;
     use format-out;
     use table-extensions, import: { <hash-state> };
     use priority-queue;
     use custom-hash;
   end module test;

.. code-block:: dylan

   /* test.dylan */

   module: test

   define class <node> (<object>)
     constant slot id :: <integer>,
       required-init-keyword: id:;
     slot priority :: <integer>,
       init-keyword: priority:;
   end class <node>;
   
   // to determine equality / key test
   define method \=
       (node1 :: <node>, node2 :: <node>)
    => (same? :: <boolean>)
      node1.id = node2.id
   end method \=;

   // to determine priority
   define method \<
       (node1 :: <node>, node2 :: <node>)
    => (less? :: <boolean>)
      node1.priority < node2.priority
   end method \<;

   // to compute a hash
   define method custom-hash
       (node :: <node>, initial-state :: <hash-state>)
    => (id :: <integer>, result-state :: <hash-state>)
      values(node.id, initial-state)
   end method custom-hash;

   define function print-queue
       (pq :: <priority-queue>)
    => ()
      while (~ pq.empty?)
        format-out("Node {ID: %d}\n", pop(pq).id)
      end while;
      format-out("\n");
   end function print-queue;

   let pq = make(<priority-queue>);

   let node1 = make(<node>, id: 1, priority: 10);
   let node2 = make(<node>, id: 2, priority: 5);
   let node3 = make(<node>, id: 3, priority: 20);

   do(push(pq, _), list(node1, node2, node3));

   print-queue(pq); /* Node {ID: 2}
                       Node {ID: 1}
                       Node {ID: 3} */

   do(push(pq, _), list(node1, node2, node3));

   node3.priority := 7;

   push(pq, node3);

   print-queue(pq); /* Node {ID: 2}
                       Node {ID: 3}
                       Node {ID: 1} */

   do(push(pq, _), list(node1, node2, node3));

   let node1-alias = make(<node>, id: 1, priority: 1);

   push(pq, node1-alias);

   print-queue(pq) /* Node {ID: 1}
                      Node {ID: 2}
                      Node {ID: 3} */

.. method:: pop
   :specializer: <priority-queue>

   Removes the element with the lowest priority from the queue. This
   element is then returned.

.. method:: push
   :specializer: <priority-queue>

   Adds a new element to the queue. The new element is returned.

.. method:: add!
   :specializer: <priority-queue>

   Adds a new element to the queue, and returns the queue.

.. method:: remove!
   :specializer: <priority-queue>

   Removes a specified element from the queue.

