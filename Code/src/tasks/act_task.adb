with Ada.Real_Time;
use Ada.Real_Time;

with Ada.Execution_Time;
use Ada.Execution_Time;

with MicroBit.Console;
use MicroBit.Console;

with Shared_Data;
with Movement_Commands;
with Motors;

package body Act_Task is

   task body Act is

      Time_Now_Stopwatch : Ada.Real_Time.Time;
      Time_Now_CPU       : Ada.Execution_Time.CPU_Time;

      Elapsed_Stopwatch : Ada.Real_Time.Time_Span;
      Elapsed_CPU       : Ada.Real_Time.Time_Span;

      Max_Stopwatch : Time_Span := Time_Span_Zero;
      Max_CPU       : Time_Span := Time_Span_Zero;

      Measurement_Count : Natural := 0;

      Period       : constant Time_Span := Milliseconds (20);
      Next_Release : Time := Clock;

      Command : Movement_Commands.Movement_Command;

      Last_Update   : Time;
      Motor_Timeout : constant Time_Span := Milliseconds (300);

   begin

      loop

         -- Start execution-time measurements
         Time_Now_Stopwatch := Ada.Real_Time.Clock;
         Time_Now_CPU := Ada.Execution_Time.Clock;

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

         -- Calculate execution times
         Elapsed_Stopwatch :=
           Ada.Real_Time.Clock - Time_Now_Stopwatch;

         Elapsed_CPU :=
           Ada.Execution_Time.Clock - Time_Now_CPU;

         -- Store maximum observed times
         if Elapsed_Stopwatch > Max_Stopwatch then
            Max_Stopwatch := Elapsed_Stopwatch;
         end if;

         if Elapsed_CPU > Max_CPU then
            Max_CPU := Elapsed_CPU;
         end if;

         Measurement_Count := Measurement_Count + 1;

         -- Print results every 500 iterations
         if Measurement_Count = 500 then

            Put_Line
              ("ACT Max elapsed: "
               & Duration'Image (To_Duration (Max_Stopwatch))
               & " s");

            Put_Line
              ("ACT Max CPU: "
               & Duration'Image (To_Duration (Max_CPU))
               & " s");

            Measurement_Count := 0;
            Max_Stopwatch := Time_Span_Zero;
            Max_CPU := Time_Span_Zero;

         end if;

         -- Wait until next activation
         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Act;

end Act_Task;