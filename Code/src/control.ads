with Sensors;
with Movement_Commands;

package Control is

   function Update
     (Front : Sensors.Distance_cm)
      return Movement_Commands.Movement_Command;

end Control;