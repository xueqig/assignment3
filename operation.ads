with Stack;

package OPERATION with SPARK_Mode is
    -- package SS is new SimpleStack(100, Integer,0);

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
        Pre => (Stack.Get_Size(S) >= 2),
        Post => (Stack.Get_Size(S) = (Stack.Get_Size(S'Old) - 1));

end OPERATION;