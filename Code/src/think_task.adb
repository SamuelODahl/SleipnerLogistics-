with Ada.Real_Time; use Ada.Real_Time;

with Sensors;
with Shared_Data;
use type Shared_Data.Sequence_Number;

with Control;
with Movement_Commands;

package body Think_Task is

   task body Think is

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

         -- Get the latest sensor readings
         Shared_Data.Sensor_Data.Get (Readings, Sequence, Has_Data);

         -- Only process new measurements
         if Has_Data and then Sequence /= Last_Sequence then

            -- A new sensor measurement has arrived
            Last_Sensor_Update := Clock;

            Command := Control.Update (Readings.Front);
            Shared_Data.Motor_Data.Set (Command);

            Last_Sequence := Sequence;

         elsif Clock - Last_Sensor_Update >= Sensor_Timeout then

            -- No new sensor measurements within the timeout
            Shared_Data.Motor_Data.Set
              ((Direction => Movement_Commands.Stop, Speed => 0));

         end if;

         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Think;

end Think_Task;

