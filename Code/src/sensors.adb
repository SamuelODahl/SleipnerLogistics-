with MicroBit;
with MicroBit.Ultrasonic;
use MicroBit;

package body Sensors is
   --  TEMPORARY PIN ASSIGNMENTS
   --  TODO: Confirm sensor models and final wiring before hardware testing.
   --
   --  Each sensor currently assumes Standard 4-Wire Mode:
   --  first pin = Trigger, second pin = Echo.

   package Front_Sensor is new Ultrasonic
      (MB_P0, MB_P1);

   package Rear_Sensor is new Ultrasonic
      (MB_P2, MB_P8);

   package Left_Sensor is new Ultrasonic
      (MB_P12, MB_P13);

   package Right_Sensor is new Ultrasonic
      (MB_P14, MB_P15);


   function Front_Distance return Distance_cm is
   begin
      return Front_Sensor.Read;
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