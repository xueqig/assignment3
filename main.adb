-- Task 4:
-- Part 1: Security Properties:
-- 1. The arithmetic operations, load, store, remove, and lock operations can 
-- only be performed when the calculator is in unlocked state.

-- In main.adb, we define a variable 'isLocked' to show the state of calculator.
-- We only allow user to perform arithmetic operations, load, store, remove, and 
-- lock operations when isLocked is True.

-- 2. The Unlock operation can only ever be performed when the calculator is 
-- in the locked state.

-- In pinmanager.ads, the precondition of unlock function is: 'isLocked = True',
-- which ensure that unlock can only be performed when the calculator is locked.

-- 3. The Lock operation, when it is performed, should update the master PIN 
-- with the new PIN that is supplied.


-- Part 2: Additional Security Properties:
-- 1. The PIN should be a 4-digits string in range of 0000..9999 
-- The function IsPin is implemented in the PIN manager by returning a boolean
-- value to show the input PIN is valid or invalid.

-- The precondition of IsPin:
-- pre => (if input'length > 0 then (input'First <= input'Last)),

-- It holds the basic relationship for the index of a incoming string

-- The postcondition of IsPin:
-- post =>  (if IsPin'Result = True then
--                   (for all I in Input'First..Input'Last =>
--                        (Input'First <= Input'Last
--                         and input(I) >='0'
--                         and Input(I) <= '9'))) and 
--         (if IsPin'Result = True then input'Length = 4);

-- It make sure that if the incoming string is acceptable as a PIN, it will assert that 
-- every character within that PIN will only contains number instead of other character, 
-- as well as the length of the PIN should be 4 in the end


pragma SPARK_Mode (On);

with StringToInteger;
with VariableStore;
with MyCommandLine;
with MyString;
with MyStringTokeniser;
with PIN;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with PinManager;
with Operation;
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
   -- Lock Booleans
   isLocked : Boolean := True;
   
   I : Integer;
   pragma Unreferenced(I);
   
begin
   VariableStore.Init(DB);
   Stack.Init_Stack(calStack);
   
   -- Check if a master pin is provided
   if MyCommandLine.Argument_Count = 1 then
      -- Check if the master pin has length of 4
      if MyCommandLine.Argument(1)'Length = 4 then
         declare
            P: String(1..4) := MyCommandLine.Argument(1);
         begin
            -- Check if the argument string is digital PIN
            if PinManager.IsPin(P) then
               PIN2 := PIN.From_String(P);
               -- Check if the PINs are equal
               if not PIN."=" (PIN1, PIN2) then
                  Put_Line ("Master pin does not match!");
                  return;
               end if;
            else
               Put_Line ("Invalid master pin format! The pin should be digital pin in range of 0000..9999.");
               return;
            end if;
         end;
      else
         Put_Line ("Invalid master pin format! The length of pin should be 4.");
         return;
      end if; 
   else
      Put_Line ("Master pin is not provided or the number of arguements is greater than 1.");
      return;
   end if;

   -- Calculator Starts
   while True loop
      pragma Loop_Invariant (Stack.Get_Size(calStack) >= 0);
      
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
                        else
                           Put_Line ("Stack is empty! Nothing to pop!");
                        end if;
                     elsif TokStr = "list" then
                        Stack.List (DB);
                     elsif TokStr = "+" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Addition(calStack);
                        else
                           Put_Line("Not enough operands on stack! '+' requires 2 numbers");
                        end if;
                     elsif TokStr = "-" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Subtraction(calStack);
                        else
                           Put_Line("Not enough operands on stack! '-' requires 2 numbers");
                        end if;
                     elsif TokStr = "*" then
                        if Stack.Get_Size(calStack) >= 2 and Stack.Get_Size(calStack) <= Stack.Max_Size then
                           OPERATION.Multiplication(calStack);
                        else
                           Put_Line("Not enough operands on stack ! '*' requires 2 numbers");
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
                           Put_Line("Not enough operands on stack! '/' requires 2 numbers");
                        end if;
                     else
                        Put_Line("Invalid command!");
                        exit;
                     end if;
                  else
                     Put_Line ("Please unlock the calculator to perform operations.");
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
                           else 
                              Put_Line("Stack has reached the maximum size!");
                           end if;
                        elsif TokStr = "load" then
                           if Stack.Get_Size(calStack) < Stack.Max_Size and then 
                             TokStr2'Length < VariableStore.Max_Variable_Length and then 
                             VariableStore.Has_Variable(DB, VariableStore.From_String(TokStr2)) then
                              Stack.Load(calStack, TokStr2, DB);
                           else
                              Put_Line("Variable does not exit!");
                           end if;
                        elsif TokStr = "store" then
                           if Stack.Get_Size(calStack) > 0 then
                              Stack.Store(calStack, TokStr2, DB);
                           else
                              Put_Line("Stack is empty! Nothing to store!");
                           end if;
                        elsif TokStr = "remove" then
                           if TokStr2'Length < VariableStore.Max_Variable_Length and then 
                             VariableStore.Has_Variable(DB, VariableStore.From_String(TokStr2)) then
                              Stack.Remove(TokStr2, DB);
                           else
                              Put_Line("Variable does not exit!");
                           end if;
                        elsif TokStr = "lock" then
                           if PinManager.IsPin(TokStr2) then
                              PIN1 := PIN.From_String(TokStr2);
                              PinManager.lock(isLocked);
                           end if;
                        elsif TokStr = "unlock" then
                           Put_Line ("Already unlocked!");
                        else
                           Put_Line ("Invalid command!");
                           exit;
                        end if; 
                     else 
                        if TokStr = "unlock" and PinManager.IsPin(TokStr2) then
                           PIN2 := PIN.From_String(TokStr2);
                           PinManager.Unlock(PIN1,PIN2,isLocked);
                        elsif TokStr = "lock" then
                           Put_Line ("Already locked!");
                        else
                           Put_Line("Please unlock the calculator to perform operations!");
                           exit;
                        end if;
                     end if;
                  end;
               else
                  Put_Line ("Invalid command!");
                  exit;
               end if;
            end;
         else 
            Put_Line ("Invalid command!" );
            exit;
         end if;
      end;
   end loop;
