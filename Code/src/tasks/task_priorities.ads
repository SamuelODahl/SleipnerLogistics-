with System;
-- added to set task priorities for the three tasks in the system
-- easier to change priorities in one place rather than in each task spec

package Task_Priorities is

   Sense_Priority : constant System.Priority :=
     System.Priority'First + 1;

   Think_Priority : constant System.Priority :=
     System.Priority'First + 2;

   Act_Priority : constant System.Priority :=
     System.Priority'First + 3;

end Task_Priorities;