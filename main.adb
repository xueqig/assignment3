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

-----------------------------------------------------------
with Ada.Integer_Text_IO ;
with Ada.Text_IO;
with Ada.Strings;

with OPERATION;
with Stack;

procedure Main is
   DB : VariableStore.Database;
   V1 : VariableStore.Variable := VariableStore.From_String("Var1");
   PIN1  : PIN.PIN := PIN.From_String("1234");
   PIN2  : PIN.PIN := PIN.From_String("1234");
   package Lines is new MyString(Max_MyString_Length => 2048);
   S  : Lines.MyString;

   -- Loop Variable to Exit if Wrong Input is Provided
   Finished : Boolean := False;

   -- Integer Stack
   calStack : Stack.Stack_Type;
   
begin
   VariableStore.Init(DB);
   Stack.Init_Stack(calStack);
   
   
   loop
      Put("locked> ");
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
                  if TokStr = "pop"  then
                  declare
                     I : Integer;
                  begin
                     if Stack.Get_Size(calStack) >0 then
                        Stack.Pop(calStack,I);
                        Put(I); Put_Line ("");
                     else
                        Put_Line ("Stack is Empty ! Nothing to Pop");
                        Finished := True;
                        exit when Finished;
                     end if;
                  end;
                  elsif TokStr = "list" then
                  begin
                     Stack.List (DB);
                  end;  
                  elsif TokStr = "+" then
                  begin
                     if Stack.Get_Size(calStack) >=2 then
                        OPERATION.Addition(calStack);
                     else
                        Put_Line("Not Enough Operands on Stack ! '+' requires 2 numbers");
                        Finished := True;
                        exit when Finished;
                     end if;
                  end;
                  elsif TokStr = "-" then
                  begin
                     if Stack.Get_Size(calStack) >=2 then
                        OPERATION.Subtraction(calStack);
                     else
                        Put_Line("Not Enough Operands on Stack ! '-' requires 2 numbers");
                        Finished := True;
                        exit when Finished;
                     end if;
                  end;
                  elsif TokStr = "*" then
                     begin
                        if Stack.Get_Size(calStack) >=2 then
                           OPERATION.Multiplication(calStack);
                        else
                           Put_Line("Not Enough Operands on Stack ! '*' requires 2 numbers");
                           Finished := True;
                           exit when Finished;
                        end if;
                     end;
                  elsif TokStr = "/" then
                     begin
                        if Stack.Get_Size(calStack) >=2 then
                           OPERATION.Division(calStack);
                        else
                           Put_Line("Not Enough Operands on Stack ! '/' requires 2 numbers");
                           Finished := True;
                           exit when Finished;
                        end if;
                     end;
                  else
                     Put_Line("Invalid Command !");
                     Finished := True;
                     exit when Finished;
                  end if;
               elsif NumTokens = 2 then
               declare
                  TokStr2 : String := Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1));
                  value : Integer;
               begin
                  if TokStr = "push" then
                  -- Converting the value passed in PUSH command to Integer
                     value := Integer'Value (TokStr2);
                     Stack.Push(calStack,value);
                  elsif TokStr = "load" then
                        Stack.Load(calStack, TokStr2, DB);
                  elsif TokStr = "store" then
                        Stack.Store(calStack, TokStr2, DB);
                  elsif TokStr = "remove" then
                        Stack.Remove(TokStr2, DB);
                  else
                        Put_Line("Invalid command!");
                        Finished := True;
                        exit when Finished;
                  end if;
               end;
               else
                  Put_Line ("Invalid Command");
                  Finished := True;
                  exit when Finished;
               end if;
            end;
         else 
            Put_Line ("Invalid Command ! Try 'push 5' " );
            Finished := True;
            exit when Finished;
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
