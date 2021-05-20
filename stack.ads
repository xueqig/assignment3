with VariableStore;

package Stack with SPARK_Mode is
   type Stack_Type is private;

   procedure Init_Stack(Stack: out Stack_Type);

   procedure Push(Stack: in out Stack_Type; Value : in Integer);

   procedure Pop(Stack : in out Stack_Type; Value : out Integer);

   procedure Load(Stack : in out Stack_Type; Variable : in String; Database : in VariableStore.Database);

   procedure Store(Stack : in out Stack_Type; Variable : in String; Database : in out VariableStore.Database);

   procedure List(Database : VariableStore.Database);

   procedure Remove(Variable: in String; Database : in out VariableStore.Database);

   function Get_Size(Stack : in Stack_Type) return Integer;

private
   type Stack_Data is array (1 .. 100) of Integer;

   type Stack_Type is record
      Size : Integer := 0;
      Data : Stack_Data;
   end record;

end Stack;
