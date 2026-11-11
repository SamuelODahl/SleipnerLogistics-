with Sensors;
with Movement_Commands;
with Ada.Real_Time;

package Shared_Data is

   type Sequence_Number is mod 2 ** 16;
   -- the shared sensor data is protected to ensure that only one task can access it at a time
   protected Sensor_Data is

      procedure Set (Readings : Sensors.Sensor_Readings);

      procedure Get
        (Readings : out Sensors.Sensor_Readings;
         Sequence : out Sequence_Number;
         Has_Data : out Boolean);

   private
      Current_Readings : Sensors.Sensor_Readings := (others => 0);
      -- seq number is there to make sure that think only processes new data 
      Current_Sequence : Sequence_Number := 0;
      Has_Measurement  : Boolean := False;

   end Sensor_Data;
   -- same reason as for sensor data but for motor data 
   protected Motor_Data is

      procedure Set (Command : Movement_Commands.Movement_Command);

      procedure Get
        (Command     : out Movement_Commands.Movement_Command;
         Last_Update : out Ada.Real_Time.Time);

   private
      -- init the car to stop before it gets its first command
      Current_Command : Movement_Commands.Movement_Command :=
        (Direction => Movement_Commands.Stop, Speed => 0);
      -- timestamp used to check if the motor command gets too old
      Last_Command_Update : Ada.Real_Time.Time := Ada.Real_Time.Clock;

   end Motor_Data;

end Shared_Data;

