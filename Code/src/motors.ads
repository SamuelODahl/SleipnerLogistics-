package Motors is

   type Throttle is range 0 .. 100;
   
   procedure Forward (Motor_Speed : Throttle);
   procedure Backward (Motor_Speed : Throttle);

   procedure Strafe_Left  (Motor_Speed : Throttle);
   procedure Strafe_Right (Motor_Speed : Throttle);

   procedure Rotate_Left  (Motor_Speed : Throttle);
   procedure Rotate_Right (Motor_Speed : Throttle);

   procedure Stop;

end Motors;