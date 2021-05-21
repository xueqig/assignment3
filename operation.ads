with Stack;

package OPERATION with SPARK_Mode is

    procedure Addition(S: in out Stack.Stack_Type) with
        Pre => (Stack.Get_Size(S) >= 2),
        Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
    
    procedure Subtraction(S: in out Stack.Stack_Type) with
        Pre => (Stack.Get_Size(S) >= 2),
        Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
    
    procedure Multiplication(S: in out Stack.Stack_Type) with
        Pre => (Stack.Get_Size(S) >= 2),
        Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));
    
    procedure Division(S: in out Stack.Stack_Type) with
        Pre => (Stack.Get_Size(S) >= 2) and Stack.Get_Element(S, Stack.Get_Size(S) - 1) /= 0,
        Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));

end OPERATION;
