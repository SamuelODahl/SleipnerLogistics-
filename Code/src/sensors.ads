with MicroBit.Types;

package Sensors is

   subtype Distance_cm is MicroBit.Types.Distance_cm;

   -- Stores measurements from all four sensors
   type Sensor_Readings is record
      Front : Distance_cm := 0;
      Rear  : Distance_cm := 0;
      Left  : Distance_cm := 0;
      Right : Distance_cm := 0;
   end record;

   function Front_Distance return Distance_cm;
   function Rear_Distance  return Distance_cm;
   function Left_Distance  return Distance_cm;
   function Right_Distance return Distance_cm;

end Sensors;