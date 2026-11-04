with MicroBit.Types;
use type MicroBit.Types.Distance_cm;

with Sensors;
with Movement_Commands;

package body Control is

   Stop_Distance      : constant Sensors.Distance_cm := 40;
   Resume_Distance    : constant Sensors.Distance_cm := 50;
   Side_Clearance     : constant Sensors.Distance_cm := 35;
   Side_Stop_Distance : constant Sensors.Distance_cm := 20;

   Rear_Clearance : constant Sensors.Distance_cm := 40;

   Max_Failed_Reads         : constant Natural := 6;
   Front_Emergency_Distance : constant Sensors.Distance_cm := 20;

   type Car_State is
     (Moving_Forward,
      Turning_Left,
      Turning_Right,
      Strafing_Left,
      Strafing_Right,
      Reversing,
      Stopped);

   Current_State : Car_State := Moving_Forward;
   Failed_Reads  : Natural := 0;

   function Update
     (Readings : Sensors.Sensor_Readings)
      return Movement_Commands.Movement_Command
   is
      use Movement_Commands;

   begin

      -- Failed front sensor reading
      if Readings.Front = 0 then
         Failed_Reads := Failed_Reads + 1;

         if Failed_Reads >= Max_Failed_Reads then
            Current_State := Stopped;
         end if;

         -- Allow recovery by rotating when the front sensor
         -- cannot provide a valid distance.
         if Current_State = Stopped then

            if Readings.Left >= Side_Clearance
              and then Readings.Left >= Readings.Right
            then
               Current_State := Turning_Left;

            elsif Readings.Right >= Side_Clearance then
               Current_State := Turning_Right;

            end if;

         end if;

      else
         Failed_Reads := 0;

         case Current_State is

            when Moving_Forward =>

               if Readings.Front <= Stop_Distance then

                  if Readings.Left >= Side_Clearance
                    and then Readings.Left >= Readings.Right
                  then
                     Current_State := Turning_Left;

                  elsif Readings.Right >= Side_Clearance then
                     Current_State := Turning_Right;

                  elsif Readings.Rear >= Rear_Clearance then
                     -- No room to turn, but rear is clear
                     Current_State := Reversing;

                  else
                     Current_State := Stopped;
                  end if;

               elsif Readings.Left > 0
                 and then Readings.Left <= Side_Stop_Distance
                 and then Readings.Right >= Side_Clearance
               then
                  Current_State := Strafing_Right;

               elsif Readings.Right > 0
                 and then Readings.Right <= Side_Stop_Distance
                 and then Readings.Left >= Side_Clearance
               then
                  Current_State := Strafing_Left;
               end if;

            when Stopped        =>

               if Readings.Front >= Resume_Distance then
                  Current_State := Moving_Forward;

               elsif Readings.Left >= Side_Clearance
                 and then Readings.Left >= Readings.Right
               then
                  Current_State := Turning_Left;

               elsif Readings.Right >= Side_Clearance then
                  Current_State := Turning_Right;

               elsif Readings.Front <= Stop_Distance
                 and then Readings.Rear >= Rear_Clearance
               then
                  -- Escape when front and sides are blocked
                  Current_State := Reversing;
               end if;

            when Reversing      =>

               if Readings.Rear = 0 or else Readings.Rear < Rear_Clearance then
                  -- Rear obstacle or invalid measurement
                  Current_State := Stopped;

               elsif Readings.Front >= Resume_Distance then
                  Current_State := Moving_Forward;

               elsif Readings.Left >= Side_Clearance
                 and then Readings.Left >= Readings.Right
               then
                  Current_State := Turning_Left;

               elsif Readings.Right >= Side_Clearance then
                  Current_State := Turning_Right;

               end if;

            when Turning_Left   =>

               if Readings.Left > 0
                 and then Readings.Left <= Side_Stop_Distance
               then
                  -- Left side too close.
                  Current_State := Stopped;

               elsif Readings.Front > 0
                 and then Readings.Front <= Front_Emergency_Distance
               then
                  -- Front dangerously close.
                  -- Reverse only if rear clearance is sufficient.
                  if Readings.Rear >= Rear_Clearance then
                     Current_State := Reversing;
                  else
                     Current_State := Stopped;
                  end if;

               elsif Readings.Front >= Resume_Distance then
                  Current_State := Moving_Forward;

               end if;

            when Turning_Right  =>

               if Readings.Right > 0
                 and then Readings.Right <= Side_Stop_Distance
               then
                  -- Right side too close.
                  Current_State := Stopped;

               elsif Readings.Front > 0
                 and then Readings.Front <= Front_Emergency_Distance
               then
                  -- Front dangerously close.
                  -- Reverse only if rear clearance is sufficient.
                  if Readings.Rear >= Rear_Clearance then
                     Current_State := Reversing;
                  else
                     Current_State := Stopped;
                  end if;

               elsif Readings.Front >= Resume_Distance then
                  Current_State := Moving_Forward;

               end if;

            when Strafing_Right =>

               if Readings.Right = 0
                 or else Readings.Right <= Side_Stop_Distance
               then
                  -- Cannot safely continue strafing right.
                  Current_State := Stopped;

               elsif Readings.Front <= Stop_Distance then

                  -- Front obstacle detected.
                  -- Try turning right if there is enough space.
                  if Readings.Right >= Side_Clearance then
                     Current_State := Turning_Right;
                  else
                     Current_State := Stopped;
                  end if;

               elsif Readings.Left >= Side_Clearance then
                  Current_State := Moving_Forward;

               end if;

            when Strafing_Left  =>

               if Readings.Left = 0 or else Readings.Left <= Side_Stop_Distance
               then
                  -- Cannot safely continue strafing left.
                  Current_State := Stopped;

               elsif Readings.Front <= Stop_Distance then

                  -- Front obstacle detected.
                  -- Try turning left if there is enough space.
                  if Readings.Left >= Side_Clearance then
                     Current_State := Turning_Left;
                  else
                     Current_State := Stopped;
                  end if;

               elsif Readings.Right >= Side_Clearance then
                  Current_State := Moving_Forward;

               end if;

         end case;

      end if;

      -- Never reverse without a valid, clear rear measurement
      if Current_State = Reversing
        and then (Readings.Rear = 0 or else Readings.Rear < Rear_Clearance)
      then
         Current_State := Stopped;
      end if;

      -- Stop rotation if the side it is turning toward becomes dangerously close.
      if Current_State = Turning_Left
        and then Readings.Left > 0
        and then Readings.Left <= Side_Stop_Distance
      then
         Current_State := Stopped;

      elsif Current_State = Turning_Right
        and then Readings.Right > 0
        and then Readings.Right <= Side_Stop_Distance
      then
         Current_State := Stopped;
      end if;

      -- Return movement command based on current state
      case Current_State is

         when Moving_Forward =>
            return (Direction => Forward, Speed => 50);

         when Stopped        =>
            return (Direction => Stop, Speed => 0);

         when Turning_Left   =>
            return (Direction => Rotate_Left, Speed => 40);

         when Turning_Right  =>
            return (Direction => Rotate_Right, Speed => 40);

         when Strafing_Left  =>
            return (Direction => Strafe_Left, Speed => 40);

         when Strafing_Right =>
            return (Direction => Strafe_Right, Speed => 40);

         when Reversing      =>
            return (Direction => Backward, Speed => 30);

      end case;

   end Update;

end Control;
