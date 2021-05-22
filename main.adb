pragma SPARK_Mode (On);

with StringToInteger;
with VariableStore;
with MyCommandLine;
with MyString;
with MyStringTokeniser;
with PIN;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Ada.Long_Long_Integer_Text_IO;

with Ada.Integer_Text_IO ;
with Ada.Text_IO;
with Ada.Strings;

with passwordmanager;
with OPERATION;
with Stack;

procedure Main is
   DB : VariableStore.Database;
   
   -- Master PIN
   PIN1  : PIN.PIN := PIN.From_String("1234");
   -- User Provide PIN via command argument
   PIN2  : PIN.PIN;
   
   package Lines is new MyString(Max_MyString_Length => 2048);
   S  : Lines.MyString;
   
   -- Integer Stack
   calStack : Stack.Stack_Type;
   --Lock Booleans
   isLocked : Boolean := True;
   
   I : Integer;
   
begin
   VariableStore.Init(DB);
   Stack.Init_Stack(calStack);
   
   -- Checking if a master password is provided
   if MyCommandLine.Argument_Count = 1 then
      if MyCommandLine.Argument(1)'Length = 4 then
         declare
            P: String(1..4) := MyCommandLine.Argument(1);
         begin
            -- check if the argument string is PIN
            if passwordmanager.IsPin(P) then
               PIN2 := PIN.From_String(P);
               -- check if the PINs are equal
               if not PIN."=" (PIN1, PIN2) then
                  Put_Line ("Invalid Master Password!");
                  return;
               end if;
            else
               Put_Line ("Invalid Master Password!");
               return;
            end if;
         end;
      end if;
      
   else
      Put_Line ("Master Password Not Provided!");
      return;
   end if;

   --Calculator Starts
   loop
      if isLocked = True then
         Put("locked> ");
      else
         Put("unlocked> ");
      end if;
      Lines.Get_Line(S);
      declare
         T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
         NumTokens : Natural;
      begin
         MyStringTokeniser.Tokenise(Lines.To_String(S),T,NumTokens);
         if NumTokens > 0 and  NumTokens <= 3 then
            declare
               TokStr : String := Lines.To_String(Lines.Substring(S,T(1).Start,T(1).Start+T(1).Length-1));
            begin
               if NumTokens = 1 then
                  if not isLocked then 
                     if TokStr = "pop" then
                        if Stack.Get_Size(calStack) > 0 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           Stack.Pop(calStack,I);
                           Put(I); Put_Line ("");
                        else
                           Put_Line ("Stack is Empty! Nothing to Pop!");
                           exit;
                        end if;
                     elsif TokStr = "list" then
                        Stack.List (DB);
                     elsif TokStr = "+" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Addition(calStack);
                        else
                           Put_Line("Not Enough Operands on Stack! '+' requires 2 numbers");
                           exit;
                        end if;
                     elsif TokStr = "-" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Subtraction(calStack);
                        else
                           Put_Line("Not Enough Operands on Stack! '-' requires 2 numbers");
                           exit;
                        end if;
                     elsif TokStr = "*" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Multiplication(calStack);
                        else
                           Put_Line("Not Enough Operands on Stack ! '*' requires 2 numbers");
                           exit;
                        end if;
                     elsif TokStr = "/" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           if Stack.Get_Element(calStack, Stack.Get_Size(calStack) - 1) /= 0 then
                              OPERATION.Division(calStack);
                           else
                              Put_Line("Invalid operation! Division by zero!");
                              exit;
                           end if;
                        else
                           Put_Line("Not Enough Operands on Stack! '/' requires 2 numbers");
                           exit;
                        end if;
                     else
                        Put_Line("Invalid Command!");
                        exit;
                     end if;
                  else
                     Put_Line ("Please unlock the Calculator to perform operations.");
                     exit;
                  end if;
               elsif NumTokens = 2 then
                  declare
                     TokStr2 : String := Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1));
                  begin
                     if isLocked = False then
                        if TokStr = "push" then
                           if Stack.Get_Size(calStack) >= 0 and Stack.Get_Size(calStack) < Stack.Max_Size then
                              Stack.Push(calStack, StringToInteger.From_String(TokStr2));
                           end if;
                        elsif TokStr = "load" then
                           if Stack.Get_Size(calStack) < Stack.Max_Size and then 
                             TokStr2'Length < VariableStore.Max_Variable_Length and then 
                             VariableStore.Has_Variable(DB, VariableStore.From_String(TokStr2)) then
                              Stack.Load(calStack, TokStr2, DB);
                           else
                              Put_Line("Variable does not exit!");
                              exit;
                           end if;
                        elsif TokStr = "store" then
                           if Stack.Get_Size(calStack) > 0 then
                              Stack.Store(calStack, TokStr2, DB);
                           end if;
                        elsif TokStr = "remove" then
                           if TokStr2'Length < VariableStore.Max_Variable_Length and then 
                             VariableStore.Has_Variable(DB, VariableStore.From_String(TokStr2)) then
                              Stack.Remove(TokStr2, DB);
                           else
                              Put_Line("Variable does not exit!");
                              exit;
                           end if;
                        elsif TokStr = "lock" then
                           if passwordmanager.IsPin(TokStr2) then
                              PIN1 := PIN.From_String(TokStr2);
                              PasswordManager.lock(isLocked);
                           end if;
                        elsif TokStr = "unlock" then
                           Put_Line ("Already unlocked!");
                        else
                           Put_Line ("Invalid Command");
                           exit;
                        end if; 
                     else 
                        if TokStr = "unlock" and passwordmanager.IsPin(TokStr2) then
                           PIN2 := PIN.From_String(TokStr2);
                           PasswordManager.Unlock(PIN1,PIN2,isLocked);
                        elsif TokStr = "lock" then
                           Put_Line ("Already Locked!");
                        else
                           Put_Line("Please unlock the Calculator to perform operations.");
                           exit;
                        end if;
                     end if;
                  end;
               else
                  Put_Line ("Invalid Command");
                  exit;
               end if;
            end;
         else 
            Put_Line ("Invalid Command! Try 'push 5' " );
            exit;
         end if;
      end;
   end loop;
      
end Main;
