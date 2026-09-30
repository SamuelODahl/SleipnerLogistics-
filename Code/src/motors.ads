package Motors is

   type Throttle is range 0 .. 100;
   procedure Forward (Motor_Speed : Throttle);
   procedure Backward (Motor_Speed : Throttle);
   procedure Stop;

end Motors;