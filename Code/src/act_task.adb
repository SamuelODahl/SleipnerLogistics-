with Ada.Real_Time;
use Ada.Real_Time;

with Shared_Data;
with Movement_Commands;
with Motors;

package body Act_Task is

   task body Act is

      Period       : constant Time_Span := Milliseconds (20);
      Next_Release : Time := Clock;

      Command : Movement_Commands.Movement_Command;

      Last_Update   : Time;
      Motor_Timeout : constant Time_Span := Milliseconds (300);

   begin

      loop

         -- Get the latest movement command
         Shared_Data.Motor_Data.Get (Command, Last_Update);

         -- Stop if Think has not published a new command recently
         if Clock - Last_Update >= Motor_Timeout then
            Command := (Direction => Movement_Commands.Stop, Speed => 0);
         end if;

         -- Execute the command
         case Command.Direction is

            when Movement_Commands.Forward =>
               Motors.Forward (Command.Speed);

            when Movement_Commands.Backward =>
               Motors.Backward (Command.Speed);

            when Movement_Commands.Strafe_Left =>
               Motors.Strafe_Left (Command.Speed);

            when Movement_Commands.Strafe_Right =>
               Motors.Strafe_Right (Command.Speed);

            when Movement_Commands.Rotate_Left =>
               Motors.Rotate_Left (Command.Speed);

            when Movement_Commands.Rotate_Right =>
               Motors.Rotate_Right (Command.Speed);

            when Movement_Commands.Stop =>
               Motors.Stop;

         end case;

         -- Wait until next activation
         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Act;

end Act_Task;