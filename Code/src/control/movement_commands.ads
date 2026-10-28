with Motors;

package Movement_Commands is

   type Movement_Direction is
     (Stop,
      Forward,
      Backward,
      Strafe_Left,
      Strafe_Right,
      Rotate_Left,
      Rotate_Right);

   type Movement_Command is record
      Direction : Movement_Direction := Stop;
      Speed     : Motors.Throttle := 0;
   end record;

end Movement_Commands;