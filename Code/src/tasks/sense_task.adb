with Ada.Real_Time;
use Ada.Real_Time;

with Ada.Execution_Time;
use Ada.Execution_Time;

with MicroBit.Console;
use MicroBit.Console;

with Sensors;
with Shared_Data;
with Motors;

package body Sense_Task is

   task body Sense is

      Time_Now_Stopwatch : Ada.Real_Time.Time;
      Time_Now_CPU       : Ada.Execution_Time.CPU_Time;

      Elapsed_Stopwatch : Ada.Real_Time.Time_Span;
      Elapsed_CPU       : Ada.Real_Time.Time_Span;

      Max_Stopwatch : Time_Span := Time_Span_Zero;
      Max_CPU       : Time_Span := Time_Span_Zero;

      Measurement_Count : Natural := 0;

      Period       : constant Time_Span := Milliseconds (150);
      Next_Release : Time := Clock;

      Readings : Sensors.Sensor_Readings := (others => 0);

   begin

      loop

         -- Start execution-time measurements
         Time_Now_Stopwatch := Ada.Real_Time.Clock;
         Time_Now_CPU := Ada.Execution_Time.Clock;

         -- Read all four ultrasonic sensors
         Readings.Front := Sensors.Front_Distance;
         Readings.Rear  := Sensors.Rear_Distance;
         Readings.Left  := Sensors.Left_Distance;
         Readings.Right := Sensors.Right_Distance;

         -- Publish measurements to THINK
         Shared_Data.Sensor_Data.Set (Readings);

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

         -- Print results every 100 iterations
         if Measurement_Count = 100 then

            Put_Line
              ("Max elapsed: "
               & Duration'Image (To_Duration (Max_Stopwatch))
               & " s");

            Put_Line
              ("Max CPU: "
               & Duration'Image (To_Duration (Max_CPU))
               & " s");

            Measurement_Count := 0;
            Max_Stopwatch := Time_Span_Zero;
            Max_CPU := Time_Span_Zero;

         end if;

         -- Wait until next scheduled activation
         Next_Release := Next_Release + Period;
         delay until Next_Release;

      end loop;

   exception
      when others =>

         -- Diagnostic handler for unexpected exceptions
         Motors.Stop;
         Put_Line ("ERROR: SENSE task terminated");

         loop
            delay 1.0;
         end loop;

   end Sense;

end Sense_Task;