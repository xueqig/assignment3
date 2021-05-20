with SimpleStack;
with MyStringTokeniser;

package OPERATION with SPARK_Mode is
    -- package SS is new SimpleStack(100, Integer,0);

    -- procedure Addition(S: in out SimpleStack);
    --  with
    --     Pre => (Stack.Size(S) >= 2),
    --     Post => (Stack.Size(S) = (Stack.Size(S'Old) - 1));


    function Subtraction(I: Integer; J: Integer) return Integer;
    function Multiplication(I: Integer; J: Integer) return Integer;
    function Division(I: Integer; J: Integer) return Integer;

    

end OPERATION;