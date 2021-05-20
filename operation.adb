package body OPERATION with SPARK_Mode is
   
--    procedure Addition(S: in out SimpleStack) is
--         I : Integer;
--         J : Integer;
--         Result : Integer;
--    begin
--         S.pop(S,I);
--         S.pop(S,J);
--         Result := I + J;
--         S.push(S,Result);  
--     end Addition;

    function Subtraction(I: in Integer; J: in Integer) return Integer is
        Result : Integer;
   begin
        Result := J - I;
        return Result;  
    end Subtraction;

    function Multiplication(I: in Integer; J: in Integer) return Integer is
        Result : Integer;
   begin
        Result := I * J;
        return Result;  
    end Multiplication;

    function Division(I: in Integer; J: in Integer) return Integer is
        Result : Integer;
   begin
        Result := J / I;
        return Result;  
    end Division;

end OPERATION;