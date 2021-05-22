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
   if MyCommandLine.Argument_Count = 1 and then MyCommandLine.Argument (1)'Length = 4 then
      declare
         P: String(1..4) := MyCommandLine.Argument(1);
      begin
         -- check if the argument string is PIN
         if passwordmanager.IsPin(P) then
            PIN2 := PIN.From_String(P);
            -- check if the PINs are equal
            if PIN."=" (PIN1, PIN2) then
               isLocked := False;
            else 
            Put_Line ("Invalid Master Password!");
            return;
            end if;
         end if;
      end;
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
                           if Stack.Get_Size(calStack) < Stack.Max_Size then
                              Stack.Load(calStack, TokStr2, DB);
                           end if;
                        elsif TokStr = "store" then
                           if Stack.Get_Size(calStack) > 0 then
                              Stack.Store(calStack, TokStr2, DB);
                           end if;
                        elsif TokStr = "remove" then
                           if TokStr2'Length < VariableStore.Max_Variable_Length and then VariableStore.Has_Variable(DB, VariableStore.From_String(TokStr2)) then
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

   
   
   -- Put(MyCommandLine.Command_Name); Put_Line(" is running!");
   -- Put("I was invoked with "); Put(MyCommandLine.Argument_Count,0); Put_Line(" arguments.");
   -- for Arg in 1..MyCommandLine.Argument_Count loop
   --    Put("Argument "); Put(Arg,0); Put(": """);
   --    Put(MyCommandLine.Argument(Arg)); Put_Line("""");
   -- end loop;

   -- VariableStore.Init(DB);
   -- Put_Line("Adding an entry to the database");
   -- VariableStore.Put(DB,V1,10);

   -- Put_Line("Reading the entry:");
   -- Put(VariableStore.Get(DB,V1));
   -- New_Line;
   
   -- Put_Line("Printing out the database: ");
   -- VariableStore.Print(DB);
   
   -- Put_Line("Removing the entry");
   -- VariableStore.Remove(DB,V1);
   -- If VariableStore.Has_Variable(DB,V1) then
   --    Put_Line("Entry still present! It is: ");
   --    Put(VariableStore.Get(DB,V1));
   --    New_Line;
   -- else
   --    Put_Line("Entry successfully removed");
   -- end if;

   -- Put_Line("Reading a line of input. Enter some text (at most 3 tokens): ");
   -- Lines.Get_Line(S);

   -- Put_Line("Splitting the text into at most 5 tokens");
   -- declare
   --    T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
   --    NumTokens : Natural;
   -- begin
   --    MyStringTokeniser.Tokenise(Lines.To_String(S),T,NumTokens);
   --    Put("You entered "); Put(NumTokens); Put_Line(" tokens.");
   --    for I in 1..NumTokens loop
   --       declare
   --          TokStr : String := Lines.To_String(Lines.Substring(S,T(I).Start,T(I).Start+T(I).Length-1));
   --       begin
   --          Put("Token "); Put(I); Put(" is: """);
   --          Put(TokStr); Put_Line("""");
   --       end;
   --    end loop;
   --    if NumTokens > 3 then
   --       Put_Line("You entered too many tokens --- I said at most 3");
   --    end if;
   -- end;

   -- If PIN."="(PIN1,PIN2) then
   --    Put_Line("The two PINs are equal, as expected.");
   -- end if;
   
   -- declare
   --    Smallest_Integer : Integer := StringToInteger.From_String("-2147483648");
   --    R : Long_Long_Integer := 
   --      Long_Long_Integer(Smallest_Integer) * Long_Long_Integer(Smallest_Integer);
   -- begin
   --    Put_Line("This is -(2 ** 32) (where ** is exponentiation) :");
   --    Put(Smallest_Integer); New_Line;
      
   --    if R < Long_Long_Integer(Integer'First) or
   --       R > Long_Long_Integer(Integer'Last) then
   --       Put_Line("Overflow would occur when trying to compute the square of this number");
   --    end if;
         
   -- end;
   -- Put_Line("2 ** 32 is too big to fit into an Integer...");
   -- Put_Line("Hence when trying to parse it from a string, it is treated as 0:");
   -- Put(StringToInteger.From_String("2147483648")); New_Line;
   
      
end Main;
