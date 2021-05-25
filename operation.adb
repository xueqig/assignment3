with Stack;

package body Operation with SPARK_Mode is
   I : Integer := 0;
   J : Integer := 0;
   Result : Integer := 0;
    
   procedure Addition(S: in out Stack.Stack_Type; isLocked: in Boolean) is
   begin
      Stack.Pop(S,I, isLocked);
      Stack.Pop(S,J, isLocked);
      
      -- Check if addition will cause integer overflow
      -- If overflow happens, push 0 to stack
      if (J < 1 and then I >= Integer'First - J) or (J > -1 and then I <= Integer'Last - J) then
         Result := I + J;
         Stack.Push(S, Result, isLocked);
      else
         Stack.Push(S, 0, isLocked);
      end if;
       
   end Addition;

   procedure Subtraction(S: in out Stack.Stack_Type; isLocked: in Boolean) is
   begin
      Stack.Pop(S,I, isLocked);
      Stack.Pop(S,J, isLocked);
      
      -- Check if substraction will cause integer overflow
      -- If overflow happens, push 0 to stack
      if (J > -1 and then I >= Integer'First + J) or (J < 1 and then I <= Integer'Last + J) then
         Result := I - J;
         Stack.Push(S, Result, isLocked);  
      else
         Stack.Push(S, 0, isLocked);
      end if;
   end Subtraction;

   procedure Multiplication(S: in out Stack.Stack_Type; isLocked: in Boolean) is
   begin
      Stack.Pop(S,I, isLocked);
      Stack.Pop(S,J, isLocked);
      
      -- Check if multiplication will cause integer overflow
      -- If overflow happens, push 0 to stack
      if (J < -1 and then (I <= Integer'First / J and I >= Integer'Last / J)) or 
        (J = -1 and I /= Integer'First) or 
        (J = 0) or 
        (J > 0 and then (I >= Integer'First / J and I <= Integer'Last / J)) then
         Result := I * J;
         Stack.push(S,Result, isLocked);
      else
         Stack.Push(S, 0, isLocked);
      end if;
        
   end Multiplication;

   procedure Division(S: in out Stack.Stack_Type; isLocked: in Boolean) is
   begin
      Stack.Pop(S,I, isLocked);
      Stack.Pop(S,J, isLocked);
      
      -- Check if division by zero
      -- If division by zero happens, push 0 to stack
      if J /= 0 then 
         -- Check if division will cause integer overflow 
         -- If overflow happens, push 0 to stack
         if (J /= -1) or (J = -1 and I /= Integer'First) then
            Result := I / J;
            Stack.push(S,Result, isLocked);  
         else
            Stack.Push(S, 0, isLocked);
         end if;
      else
         Stack.Push(S, 0, isLocked);
      end if;
   end Division;

end Operation;
