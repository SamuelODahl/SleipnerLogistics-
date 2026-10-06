with MicroBit.Types;
use type MicroBit.Types.Distance_cm;

with Sensors;
with Motors;

package body Control is

   Obstacle_Distance : constant Sensors.Distance_cm := 30;

   procedure Update is
      Front : Sensors.Distance_cm;
   begin
      Front := Sensors.Front_Distance;

      if Front > 0 and Front <= Obstacle_Distance then
         Motors.Stop;
      else
         Motors.Forward (50);
      end if;
   end Update;

end Control;