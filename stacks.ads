with VariableStore;

package Stacks with SPARK_Mode is
   type Stack_Type is private;
   Max_Size : constant Natural := 1000;

   procedure Init_Stack(Stack: out Stack_Type) with
     Post => Stack.Size = 0;

   procedure Push(Stack: in out Stack_Type; Value : in Integer) with
     Pre => Get_Size(Stack) < Max_Size,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) + 1;

   procedure Pop(Stack : in out Stack_Type; Value : out Integer) with
     Pre => Get_Size(Stack) > 0,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) - 1;

   procedure Load(Stack : in out Stack_Type; Variable : in String; Database : in VariableStore.Database) with
     Pre => Get_Size(Stack) < Max_Size,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) + 1;

   procedure Store(Stack : in out Stack_Type; Variable : in String; Database : in out VariableStore.Database) with
     Pre => Get_Size(Stack) > 0,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) - 1;

   procedure List(Database : VariableStore.Database);

   procedure Remove(Variable: in String; Database : in out VariableStore.Database);

   function Get_Size(Stack : in Stack_Type) return Integer;

   function Get_Element(Stack : in Stack_Type; Index : in Integer) return Integer;

private
   type Stack_Data is array (1 .. Max_Size) of Integer;

   type Stack_Type is record
      Size : Natural := 0;
      Data : Stack_Data;
   end record;

end Stacks;
