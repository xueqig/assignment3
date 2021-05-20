package body OPERATION with SPARK_Mode is
   
   procedure Addition(S: in out Stack.Stack_Type) is
        I : Integer;
        J : Integer;
        Result : Integer;
   begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := I + J;
        Stack.push(S,Result);  
    end Addition;

    procedure Subtraction(S: in out Stack.Stack_Type) is
        I : Integer;
        J : Integer;
        Result : Integer;
   begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := J - I;
        Stack.push(S,Result);  
    end Subtraction;

    procedure Multiplication(S: in out Stack.Stack_Type) is
        I : Integer;
        J : Integer;
        Result : Integer;
   begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := I * J;
        Stack.push(S,Result);  
    end Multiplication;

    procedure Division(S: in out Stack.Stack_Type) is
        I : Integer;
        J : Integer;
        Result : Integer;
   begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := J / I;
        Stack.push(S,Result);  
    end Division;

end OPERATION;