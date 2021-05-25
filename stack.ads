with VariableStore;

package Stack with SPARK_Mode is
   type Stack_Type is private;
   Max_Size : constant Natural := 512;

   procedure Init_Stack(Stack: out Stack_Type) with
     Post => Get_Size(Stack) = 0 and
     (for all I in 1..Max_Size => Get_Element(Stack, I) = 0);

   procedure Push(Stack: in out Stack_Type; Value : in Integer; isLocked: in Boolean) with
     Pre => isLocked = False and Get_Size(Stack) >= 0 and Get_Size(Stack) < Max_Size,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) + 1 and
     Value = Get_Element(Stack, Get_Size(Stack)) and
     (for all I in 1..Get_Size(Stack'Old) => Get_Element(Stack, I) = Get_Element(Stack'Old, I));

   procedure Pop(Stack : in out Stack_Type; Value : out Integer; isLocked: in Boolean) with
     Pre => isLocked = False and Get_Size(Stack) > 0 and Get_Size(Stack) <= Max_Size,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) - 1 and
     Value = Get_Element(Stack, Get_Size(Stack'Old)) and
     (for all I in 1..Max_Size => Get_Element(Stack, I) = Get_Element(Stack'Old, I));

   procedure Load(Stack : in out Stack_Type; Variable : in String; Database : in VariableStore.Database;
                  isLocked: in Boolean) with
     Pre => isLocked = False and Get_Size(Stack) < Max_Size,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) + 1 and
     VariableStore.Get(Database, VariableStore.From_String(Variable)) = Get_Element(Stack, Get_Size(Stack)) and
     (for all I in 1..Get_Size(Stack'Old) => Get_Element(Stack, I) = Get_Element(Stack'Old, I));

   procedure Store(Stack : in out Stack_Type; Variable : in String; Database : in out VariableStore.Database;
                   isLocked: in Boolean) with
     Pre => isLocked = False and Get_Size(Stack) > 0,
     Post => Get_Size(Stack) = Get_Size(Stack'Old) - 1 and
     (for all I in 1..Max_Size => Get_Element(Stack, I) = Get_Element(Stack'Old, I));

   procedure List(Database : VariableStore.Database; isLocked: in Boolean) with
     Pre => isLocked = False;

   procedure Remove(Variable: in String; Database : in out VariableStore.Database;
                    isLocked: in Boolean) with
     Pre => isLocked = False,
     Post => VariableStore.Has_Variable(Database, VariableStore.From_String(Variable)) = False;

   function Get_Size(Stack : in Stack_Type) return Natural;

   function Get_Element(Stack : in Stack_Type; Index : in Integer) return Integer;

private
   type Stack_Data is array (1 .. Max_Size) of Integer;

   type Stack_Type is record
      Size : Natural := 0;
      Data : Stack_Data;
   end record;

end Stack;
