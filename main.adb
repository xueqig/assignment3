pragma SPARK_Mode (On);

with StringToInteger;
with VariableStore;
with MyCommandLine;
with MyString;
with MyStringTokeniser;
with PIN;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
-------------------------------------------New-----------------------------------------
with Stacks;
-------------------------------------------New-----------------------------------------

with Ada.Long_Long_Integer_Text_IO;

procedure Main is
   DB : VariableStore.Database;
   PIN1  : PIN.PIN := PIN.From_String("1234");
   PIN2  : PIN.PIN := PIN.From_String("1234");
   package Lines is new MyString(Max_MyString_Length => 2048);
   S  : Lines.MyString;
-------------------------------------------New-----------------------------------------
   St : Stacks.Stack_Type;
   V : Integer;

begin
   VariableStore.Init(DB);
   Stacks.Init_Stack(St);

   while True loop
      Lines.Get_Line(S);
      declare
         T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
         NumTokens : Natural;
      begin
         MyStringTokeniser.Tokenise(Lines.To_String(S),T,NumTokens);
         if NumTokens = 1 then
            declare
               TokStr1 : String := Lines.To_String(Lines.Substring(S,T(1).Start,T(1).Start+T(1).Length-1));
            begin
               if TokStr1 = "pop" then
                  if Stacks.Get_Size(St) > 0 then
                     Stacks.Pop(St, V);
                     Put_Line(Integer'Image(V));
                  end if;
               elsif TokStr1 = "list" then
                  Stacks.List(DB);
               else
                  Put_Line("Invalid command!");
               end if;
            end;
         elsif NumTokens = 2 then
            declare
               TokStr1 : String := Lines.To_String(Lines.Substring(S,T(1).Start,T(1).Start+T(1).Length-1));
               TokStr2 : String := Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1));
            begin
               if TokStr1 = "push" then
                  if Stacks.Get_Size(St) < Stacks.Max_Size then
                     Stacks.Push(St, StringToInteger.From_String(TokStr2));
                  end if;
               elsif TokStr1 = "load" then
                  if Stacks.Get_Size(St) < Stacks.Max_Size then
                     Stacks.Load(St, TokStr2, DB);
                  end if;
               elsif TokStr1 = "store" then
                  if Stacks.Get_Size(St) > 0 then
                     Stacks.Store(St, TokStr2, DB);
                  end if;
               elsif TokStr1 = "remove" then
                  Stacks.Remove(TokStr2, DB);
               else
                  Put_Line("Invalid command!");
               end if;
            end;
         else
            Put_Line("Invalid command!");
         end if;
      end;
   end loop;
-------------------------------------------New-----------------------------------------

   If PIN."="(PIN1,PIN2) then
      Put_Line("The two PINs are equal, as expected.");
   end if;

   declare
      Smallest_Integer : Integer := StringToInteger.From_String("-2147483648");
      R : Long_Long_Integer :=
        Long_Long_Integer(Smallest_Integer) * Long_Long_Integer(Smallest_Integer);
   begin
      Put_Line("This is -(2 ** 32) (where ** is exponentiation) :");
      Put(Smallest_Integer); New_Line;

      if R < Long_Long_Integer(Integer'First) or
         R > Long_Long_Integer(Integer'Last) then
         Put_Line("Overflow would occur when trying to compute the square of this number");
      end if;

   end;
   Put_Line("2 ** 32 is too big to fit into an Integer...");
   Put_Line("Hence when trying to parse it from a string, it is treated as 0:");
   Put(StringToInteger.From_String("2147483648")); New_Line;


end Main;
