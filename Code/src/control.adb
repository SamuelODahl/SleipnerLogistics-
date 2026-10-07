with MicroBit.Types;
use type MicroBit.Types.Distance_cm;

with MicroBit.Console; use MicroBit.Console;

with Sensors;
with Motors;

package body Control is

   Stop_Distance    : constant Sensors.Distance_cm := 30;
   Resume_Distance  : constant Sensors.Distance_cm := 40;
   Max_Failed_Reads : constant Natural := 3;

   Failed_Reads : Natural := 0;
   Is_Stopped   : Boolean := False;

   procedure Update is
      Front : Sensors.Distance_cm;
   begin
      Front := Sensors.Front_Distance;

      Put_Line ("Front: " & Sensors.Distance_cm'Image (Front));

      if Front = 0 then
         Failed_Reads := Failed_Reads + 1;

         if Failed_Reads >= Max_Failed_Reads then
            Motors.Stop;
            Is_Stopped := True;
         end if;

      else
         Failed_Reads := 0;

         if Front <= Stop_Distance then
            Motors.Stop;
            Is_Stopped := True;

         elsif Front >= Resume_Distance then
            Motors.Forward (50);
            Is_Stopped := False;

         -- Between 30 and 40 cm:
         -- keep the current motor state
         end if;
      end if;
   end Update;

end Control;