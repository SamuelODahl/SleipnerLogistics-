with MicroBit.Ultrasonic;

package Sensors is

   subtype Distance_cm is MicroBit.Ultrasonic.Distance_cm;

   function Front_Distance return Distance_cm;
   function Rear_Distance  return Distance_cm;
   function Left_Distance  return Distance_cm;
   function Right_Distance return Distance_cm;

end Sensors;