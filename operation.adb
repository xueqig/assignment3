with Stack;

package body OPERATION with SPARK_Mode is
   I : Integer := 0;
   J : Integer := 0;
   Result : Integer := 0;
    
   procedure Addition(S: in out Stack.Stack_Type) is
   begin
      Stack.Pop(S,I);
      Stack.Pop(S,J);
      
      -- Check if addition will cause integer overflow
      if (J < 1 and then I >= Integer'First - J) or (J > -1 and then I <= Integer'Last - J) then
         Result := I + J;
         Stack.Push(S, Result);
      end if;
       
   end Addition;

   procedure Subtraction(S: in out Stack.Stack_Type) is
   begin
      Stack.Pop(S,I);
      Stack.Pop(S,J);
      
      -- Check if substraction will cause integer overflow
      if (J > -1 and then I >= Integer'First + J) or (J < 1 and then I <= Integer'Last + J) then
         Result := I - J;
         Stack.Push(S, Result);  
      end if;
   end Subtraction;

   procedure Multiplication(S: in out Stack.Stack_Type) is
   begin
      Stack.Pop(S,I);
      Stack.Pop(S,J);
      
      -- Check if multiplication will cause integer overflow
      if (J < -1 and then (I <= Integer'First / J and I >= Integer'Last / J)) or 
        (J = -1 and I /= Integer'First) or 
        (J = 0) or 
        (J > 0 and then (I >= Integer'First / J and I <= Integer'Last / J)) then
         Result := I * J;
         Stack.push(S,Result);
      end if;
        
   end Multiplication;

   procedure Division(S: in out Stack.Stack_Type) is
   begin
      Stack.Pop(S,I);
      Stack.Pop(S,J);
      
      if J /= 0 then 
         if (J /= -1) or (J = -1 and I /= Integer'First) then
            Result := I / J;
            Stack.push(S,Result);  
         end if;
      end if;
   end Division;

end OPERATION;
