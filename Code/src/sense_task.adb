with Ada.Real_Time; use Ada.Real_Time;

with Sensors;
with Shared_Data;

package body Sense_Task is

   task body Sense is

      Period       : constant Time_Span := Milliseconds (100);
      Next_Release : Time := Clock;

      Readings : Sensors.Sensor_Readings := (others => 0);

   begin

      loop
         Readings.Front := Sensors.Front_Distance;

         -- Publish the measurements
         Shared_Data.Sensor_Data.Set (Readings);

         -- Wait until next period
         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   end Sense;

end Sense_Task;

