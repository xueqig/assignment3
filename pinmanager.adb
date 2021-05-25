with Ada.Text_IO;
with Ada.Characters.Handling;
with Ada.Characters.Latin_1;

package body PinManager with SPARK_Mode is
   
   procedure Unlock (P1: in PIN.PIN; P2: in PIN.PIN; isLocked: in out Boolean) is
   begin
      if (P1 = P2) then
         isLocked := False;
      end if;
   end Unlock;
   
   procedure lock (isLocked: in out Boolean; validPin : in Boolean) is
   begin
      if (isLocked = False) and validPin then
         isLocked := True;
      end if;
   end lock;
   
   function IsPin (input : in String)  return Boolean is
      ch : Character;
   begin
      if input'Length /= 4 then 
         return False;
      end if;
      
      for k in Input'Range loop
         ch := input(k);
         if ch not in '0'..'9' then
            return False;
         end if;
         pragma Loop_Invariant (for all q in Input'First..K =>
                                  (input(q) >= '0'
                                   and input(q) <= '9'));

      end loop;
      return True;
   end IsPin;

end PinManager;
