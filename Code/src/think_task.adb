with Ada.Real_Time;
use Ada.Real_Time;

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

   begin

      loop

         -- Get the latest sensor readings
         Shared_Data.Sensor_Data.Get
           (Readings, Sequence, Has_Data);

         -- Only process new measurements
         if Has_Data and then Sequence /= Last_Sequence then

            Command := Control.Update (Readings.Front); -- will change to to only Readings in the future

            Shared_Data.Motor_Data.Set (Command);

            Last_Sequence := Sequence;

         end if;

         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Think;

end Think_Task;