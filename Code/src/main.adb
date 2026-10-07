with Control;
with Motors;

procedure Main is
begin
   loop
      Control.Update;
      delay 0.07;
   end loop;
end Main;

--  with MicroBit.Ultrasonic;
--  with MicroBit.Console; use MicroBit.Console;
--  with MicroBit.Types; use MicroBit.Types;
--  use MicroBit;

--  procedure Main is

--     package Sensor is new Ultrasonic (MB_P0, MB_P1);

--     Distance : Distance_cm;

--  begin
--     loop
--        Distance := Sensor.Read;

--        Put_Line ("Distance: " & Distance_cm'Image (Distance));

--        delay 0.7;
--     end loop;
--  end Main;