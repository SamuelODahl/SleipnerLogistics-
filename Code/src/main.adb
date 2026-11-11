-- tasks starts automatically when the program starts
with Sense_Task;
with Think_Task;
with Act_Task;

procedure Main is
begin
   -- keep the main task running so that the other tasks can run
   loop
      delay 1.0;
   end loop;

end Main;