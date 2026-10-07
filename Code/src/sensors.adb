with MicroBit;
with MicroBit.Ultrasonic;
with MicroBit.Types;

use MicroBit;
use type MicroBit.Types.Distance_cm;

package body Sensors is

   -- TEMPORARY PIN ASSIGNMENTS
   -- Each sensor uses Standard 4-Wire Mode:
   -- first pin = Trigger, second pin = Echo.

   package Front_Sensor is new Ultrasonic
     (MB_P0, MB_P1);

   package Rear_Sensor is new Ultrasonic
     (MB_P2, MB_P8);

   package Left_Sensor is new Ultrasonic
     (MB_P12, MB_P13);

   package Right_Sensor is new Ultrasonic
     (MB_P14, MB_P15);


   -- Stores the three most recent valid front sensor readings
   Front_Sample_1 : Distance_cm := 0;
   Front_Sample_2 : Distance_cm := 0;
   Front_Sample_3 : Distance_cm := 0;

   Front_Sample_Count : Natural range 0 .. 3 := 0;


   function Median
     (A : Distance_cm;
      B : Distance_cm;
      C : Distance_cm) return Distance_cm
   is
   begin
      if (A <= B and B <= C) or else
         (C <= B and B <= A)
      then
         return B;

      elsif (B <= A and A <= C) or else
            (C <= A and A <= B)
      then
         return A;

      else
         return C;
      end if;
   end Median;


   function Front_Distance return Distance_cm is
      Raw : constant Distance_cm := Front_Sensor.Read;
   begin

      -- 0 means the sensor failed to get a measurement.
      -- Do not put failed measurements into the filter.
      if Raw = 0 then
         return 0;
      end if;


      -- Fill the filter during the first three valid readings.
      if Front_Sample_Count = 0 then

         Front_Sample_1 := Raw;
         Front_Sample_Count := 1;
         return Raw;

      elsif Front_Sample_Count = 1 then

         Front_Sample_2 := Raw;
         Front_Sample_Count := 2;
         return Raw;

      elsif Front_Sample_Count = 2 then

         Front_Sample_3 := Raw;
         Front_Sample_Count := 3;

      else

         -- Shift old samples and add the newest one.
         Front_Sample_1 := Front_Sample_2;
         Front_Sample_2 := Front_Sample_3;
         Front_Sample_3 := Raw;

      end if;

      return Median
        (Front_Sample_1,
         Front_Sample_2,
         Front_Sample_3);

   end Front_Distance;


   function Rear_Distance return Distance_cm is
   begin
      return Rear_Sensor.Read;
   end Rear_Distance;


   function Left_Distance return Distance_cm is
   begin
      return Left_Sensor.Read;
   end Left_Distance;


   function Right_Distance return Distance_cm is
   begin
      return Right_Sensor.Read;
   end Right_Distance;

end Sensors;