package body Shared_Data is

   protected body Sensor_Data is

      procedure Set (Readings : Sensors.Sensor_Readings) is
      begin
         Current_Readings := Readings;
         Current_Sequence := Current_Sequence + 1;
         Has_Measurement := True;
      end Set;

      procedure Get
        (Readings : out Sensors.Sensor_Readings;
         Sequence : out Sequence_Number;
         Has_Data    : out Boolean) is
      begin
         Readings := Current_Readings;
         Sequence := Current_Sequence;
         Has_Data := Has_Measurement;
      end Get;

   end Sensor_Data;

   protected body Motor_Data is

      procedure Set (Command : Movement_Commands.Movement_Command) is
      begin
         Current_Command := Command;
      end Set;

      function Get return Movement_Commands.Movement_Command is
      begin
         return Current_Command;
      end Get;

   end Motor_Data;

end Shared_Data;
