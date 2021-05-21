package body OPERATION with SPARK_Mode is
    I : Integer := 0;
    J : Integer := 0;
    Result : Integer := 0;
    
    procedure Addition(S: in out Stack.Stack_Type) is
    begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := I + J;
        Stack.push(S,Result);  
    end Addition;

    procedure Subtraction(S: in out Stack.Stack_Type) is
    begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := J - I;
        Stack.push(S,Result);  
    end Subtraction;

    procedure Multiplication(S: in out Stack.Stack_Type) is
    begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := I * J;
        Stack.push(S,Result);  
    end Multiplication;

    procedure Division(S: in out Stack.Stack_Type) is
    begin
        Stack.pop(S,I);
        Stack.pop(S,J);
        Result := J / I;
        Stack.push(S,Result);  
    end Division;

end OPERATION;
