with Ada.Text_IO; use Ada.Text_IO;
with VariableStore;
with StringToInteger;

package body Stack is
   procedure Init_Stack(Stack: out Stack_Type) is
   begin
      Stack.Size := 0;
      Stack.Data := (others => 0);
   end Init_Stack;


   procedure Push(Stack: in out Stack_Type; Value : in Integer; isLocked: in Boolean) is
   begin
      Stack.Size := Stack.Size + 1;
      Stack.Data(Stack.Size) := Value;
   end Push;

   procedure Pop(Stack : in out Stack_Type; Value : out Integer; isLocked: in Boolean) is
   begin
      Value := Stack.Data(Stack.Size);
      Stack.Size := Stack.Size - 1;
   end Pop;

   procedure Load(Stack : in out Stack_Type; Variable : in String; Database : in VariableStore.Database;
                  isLocked: in Boolean) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
      Val : Integer := VariableStore.Get(Database, Var);
   begin
      Push(Stack, Val, isLocked);
   end Load;

   procedure Store(Stack : in out Stack_Type; Variable : in String; Database : in out VariableStore.Database;
                   isLocked: in Boolean) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
      Val : Integer;
   begin
      Pop(Stack, Val, isLocked);
      VariableStore.Put(Database, Var, Val);
   end Store;

   procedure List(Database : VariableStore.Database; isLocked: in Boolean) is
   begin
      VariableStore.Print(Database);
   end List;

   procedure Remove(Variable: in String; Database : in out VariableStore.Database;
                    isLocked: in Boolean) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
   begin
      VariableStore.Remove(Database, Var);
   end Remove;

   function Get_Size(Stack : Stack_Type) return Natural is
   begin
      return Stack.Size;
   end Get_Size;

   function Get_Element(Stack : in Stack_Type; Index : in Integer) return Integer is
   begin
      return Stack.Data(Index);
   end Get_Element;


end Stack;
