with Motors;

procedure Main is
begin

   Motors.Forward(50);

   delay 2.0;

   Motors.Backward(100);

   delay 2.0;

   Motors.Stop;

   loop
      null;
   end loop;

end Main;