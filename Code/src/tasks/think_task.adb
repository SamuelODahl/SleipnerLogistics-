with Ada.Real_Time;
use Ada.Real_Time;

with Ada.Execution_Time;
use Ada.Execution_Time;

with MicroBit.Console;
use MicroBit.Console;

with Sensors;
with Shared_Data;
use type Shared_Data.Sequence_Number;

with Control;
with Movement_Commands;

-- timing measurements are only used for the time analysis and are not part of the robots functionality

package body Think_Task is

   task body Think is

      Time_Now_Stopwatch : Ada.Real_Time.Time;
      Time_Now_CPU       : Ada.Execution_Time.CPU_Time;

      Elapsed_Stopwatch : Ada.Real_Time.Time_Span;
      Elapsed_CPU       : Ada.Real_Time.Time_Span;

      Max_Stopwatch : Time_Span := Time_Span_Zero;
      Max_CPU       : Time_Span := Time_Span_Zero;

      Measurement_Count : Natural := 0;

      Period       : constant Time_Span := Milliseconds (50);
      Next_Release : Time := Clock;

      Readings : Sensors.Sensor_Readings;

      Sequence      : Shared_Data.Sequence_Number;
      Last_Sequence : Shared_Data.Sequence_Number := 0;
      Has_Data      : Boolean;

      Command : Movement_Commands.Movement_Command;

      Last_Sensor_Update : Time := Clock;

      Sensor_Timeout : constant Time_Span := Milliseconds (300);

   begin

      loop

         Time_Now_Stopwatch := Ada.Real_Time.Clock;
         Time_Now_CPU := Ada.Execution_Time.Clock;

         Shared_Data.Sensor_Data.Get (Readings, Sequence, Has_Data);

         -- uses the sequence number to not process the same sensor data twice 
         if Has_Data and then Sequence /= Last_Sequence then

            Last_Sensor_Update := Clock;

            Command := Control.Update (Readings);
            Shared_Data.Motor_Data.Set (Command);

            Last_Sequence := Sequence;

         elsif Clock - Last_Sensor_Update >= Sensor_Timeout then

            -- stop the car if the sensor readings haven't been updated for 300 ms
            Shared_Data.Motor_Data.Set
              ((Direction => Movement_Commands.Stop, Speed => 0));

         end if;

         Elapsed_Stopwatch :=
           Ada.Real_Time.Clock - Time_Now_Stopwatch;

         Elapsed_CPU :=
           Ada.Execution_Time.Clock - Time_Now_CPU;

         if Elapsed_Stopwatch > Max_Stopwatch then
            Max_Stopwatch := Elapsed_Stopwatch;
         end if;

         if Elapsed_CPU > Max_CPU then
            Max_CPU := Elapsed_CPU;
         end if;

         Measurement_Count := Measurement_Count + 1;

         if Measurement_Count = 200 then

            Put_Line
              ("THINK Max elapsed: "
               & Duration'Image (To_Duration (Max_Stopwatch))
               & " s");

            Put_Line
              ("THINK Max CPU: "
               & Duration'Image (To_Duration (Max_CPU))
               & " s");

            Measurement_Count := 0;
            Max_Stopwatch := Time_Span_Zero;
            Max_CPU := Time_Span_Zero;

         end if;

         -- keep the task running at a fixed 50ms period
         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Think;

end Think_Task;