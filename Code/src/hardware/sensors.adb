with MicroBit;
with MicroBit.Ultrasonic;
with MicroBit.Types;

use MicroBit;
use type MicroBit.Types.Distance_cm;

package body Sensors is

   Emergency_Distance : constant Distance_cm := 40;
   -- first pin = Trigger, second pin = Echo.
   package Front_Sensor is new Ultrasonic (MB_P0, MB_P1);

   package Rear_Sensor is new Ultrasonic (MB_P2, MB_P16);

   package Left_Sensor is new Ultrasonic (MB_P14, MB_P15);

   package Right_Sensor is new Ultrasonic (MB_P12, MB_P13);

   -- keep the last three valid readings for my median filter
   Front_Sample_1 : Distance_cm := 0;
   Front_Sample_2 : Distance_cm := 0;
   Front_Sample_3 : Distance_cm := 0;

   Front_Sample_Count : Natural range 0 .. 3 := 0;

   -- takes the middle value of three readings to filter out random spikes
   function Median
     (A : Distance_cm; B : Distance_cm; C : Distance_cm) return Distance_cm is
   begin
      if (A <= B and B <= C) or else (C <= B and B <= A) then
         return B;

      elsif (B <= A and A <= C) or else (C <= A and A <= B) then
         return A;

      else
         return C;
      end if;
   end Median;

   function Front_Distance return Distance_cm is
      Raw : constant Distance_cm := Front_Sensor.Read;
   begin

      -- dont put failed readings in the filter
      if Raw = 0 then
         return 0;
      end if;

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

         Front_Sample_1 := Front_Sample_2;
         Front_Sample_2 := Front_Sample_3;
         Front_Sample_3 := Raw;

      end if;

      -- checks for emergency distance first so that the median filter doesnt delay the response
      if Raw <= Emergency_Distance then

         if Raw <= 25 then
            return Raw;
         end if;

         -- less critical, check with median filter
         if Median (Front_Sample_1, Front_Sample_2, Front_Sample_3)
           <= Emergency_Distance
         then
            return Raw;
         end if;

      end if;

      return Median (Front_Sample_1, Front_Sample_2, Front_Sample_3);

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
