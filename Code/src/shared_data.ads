with Sensors;
with Movement_Commands;

package Shared_Data is

   type Sequence_Number is mod 2 ** 16;

   protected Sensor_Data is

      procedure Set (Readings : Sensors.Sensor_Readings);

      procedure Get
        (Readings : out Sensors.Sensor_Readings;
         Sequence : out Sequence_Number;
         Has_Data    : out Boolean);

   private
      Current_Readings : Sensors.Sensor_Readings := (others => 0);

      Current_Sequence : Sequence_Number := 0;
      Has_Measurement  : Boolean := False;

   end Sensor_Data;

   protected Motor_Data is

      procedure Set (Command : Movement_Commands.Movement_Command);

      function Get return Movement_Commands.Movement_Command;

   private
      Current_Command : Movement_Commands.Movement_Command :=
        (Direction => Movement_Commands.Stop, Speed => 0);

   end Motor_Data;

end Shared_Data;

