with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Microbit.MotorDriver;

-- USN PROJECT TEMPLATE INTELLIGENT REAL-TIME SYSTEMS
-- Project name: Sleipner Logistics
-- Project members: Samuel Olsson Dahl, Daniel Gulliksrud Nilssen, Jostein Moen Johansen

procedure Main is
begin
   MicroBit.MotorDriver.Drive (
      MicroBit.MotorDriver.Forward, (4095,0,0,0));

   delay 1.0;

   MicroBit.MotorDriver.Drive (
      MicroBit.MotorDriver.Stop);

   loop
      null;
   end loop;

end Main; 