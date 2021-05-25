with Stack;

package Operation with SPARK_Mode is

   procedure Addition(S: in out Stack.Stack_Type; isLocked: in Boolean) with
     Pre => isLocked = False and Stack.Get_Size(S) >= 2 and Stack.Get_Size(S) <= Stack.Max_Size,
     Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
   
   procedure Subtraction(S: in out Stack.Stack_Type; isLocked: in Boolean) with
     Pre => isLocked = False and (Stack.Get_Size(S) >= 2) and Stack.Get_Size(S) <= Stack.Max_Size,
     Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
    
   procedure Multiplication(S: in out Stack.Stack_Type; isLocked: in Boolean) with
     Pre => isLocked = False and (Stack.Get_Size(S) >= 2) and Stack.Get_Size(S) <= Stack.Max_Size,
     Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
   
   procedure Division(S: in out Stack.Stack_Type; isLocked: in Boolean) with
     Pre => isLocked = False and (Stack.Get_Size(S) >= 2) and Stack.Get_Size(S) <= Stack.Max_Size,
     Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));

end Operation;
