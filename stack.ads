package Stack with SPARK_Mode is
   type Stack_Type is private;

   procedure Push(Stack: in out Stack_Type; Value : in Integer);

   procedure Pop(Stack : in out Stack_Type; Value : out Integer) with
     Pre => Get_Size(Stack) > 0;

   procedure Load(Stack : in out Stack_Type; Variable : in String);

   procedure Store(Stack: in out Stack_Type; Variable: in String) with
     Pre => Get_Size(Stack) > 0;

   procedure List;

   procedure Remove(Variable: in String);

   function Get_Size(Stack : in Stack_Type) return Integer;

private
   type Stack_Data is array (1 .. 100) of Integer;

   type Stack_Type is record
      Size : Integer := 0;
      Data : Stack_Data;
   end record;

end Stack;
