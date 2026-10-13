with MicroBit.Types;
use type MicroBit.Types.Distance_cm;

with Sensors;
with Movement_Commands;

package body Control is

   Stop_Distance    : constant Sensors.Distance_cm := 30;
   Resume_Distance  : constant Sensors.Distance_cm := 40;
   Max_Failed_Reads : constant Natural := 3;

   type Car_State is
     (Moving_Forward,
      Stopped);

   Current_State : Car_State := Moving_Forward;
   Failed_Reads  : Natural := 0;

   function Update
     (Front : Sensors.Distance_cm)
      return Movement_Commands.Movement_Command
   is
      use Movement_Commands;

   begin

      -- Failed sensor reading
      if Front = 0 then
         Failed_Reads := Failed_Reads + 1;

         if Failed_Reads >= Max_Failed_Reads then
            Current_State := Stopped;
         end if;

      else

         -- Valid reading
         Failed_Reads := 0;

         case Current_State is

            when Moving_Forward =>

               if Front <= Stop_Distance then
                  Current_State := Stopped;
               end if;

            when Stopped =>

               if Front >= Resume_Distance then
                  Current_State := Moving_Forward;
               end if;

         end case;

      end if;

      -- Return a movement command based on the current state
      case Current_State is

         when Moving_Forward =>
            return (Direction => Forward,
                    Speed     => 50);

         when Stopped =>
            return (Direction => Stop,
                    Speed     => 0);

      end case;

   end Update;

end Control;