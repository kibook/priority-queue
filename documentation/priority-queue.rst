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

