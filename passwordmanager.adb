with Ada.Text_IO;
with Ada.Characters.Handling;
with Ada.Characters.Latin_1;

package body passwordmanager with SPARK_Mode is
   
   procedure ReadCommand(C: in String; NumTokens: in out Natural; T: in out MyStringTokeniser.TokenArray)
   is
      Tokens : MyStringTokeniser.TokenArray := T;
   begin
      if Tokens'First <= Tokens'Last then 
         MyStringTokeniser.Tokenise(C, Tokens, NumTokens);
         if NumTokens /= 0 then
            T:= Tokens;
         end if;
      end if;
   end;
   
   procedure Unlock (P1: in PIN.PIN; P2: in PIN.PIN; isLocked: in out Boolean) is
   begin
      if (P1 = P2) then
         isLocked := False;
      end if;
   end Unlock;
   
   procedure lock (isLocked: in out Boolean) is
   begin
      if (isLocked = False) then
         isLocked := True;
      end if;
   end lock;
   
   function IsPin (input : in String)  return Boolean is
      ch : Character;
   begin
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

end passwordmanager;
