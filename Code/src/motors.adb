with MicroBit.MotorDriver;
with HAL;


package body Motors is

   function To_Driver_speed (Motor_Speed : Throttle) return HAL.UInt12 is
   begin
      return HAL.UInt12
         ((Integer (Motor_Speed) * 4095) / 100);
   end To_Driver_speed;

   procedure Forward (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive(MicroBit.MotorDriver.Forward,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Forward;

   procedure Backward (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive(MicroBit.MotorDriver.Backward,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Backward;

   procedure Stop is
   begin
      MicroBit.MotorDriver.Drive
         (MicroBit.MotorDriver.Stop);      
   end Stop;

end Motors;