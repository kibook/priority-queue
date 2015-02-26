Module: dylan-user

define library priority-queue
  use common-dylan;
  use custom-hash;
  export
    priority-queue;
end library priority-queue;

define module priority-queue
  use common-dylan;
  use custom-hash;
  export
    <priority-queue>;
end module priority-queue;
