with MicroBit.MotorDriver;
with HAL;

package body Motors is

   -- made this function to convert the 0-100 range to the 0-4095 range used by the motor driver
   -- my reason for 0-100 range is that it is easier to think about and use, and it is more intuitive for the user
   function To_Driver_speed (Motor_Speed : Throttle) return HAL.UInt12 is
   begin
      return HAL.UInt12 ((Integer (Motor_Speed) * 4095) / 100);
   end To_Driver_speed;

   procedure Forward (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Forward,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Forward;

   procedure Backward (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Backward,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Backward;

   procedure Strafe_Left (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Left,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Strafe_Left;

   procedure Strafe_Right (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Right,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Strafe_Right;

   procedure Rotate_Left (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Rotating_Left,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Rotate_Left;

   procedure Rotate_Right (Motor_Speed : Throttle) is
      Wheel_Speed : constant HAL.UInt12 := To_Driver_speed (Motor_Speed);
   begin
      MicroBit.MotorDriver.Drive
        (MicroBit.MotorDriver.Rotating_Right,
         (Wheel_Speed, Wheel_Speed, Wheel_Speed, Wheel_Speed));
   end Rotate_Right;

   procedure Stop is
   begin
      MicroBit.MotorDriver.Drive (MicroBit.MotorDriver.Stop);
   end Stop;

end Motors;

