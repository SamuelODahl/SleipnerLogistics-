with Sensors;
with Movement_Commands;

package Control is

   function Update
     (Readings : Sensors.Sensor_Readings)
      return Movement_Commands.Movement_Command;

end Control;