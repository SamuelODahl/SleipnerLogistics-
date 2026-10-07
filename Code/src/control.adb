with MicroBit.Types;
use type MicroBit.Types.Distance_cm;

with MicroBit.Console; use MicroBit.Console;

with Sensors;
with Motors;

package body Control is

   Stop_Distance    : constant Sensors.Distance_cm := 30;
   Resume_Distance  : constant Sensors.Distance_cm := 40;
   Max_Failed_Reads : constant Natural := 3;

   type Car_State is
     (Moving_Forward,
      Stopped);

   Current_State : Car_State := Moving_Forward;
   Failed_Reads  : Natural := 0;

   procedure Update is
      Front : Sensors.Distance_cm;
   begin
      Front := Sensors.Front_Distance;

      Put_Line ("Front: " & Sensors.Distance_cm'Image (Front));

      -- Failed sensor reading
      if Front = 0 then
         Failed_Reads := Failed_Reads + 1;

         if Failed_Reads >= Max_Failed_Reads then
            Motors.Stop;
            Current_State := Stopped;
         end if;

         return;
      end if;

      -- Valid reading
      Failed_Reads := 0;

      case Current_State is

         when Moving_Forward =>

            if Front <= Stop_Distance then
               Motors.Stop;
               Current_State := Stopped;
            else
               Motors.Forward (50);
            end if;


         when Stopped =>

            if Front >= Resume_Distance then
               Motors.Forward (50);
               Current_State := Moving_Forward;
            else
               Motors.Stop;
            end if;

      end case;

   end Update;

end Control;